import 'dart:async';
import 'dart:collection';

import 'package:authpass/utils/dialog_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

final _logger = Logger('async_utils');

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
  FutureTask({@required this.future, String progressLabel})
      : _progressLabel = progressLabel {
    _logger.info('Initialized task with $progressLabel');
  }
  final Future<dynamic> future;
  String _progressLabel;
  set progressLabel(String progressLabel) {
    _progressLabel = progressLabel;
    _logger.fine(
        'Progress Label chaned to $progressLabel (hasListeners: $hasListeners)');
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
    _progressLabel = progressLabel;
    _futureTask?.progressLabel = progressLabel;
    _logger.fine('proxy: label changed to $progressLabel ($_futureTask)');
  }
}

abstract class TaskProgress {
  set progressLabel(String progressLabel);
}

mixin FutureTaskStateMixin<T extends StatefulWidget> on State<T> {
  FutureTask task;
  final Queue<VoidCallback> _taskQueue = Queue<VoidCallback>();

  @protected
  VoidCallback asyncTaskCallback<U>(
      Future<U> Function(TaskProgress progress) progress) {
    if (task != null) {
      return null;
    }
    return () {
      asyncRunTask(progress);
    };
  }

  @protected
  Future<U> asyncRunTask<U>(
      Future<U> Function(TaskProgress progress) taskRunner,
      {String label}) {
    if (task != null) {
      // we have to queue task.
      final taskProgressLabel = task.progressLabel;
      _logger.finer(
          'A task is aready running ($taskProgressLabel). queing ($label)');
      final completer = Completer<U>();
      _taskQueue.add(() {
        completer.complete(asyncRunTask(taskRunner, label: label));
      });
      return completer.future;
    }
    _logger.finer('Running task $label');
    final proxy = _TaskProgressProxy();
    final future = taskRunner(proxy);
    proxy._futureTask = FutureTask(
        future: future, progressLabel: proxy._progressLabel ?? label);
    setState(() {
      task = proxy._futureTask;
    });
    future.catchError((dynamic error, StackTrace stackTrace) {
      DialogUtils.showErrorDialog(
          context, 'Error while ${label ?? 'running task'}', '$error');
      return Future<U>.error(error, stackTrace);
    });
    future.whenComplete(() {
      setState(() {
        task = null;
        _logger.fine('Task $label completed. ${_taskQueue.length} queued'
            ' tasks remaining.');
        if (_taskQueue.isNotEmpty) {
          _taskQueue.removeFirst()();
        }
      });
    });
    return future;
  }
}
