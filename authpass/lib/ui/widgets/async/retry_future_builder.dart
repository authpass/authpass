import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

final _logger = Logger('retry_future_builder');

typedef FutureProducer<T> = Future<T> Function(BuildContext context);
typedef StreamProducer<T> = Stream<T> Function(BuildContext context);
typedef ScaffoldBuilder<T> = Widget Function(
    BuildContext context, Widget body, AsyncSnapshot<T> snapshot);
typedef DataWidgetBuilder<T> = Widget Function(BuildContext context, T data);

class RetryFutureBuilder<T> extends StatefulWidget {
  const RetryFutureBuilder({
    Key? key,
    required this.produceFuture,
    required this.builder,
    this.scaffoldBuilder = defaultScaffoldBuilder,
  }) : super(key: key);

  final FutureProducer<T> produceFuture;
  final DataWidgetBuilder<T> builder;
  final ScaffoldBuilder<T> scaffoldBuilder;

  static Widget defaultScaffoldBuilder(
          BuildContext context, Widget body, dynamic _) =>
      body;

  @override
  RetryFutureBuilderState createState() => RetryFutureBuilderState<T>();
}

class RetryFutureBuilderState<T> extends State<RetryFutureBuilder<T>> {
  Future<T>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reload();
  }

  @override
  void didUpdateWidget(RetryFutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.produceFuture != widget.produceFuture) {
      reload();
    }
  }

  void reload() {
    setState(() {
      _future = widget.produceFuture(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.requireData;
          var child = widget.builder(context, data);
          if (snapshot.connectionState == ConnectionState.waiting) {
            child = Stack(
              children: [
                child,
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
          return widget.scaffoldBuilder(context, child, snapshot);
        }
        if (snapshot.hasError) {
          final loc = AppLocalizations.of(context);
          _logger.warning('Error while creating future.', snapshot.error);
          return widget.scaffoldBuilder(
            context,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(loc.errorDuringNetworkCall(snapshot.error.toString())),
                ElevatedButton(
                  onPressed: () {
                    setState(
                      () {
                        _future = widget.produceFuture(context);
                      },
                    );
                  },
                  child: Text(loc.retryDialogActionLabel),
                ),
              ],
            ),
            snapshot,
          );
        } else {
          return widget.scaffoldBuilder(
            context,
            const Center(child: CircularProgressIndicator()),
            snapshot,
          );
        }
      },
    );
  }
}

class RetryStreamBuilder<T> extends StatefulWidget {
  const RetryStreamBuilder({
    Key? key,
    required this.stream,
    this.retry,
    required this.builder,
    this.scaffoldBuilder = RetryFutureBuilder.defaultScaffoldBuilder,
    this.initialValue,
  }) : super(key: key);

  final StreamProducer<T> stream;
  final T? initialValue;
  final DataWidgetBuilder<T> builder;
  final Future<void>? Function()? retry;
  final ScaffoldBuilder<T> scaffoldBuilder;

  @override
  _RetryStreamBuilderState createState() => _RetryStreamBuilderState<T>();
}

class _RetryStreamBuilderState<T> extends State<RetryStreamBuilder<T>> {
  Stream<T>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stream = widget.stream(context);
  }

  @override
  Widget build(BuildContext context) {
    final valueStream =
        _stream is ValueStream<T> ? _stream as ValueStream<T>? : null;
    return StreamBuilder<T>(
        stream: _stream,
        initialData: valueStream?.valueOrNull ?? widget.initialValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return widget.scaffoldBuilder(
              context,
              widget.builder(context, snapshot.requireData),
              snapshot,
            );
          }
          if (snapshot.hasError) {
            _logger.warning('Error while creating future.', snapshot.error);
            final loc = AppLocalizations.of(context);
            return widget.scaffoldBuilder(
              context,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(loc.errorDuringNetworkCall(snapshot.error.toString())),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (widget.retry != null) {
                          widget.retry!();
                        } else {
                          _stream = widget.stream(context);
                        }
                      });
                    },
                    child: Text(loc.retryDialogActionLabel),
                  ),
                ],
              ),
              snapshot,
            );
          } else {
            return widget.scaffoldBuilder(
              context,
              const Center(child: CircularProgressIndicator()),
              snapshot,
            );
          }
        });
  }
}
