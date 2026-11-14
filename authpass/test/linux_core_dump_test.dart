import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('linux runner disables core dumps before creating the app', () {
    final main = File('linux/main.cc').readAsStringSync();
    expect(main, contains('#include <sys/resource.h>'));

    final limit = main.indexOf('setrlimit(RLIMIT_CORE');
    final create = main.indexOf('my_application_new()');
    expect(limit, isNonNegative, reason: 'RLIMIT_CORE must be set');
    expect(create, isNonNegative);
    expect(limit, lessThan(create));
    // A soft and hard limit of 0 cannot be raised again by the process.
    expect(main, contains('struct rlimit no_core = {0, 0};'));
  });
}
