import 'package:authpass/utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:kdbx/kdbx.dart';

extension StringExt on String? {
  String? takeUnlessBlank() => nullIfBlank();
  String? nullIfBlank() {
    final t = this;
    if (t == null || t.isEmpty) {
      return null;
    }
    return this;
  }

  bool isNullOrEmpty() => this?.isEmpty ?? true;

  String prepend(String prefix) => prefix + (this ?? CharConstants.empty);
}

extension StringValueExt on StringValue {
  bool isNullOrEmpty() => getText().isNullOrEmpty();
}

extension StringToInt on String {
  int toInt() => int.parse(this);
}

extension ListOptGet<T> on List<T> {
  T? optGet(int index) => length > index ? this[index] : null;
}

extension IterableNotEmpty<T> on Iterable<T> {
  Iterable<T>? takeIfNotEmpty() => isEmpty ? null : this;
}

extension IterableNotNull<T> on Iterable<T?> {
  Iterable<T> whereNotNull() => where((element) => element != null).cast();
}

extension EdgeInsetsExt on EdgeInsets {
  EdgeInsets get onlyTop => EdgeInsets.only(top: top);
}

extension ObjectExt<T> on T {
  T? takeIf(bool Function(T that) predicate) => predicate(this) ? this : null;
  R let<R>(R Function(T that) op) => op(this);
  U? takeAs<U>() => this is U ? this as U : null;
}
