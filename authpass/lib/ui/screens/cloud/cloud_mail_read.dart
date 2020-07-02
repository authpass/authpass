import 'package:authpass/bloc/authpass_cloud_bloc.dart';
import 'package:authpass/ui/widgets/async/retry_future_builder.dart';
import 'package:authpass/utils/dialog_utils.dart';
import 'package:authpass/utils/format_utils.dart';
import 'package:authpass_cloud_shared/authpass_cloud_shared.dart';
import 'package:enough_mail/enough_mail.dart' as enough;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';

class EmailReadScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${emailMessage.subject}'),
      ),
      body: EmailRead(bloc: bloc, emailMessage: emailMessage),
    );
  }
}

class EmailRead extends StatelessWidget {
  const EmailRead({Key key, @required this.bloc, @required this.emailMessage})
      : super(key: key);
  final AuthPassCloudBloc bloc;
  final EmailMessage emailMessage;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1.copyWith(
          fontFamily: 'JetBrainsMono',
          height: 1.4,
        );
    final formatUtil = context.watch<FormatUtils>();
    return RetryFutureBuilder<enough.MimeMessage>(
      produceFuture: (context) => bloc.loadMail(emailMessage),
      builder: (context, message) {
        final htmlData = message.decodeTextHtmlPart();
        final headers = {
          'Subject': message.decodeHeaderValue('subject'),
          'From': message.decodeHeaderMailAddressValue('from').toString(),
          'Date':
              formatUtil.formatDateFull(message.decodeHeaderDateValue('date')),
//          'To': message.decodeHeaderValue('to'),
        };
        final textSpans = headers.entries
            .where((element) => element.value != null)
            .expand((e) => [
                  TextSpan(text: '${e.key}: '),
                  TextSpan(
                    text: e.value,
                    style: TextStyle(fontWeight: FontWeight.bold),
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
            htmlData != null
                ? Html(data: htmlData)
                : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Linkify(
                          text: message.decodeTextPlainPart() ??
                              message.decodeContentText(),
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
      },
    );
  }
}
