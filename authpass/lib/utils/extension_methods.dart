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
