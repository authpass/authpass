import 'package:flutter/foundation.dart';
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

class FutureTask with ChangeNotifier implements ValueListenable<FutureTask> {
  FutureTask({@required this.future, String progressLabel}) : _progressLabel = progressLabel;
  final Future<dynamic> future;
  String _progressLabel;
  set progressLabel(String progressLabel) {
    _progressLabel = progressLabel;
    notifyListeners();
  }

  String get progressLabel => _progressLabel;

  @override
  FutureTask get value => this;
}

class _TaskProgressProxy implements TaskProgress {
  FutureTask _futureTask;
  String _progressLabel;

  @override
  set progressLabel(String progressLabel) {
    _futureTask?.progressLabel = _progressLabel = progressLabel;
  }
}

abstract class TaskProgress {
  set progressLabel(String progressLabel);
}

mixin FutureTaskStateMixin<T extends StatefulWidget> on State<T> {
  FutureTask task;

  @protected
  VoidCallback asyncTaskCallback<U>(Future<U> Function(TaskProgress progress) progress) {
    if (task != null) {
      return null;
    }
    return () {
      asyncRunTask(progress);
    };
  }

  @protected
  Future<U> asyncRunTask<U>(Future<U> Function(TaskProgress progress) taskRunner) {
    final proxy = _TaskProgressProxy();
    final future = taskRunner(proxy);
    proxy._futureTask = FutureTask(future: future, progressLabel: proxy._progressLabel);
    setState(() {
      task = proxy._futureTask;
    });
    future.whenComplete(() {
      setState(() {
        task = null;
      });
    });
    return future;
  }
}
