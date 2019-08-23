import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogUtils {
  static void showSimpleAlertDialog(BuildContext context, String title, String content) {
    showDialog<dynamic>(
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
