import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthPassProgressIndicator extends StatelessWidget {
  const AuthPassProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (true) {
    //   return const CircularProgressIndicator(value: 0.5);
    // }
    return const CircularProgressIndicator();
  }
}

class ProgressIndicatorForButtonBar extends StatelessWidget {
  const ProgressIndicatorForButtonBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(),
    );
  }
}
