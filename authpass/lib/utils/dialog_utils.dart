import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

final _logger = Logger('authpass.dialog_utils');

class DialogUtils {
  static Future<dynamic> showSimpleAlertDialog(BuildContext context, String title, String content) {
    return showDialog<dynamic>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title == null ? null : Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  static Future<void> openUrl(String url) async {
    if (Platform.isIOS || Platform.isAndroid) {
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false, forceWebView: false);
      }
    } else {
      _logger.warning('We do not yet support opening of URLs on desktop.');
    }
  }

  static Future<bool> showConfirmDialog({
    @required BuildContext context,
    @required ConfirmDialogParams params,
  }) {
    return showDialog<bool>(context: context, builder: (context) => ConfirmDialog(params: params));
  }
}

class ConfirmDialogParams {
  ConfirmDialogParams({
    this.title,
    @required this.content,
    this.positiveButtonText = 'Ok',
    this.negativeButtonText = 'Cancel',
  });

  final String title;
  final String content;
  final String positiveButtonText;
  final String negativeButtonText;
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({Key key, this.params}) : super(key: key);
  final ConfirmDialogParams params;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: params.title != null ? Text(params.title) : null,
      content: Text(params.content),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(params.negativeButtonText),
        ),
        FlatButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(params.positiveButtonText),
        ),
      ],
    );
  }
}

class SimplePromptDialog extends StatefulWidget {
  const SimplePromptDialog({Key key, this.title, this.labelText, this.initialValue = ''}) : super(key: key);
  final String title;
  final String labelText;
  final String initialValue;

  static Future<String> showPrompt(BuildContext context, SimplePromptDialog dialog) =>
      showDialog<String>(context: context, builder: (context) => dialog);

  @override
  _SimplePromptDialogState createState() => _SimplePromptDialogState();
}

class _SimplePromptDialogState extends State<SimplePromptDialog> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title),
      content: Container(
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Paste from clipboard',
              icon: Icon(FontAwesomeIcons.paste),
              onPressed: () async {
                _controller.text = (await Clipboard.getData('text/plain')).text;
              },
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                ),
                autofocus: true,
                onEditingComplete: () {
                  Navigator.of(context).pop(_controller.text);
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(_controller.text);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
