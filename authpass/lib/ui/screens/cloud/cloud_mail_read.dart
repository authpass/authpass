import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/screens/cloud/cloud_viewmodel.dart';
import 'package:authpass/ui/screens/password_list.dart';
import 'package:authpass/ui/widgets/async/retry_future_builder.dart';
import 'package:authpass/utils/constants.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/extension_methods.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:authpass/utils/theme_utils.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:flinq/flinq.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('cloud_mail_read');

class EmailReadScreen extends StatefulWidget {
  const EmailReadScreen({
    Key? key,
    required this.bloc,
    required this.emailMessage,
  }) : super(key: key);

  static MaterialPageRoute<void> route(
          AuthPassCloudBloc bloc, EmailMessage emailMessage) =>
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/email_read/'),
        builder: (_) => EmailReadScreen(
          bloc: bloc,
          emailMessage: emailMessage,
        ),
      );

  final AuthPassCloudBloc bloc;
  final EmailMessage emailMessage;

  @override
  _EmailReadScreenState createState() => _EmailReadScreenState();
}

class _EmailReadScreenState extends State<EmailReadScreen> {
  bool _forcePlainText = true;
  bool _forwarded = false;

  @override
  Widget build(BuildContext context) {
    final vm = EmailViewModel(emailMessage: widget.emailMessage);
    final kdbxBloc = context.watch<KdbxBloc>();
    return RetryStreamBuilder<EmailViewModel>(
      stream: (context) => (() async* {
        final emailMessage = widget.emailMessage;
        final mailbox =
            await widget.bloc.findMailboxByUuid(emailMessage.mailboxEntryUuid);
        if (mailbox == null) {
          _logger.warning('Unable to find mailbox for '
              'uuid ${emailMessage.mailboxEntryUuid}');
        }
        final entry =
            mailbox?.entryUuid.let((uuid) => kdbxBloc.findEntryByUuid(uuid));
        final vm2 = vm.copyWith(mailbox: mailbox, kdbxEntry: entry);
        yield vm2;
        yield vm2.copyWith(
          mimeMessage: await widget.bloc.loadMail(emailMessage),
        );
      })(),
      initialValue: vm,
      scaffoldBuilder: (context, child, snapshot) {
        var hasHtml = false;
        var hasText = false;
        if (snapshot.hasData) {
          hasHtml =
              snapshot.requireData.mimeMessage?.decodeTextHtmlPart() != null;
          hasText =
              snapshot.requireData.mimeMessage?.decodeTextPlainPart() != null;
        }
        final attachments = snapshot.data?.mimeMessage
                ?.findContentInfo(disposition: ContentDisposition.attachment) ??
            [];

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.emailMessage.subject),
            actions: <Widget>[
              if (hasText && hasHtml) ...[
                IconButton(
                    icon: _forcePlainText
                        ? const Icon(FontAwesomeIcons.html5)
                        : const Icon(FontAwesomeIcons.removeFormat),
                    onPressed: () {
                      setState(() {
                        _forcePlainText = !_forcePlainText;
                      });
                    }),
              ],
              if (attachments.isNotEmpty) ...[
                PopupMenuButton<VoidCallback>(
                  icon: const Icon(Icons.attach_file),
                  itemBuilder: (context) => attachments
                      .map(
                        (a) => PopupMenuItem(
                          value: () async {
                            final part =
                                snapshot.data!.mimeMessage!.getPart(a.fetchId)!;
                            final f = await PathUtils().saveToTempDirectory(
                                part.decodeContentBinary()!,
                                dirPrefix: nonNls('openbinary'),
                                fileName: a.fileName!);
                            _logger.fine('Opening ${f.path}');
                            final result = await OpenFile.open(f.path);
                            _logger.fine('finished opening $result');
                          },
                          child: ListTile(
                            leading: Icon(_iconFor(a)),
                            title: Text(a.fileName!),
                          ),
                        ),
                      )
                      .toList(),
                  onSelected: (item) => item(),
                )
              ],
              if (!_forwarded) ...[
                IconButton(
                  icon: const Icon(Icons.forward),
                  onPressed: () async {
                    await widget.bloc.forwardMail(widget.emailMessage);
                    setState(() {
                      _forwarded = true;
                    });
                  },
                ),
              ],
              Builder(
                builder: (context) => IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await widget.bloc.deleteMail(widget.emailMessage);
//                  Scaffold.of(context).
                    }),
              ),
            ],
          ),
          body: child,
        );
      },
      builder: (context, message) => EmailRead(
        bloc: widget.bloc,
        vm: message,
        forcePlainText: _forcePlainText,
      ),
    );
  }

  IconData _iconFor(ContentInfo a) {
    if (a.contentType!.mediaType.sub == MediaSubtype.applicationPdf) {
      return FontAwesomeIcons.filePdf;
    }
    return FontAwesomeIcons.paperclip;
  }
}

