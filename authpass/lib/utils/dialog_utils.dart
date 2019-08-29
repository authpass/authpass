import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
}

class SimplePromptDialog extends StatefulWidget {
  const SimplePromptDialog({Key key, this.title, this.labelText}) : super(key: key);
  final String title;
  final String labelText;

  static Future<String> showPrompt(BuildContext context, SimplePromptDialog dialog) =>
      showDialog<String>(context: context, builder: (context) => dialog);

  @override
  _SimplePromptDialogState createState() => _SimplePromptDialogState();
}

class _SimplePromptDialogState extends State<SimplePromptDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title),
      content: Container(
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
