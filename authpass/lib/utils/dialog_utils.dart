import 'dart:async';
import 'dart:io';

import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/logging_utils.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final _logger = Logger('authpass.dialog_utils');

class DialogUtils {
  static Future<dynamic> showSimpleAlertDialog(
    BuildContext context,
    String title,
    String content, {
    List<Widget> moreActions,
  }) {
    return showDialog<dynamic>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title == null ? null : Text(title),
            content: Text(content),
            actions: <Widget>[
              ...?moreActions,
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

  static Future<dynamic> showErrorDialog(
      BuildContext context, String title, String content) {
    return showSimpleAlertDialog(
      context,
      title,
      content,
      moreActions: !sendLogsSupported()
          ? null
          : [
              FlatButton(
                child: const Text('Send Error Report/Help'),
                onPressed: () {
                  sendLogs(
                    context,
                    errorDescription: 'title: $title\ncontent: $content',
                  );
                },
              ),
            ],
    );
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
  }) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmDialog(params: params),
        )) ==
        true;
  }

  static bool sendLogsSupported() => Platform.isIOS || Platform.isAndroid;

  static Future<void> sendLogs(
    BuildContext context, {
    String errorDescription = '',
  }) async {
    final env = Provider.of<Env>(context, listen: false);
    final loggingUtil = LoggingUtils();
    final logFiles = loggingUtil.rotatingFileLoggerFiles;
    final logFileDebug = logFiles
        .map((file) => '${file.absolute.path}: ${file.statSync()}')
        .join('\n\n');
    final details = errorDescription.isEmpty
        ? ''
        : '===================\n$errorDescription';
    final email = Email(
      subject: 'Log file for '
          '${await env.getAppInfo()} (${Platform.operatingSystem})',
      body: '\n\n\n\n$details\n'
          '====================Available Log Files:\n$logFileDebug',
      recipients: ['support@authpass.app'],
      // for now just take the current one.
      attachmentPaths: [logFiles.first.absolute.path],
    );
    await FlutterEmailSender.send(email);
  }
}

extension BuildContextError on BuildContext {
  Future<T> handleErrors<T>(String message, Future<T> Function() cb) async {
    try {
      return await cb();
    } catch (error, stackTrace) {
      _logger.severe('Error during action', error, stackTrace);
      await DialogUtils.showErrorDialog(
        this,
        'Error while handling action',
        'Encountered an unexpected error. $error',
      );
      rethrow;
    }
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

mixin DialogMixin<T> on Widget {
  Future<T> show(BuildContext context) =>
      showDialog<T>(context: context, builder: (context) => this);
}

class SimpleAuthCodePromptDialog extends StatefulWidget
    with DialogMixin<String> {
  const SimpleAuthCodePromptDialog({
    Key key,
    this.title,
    this.labelText,
    this.helperText,
    this.initialValue = '',
  }) : super(key: key);

  final String title;
  final String labelText;
  final String helperText;
  final String initialValue;

  @override
  _SimpleAuthCodePromptDialogState createState() =>
      _SimpleAuthCodePromptDialogState();
}

class _SimpleAuthCodePromptDialogState
    extends State<SimpleAuthCodePromptDialog> {
  FilePickerState _fps;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_fps == null) {
      _fps = Provider.of<FilePickerState>(context);
      _fps.registerUriHandler(_handleUri);
    }
  }

  bool _handleUri(Uri uri) {
    _logger.fine('Handling uri: $uri');
    final code = uri.queryParameters['code'];
    if (code != null && code.isNotEmpty) {
      Navigator.of(context).pop(code);
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _fps?.removeUriHandler(_handleUri);
  }

  @override
  Widget build(BuildContext context) {
    return SimplePromptDialog(
      title: widget.title,
      labelText: widget.labelText,
      helperText: widget.helperText,
      initialValue: widget.initialValue,
    );
  }
}

class SimplePromptDialog extends StatefulWidget with DialogMixin<String> {
  const SimplePromptDialog({
    Key key,
    this.title,
    this.labelText,
    this.initialValue = '',
    this.helperText,
  }) : super(key: key);
  final String title;
  final String labelText;
  final String helperText;
  final String initialValue;

  @Deprecated('Use [dialog.show] instead.')
  static Future<String> showPrompt(
          BuildContext context, SimplePromptDialog dialog) =>
      dialog.show(context);

  @override
  _SimplePromptDialogState createState() => _SimplePromptDialogState();
}

class _SimplePromptDialogState extends State<SimplePromptDialog>
    with WidgetsBindingObserver {
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
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: text.length);
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
              icon: const Icon(FontAwesomeIcons.paste),
              onPressed: () async {
                _controller.text = (await Clipboard.getData('text/plain')).text;
              },
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  helperText: widget.helperText,
                  helperMaxLines: 1,
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