class EmailRead extends StatelessWidget {
  const EmailRead({
    Key? key,
    required this.bloc,
    required this.vm,
    this.forcePlainText = false,
  }) : super(key: key);
  final AuthPassCloudBloc bloc;
  final EmailViewModel vm;
  final bool forcePlainText;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontFamily: AuthPassTheme.monoFontFamily,
          height: 1.4,
        );
    final loc = AppLocalizations.of(context);
    final formatUtil = context.watch<FormatUtils>();
    final htmlData = vm.mimeMessage?.decodeTextHtmlPart();
    final textData = vm.mimeMessage?.decodeTextPlainPart();
    final headers = {
      loc.mailSubject:
          vm.mimeMessage?.decodeHeaderValue(MailConventions.headerSubject) ??
              vm.emailMessage.subject,
      loc.mailFrom: vm.mimeMessage
              ?.decodeHeaderMailAddressValue(MailConventions.headerFrom)
              ?.firstOrNull
              ?.toString() ??
          vm.emailMessage.sender,
      loc.mailDate: formatUtil.formatDateFull(
          vm.mimeMessage?.decodeHeaderDateValue(MailConventions.headerDate) ??
              vm.emailMessage.createdAt),
      loc.mailMailbox:
          vm.kdbxEntry?.label ?? vm.mailbox?.label.takeUnlessBlank(),
//          'To': message.decodeHeaderValue('to'),
    };
    final theme = Theme.of(context);
    final textSpans = headers.entries
        .where((element) => element.value != null)
        .expand((e) => [
              TextSpan(
                  text: e.key + CharConstants.colon + CharConstants.space,
                  style: theme.textTheme.caption),
              TextSpan(
                text: e.value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: CharConstants.newLine),
            ])
        .toList()
      ..removeLast();
    final entryVm = vm.kdbxEntry
        ?.let((entry) => EntryViewModel(entry, context.watch<KdbxBloc>()));
    const iconSize = 56.0;
    Icon fallbackIcon(BuildContext context) => Icon(
          Icons.email,
          color: theme.iconColor(null),
          size: iconSize,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Material(
          elevation: 1,
          color: theme.cardColor,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                entryVm == null
                    ? fallbackIcon(context)
                    : EntryIcon(
                        vm: entryVm,
                        fallback: (context) => EntryIcon.defaultIcon(
                            entryVm, null, theme, iconSize),
                        size: iconSize,
                      ),
                const SizedBox(width: 16),
                Expanded(
                  child: RichText(
                    text: TextSpan(children: textSpans, style: textStyle),
//                'Subject: ${message.decodeHeaderValue('subject')}\n'
//                'Date: ${formatUtil.formatDateFull(message.decodeHeaderDateValue('date'))}',
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: vm.mimeMessage == null
              ? const Center(child: CircularProgressIndicator())
              : Scrollbar(
                  child: SingleChildScrollView(
                    child: htmlData != null &&
                            (!forcePlainText || textData == null)
                        ? Theme(
                            data: authPassLightTheme,
                            child: DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: HtmlWidget(
                                htmlData,
                                onTapUrl: (link) {
                                  DialogUtils.openUrl(link);
                                },
                              ),
                            ),
                          )
                        // ? Html(
                        //     data: htmlData,
                        //     onLinkTap: (link, context, attributes, element) {
                        //       DialogUtils.openUrl(link!);
                        //     },
                        //   )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SelectableLinkify(
//                    child: Linkify(
                              text: (textData ??
                                      vm.mimeMessage?.decodeContentText() ??
                                      loc.mailNoData)
                                  .replaceAll(
                                      nonNls('\r'), CharConstants.empty),
                              maxLines: null,
                              options: const LinkifyOptions(
                                humanize: false,
                              ),
                              onOpen: (link) async {
                                await DialogUtils.openUrl(link.url);
                              },
                              style: textStyle,
                            ),
                          ),
                  ),
                ),
        ),
      ],
    );
  }
}
