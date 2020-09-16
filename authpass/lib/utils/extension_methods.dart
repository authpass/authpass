import 'package:flutter/widgets.dart';

extension StringExt on String {
  String takeUnlessBlank() => nullIfBlank();
  String nullIfBlank() {
    if (this == null || isEmpty) {
      return null;
    }
    return this;
  }

  String prepend(String prefix) => '$prefix$this';
}

extension StringToInt on String {
  int toInt() => int.parse(this);
}

extension ListOptGet<T> on List<T> {
  T optGet(int index) => length > index ? this[index] : null;
}

extension IterableNotNull<T> on Iterable<T> {
  Iterable<T> whereNotNull() => where((element) => element != null);
  Iterable<T> takeIfNotEmpty() => isEmpty ? null : this;
}

extension EdgeInsetsExt on EdgeInsets {
  EdgeInsets get onlyTop => EdgeInsets.only(top: top);
}

extension ObjectExt<T> on T {
  T takeIf(bool Function(T that) predicate) => predicate(this) ? this : null;
  R let<R>(R Function(T that) op) => op(this);
}
