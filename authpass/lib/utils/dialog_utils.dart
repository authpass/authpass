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

  static Future<bool> openUrl(String url) async {
    if (await canLaunch(url)) {
      return await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      _logger.severe('Unable to launch url $url');
      return false;
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

class _SimplePromptDialogState extends State<SimplePromptDialog> with WidgetsBindingObserver {
  TextEditingController _controller;
  AppLifecycleState _previousState;
  String _previousClipboard;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    WidgetsBinding.instance.addObserver(this);
    _readClipboard();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _readClipboard({bool setIfChanged = false}) async {
    final text = (await Clipboard.getData('text/plain'))?.text;
    if (setIfChanged && text != _previousClipboard && text != null) {
      _controller.text = text;
      _controller.selection = TextSelection(baseOffset: 0, extentOffset: text.length);
    }
    _previousClipboard = text;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _logger.fine('lifecycle state changed to $state (was: $_previousState)');
    if (state == AppLifecycleState.resumed) {
      _readClipboard(setIfChanged: true);
    }
    _previousState = state;
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
