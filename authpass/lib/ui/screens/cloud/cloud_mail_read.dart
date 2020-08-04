import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/theme.dart';
import 'package:authpass/ui/widgets/async/retry_future_builder.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:enough_mail/enough_mail.dart' as enough;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flinq/flinq.dart';

class EmailReadScreen extends StatefulWidget {
  const EmailReadScreen({
    Key key,
    @required this.bloc,
    @required this.emailMessage,
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
  bool _forcePlainText = false;

  @override
  Widget build(BuildContext context) {
    return RetryFutureBuilder<enough.MimeMessage>(
      produceFuture: (context) => widget.bloc.loadMail(widget.emailMessage),
      scaffoldBuilder: (context, child, snapshot) {
        bool hasHtml = false;
        bool hasText = false;
        if (snapshot.hasData) {
          hasHtml = snapshot.data.decodeTextHtmlPart() != null;
          hasText = snapshot.data.decodeTextPlainPart() != null;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.emailMessage.subject}'),
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
        message: message,
        forcePlainText: _forcePlainText,
      ),
    );
  }
}

class EmailRead extends StatelessWidget {
  const EmailRead(
      {Key key,
      @required this.bloc,
      @required this.message,
      this.forcePlainText})
      : super(key: key);
  final AuthPassCloudBloc bloc;
  final enough.MimeMessage message;
  final bool forcePlainText;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontFamily: AuthPassTheme.monoFontFamily,
          height: 1.4,
        );
    final formatUtil = context.watch<FormatUtils>();
    final htmlData = message.decodeTextHtmlPart();
    final headers = {
      'Subject': message.decodeHeaderValue('subject'),
      'From':
          message.decodeHeaderMailAddressValue('from').firstOrNull?.toString(),
      'Date': formatUtil.formatDateFull(message.decodeHeaderDateValue('date')),
//          'To': message.decodeHeaderValue('to'),
    };
    final textSpans = headers.entries
        .where((element) => element.value != null)
        .expand((e) => [
              TextSpan(text: '${e.key}: '),
              TextSpan(
                text: e.value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '\n'),
            ])
        .toList()
          ..removeLast();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Material(
          elevation: 1,
          color: Theme.of(context).cardColor,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: RichText(
              text: TextSpan(children: textSpans, style: textStyle),
//                'Subject: ${message.decodeHeaderValue('subject')}\n'
//                'Date: ${formatUtil.formatDateFull(message.decodeHeaderDateValue('date'))}',
              maxLines: null,
            ),
          ),
        ),
        htmlData != null && !forcePlainText
            ? Expanded(
                child: SingleChildScrollView(
                  child: Html(
                    data: htmlData,
                    onLinkTap: (link) {
                      DialogUtils.openUrl(link);
                    },
                  ),
                ),
              )
            : Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SelectableLinkify(
//                    child: Linkify(
                      text: (message.decodeTextPlainPart() ??
                              message.decodeContentText())
                          .replaceAll('\r', ''),
                      maxLines: null,
                      options: LinkifyOptions(
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
      ],
    );
  }
}
