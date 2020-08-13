import 'package:flutter/widgets.dart';

extension StringExt on String {
  String nullIfBlank() {
    if (isEmpty) {
      return null;
    }
    return this;
  }
}

extension StringToInt on String {
  int toInt() => int.parse(this);
}

extension ListOptGet<T> on List<T> {
  T optGet(int index) => length > index ? this[index] : null;
}

extension EdgeInsetsExt on EdgeInsets {
  EdgeInsets get onlyTop => EdgeInsets.only(top: top);
}

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}
