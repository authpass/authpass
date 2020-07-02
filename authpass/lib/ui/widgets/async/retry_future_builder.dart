import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:logging/logging.dart';

final _logger = Logger('retry_future_builder');

typedef FutureProducer<T> = Future<T> Function(BuildContext context);
typedef DataWidgetBuilder<T> = Widget Function(BuildContext context, T data);

class RetryFutureBuilder<T> extends StatefulWidget {
  const RetryFutureBuilder({
    Key key,
    @required this.produceFuture,
    @required this.builder,
  }) : super(key: key);

  final FutureProducer<T> produceFuture;
  final DataWidgetBuilder<T> builder;

  @override
  _RetryFutureBuilderState createState() => _RetryFutureBuilderState<T>();
}

class _RetryFutureBuilderState<T> extends State<RetryFutureBuilder<T>> {
  Future<T> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future = widget.produceFuture(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.builder(context, snapshot.data);
        }
        if (snapshot.hasError) {
          _logger.warning('Error while creating future.', snapshot.error);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Error during api call. ${snapshot.error}'),
              RaisedButton(
                child: const Text('Retry'),
                onPressed: () {
                  setState(() {
                    _future = widget.produceFuture(context);
                  });
                },
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
