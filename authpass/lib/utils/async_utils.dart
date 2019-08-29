import 'package:flutter/widgets.dart';

mixin TaskStateMixin<T extends StatefulWidget> on State<T> {
  Future<dynamic> task;

  @protected
  VoidCallback asyncTaskCallback<U>(Future<U> Function() callback) {
    if (task != null) {
      return null;
    }
    return () {
      asyncRunTask(callback);
    };
  }

  @protected
  Future<U> asyncRunTask<U>(Future<U> Function() taskRunner) {
    final future = taskRunner();
    setState(() {
      task = future;
    });
    future.whenComplete(() {
      setState(() {
        task = null;
      });
    });
    return future;
  }
}
