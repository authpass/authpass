import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Returns the plugs listed under `apps.authpass.plugs` of the snap manifest.
List<String> _appPlugs(List<String> lines) {
  final plugs = <String>[];
  var inPlugs = false;
  for (final line in lines) {
    if (line.trim() == 'plugs:') {
      inPlugs = true;
      continue;
    }
    if (!inPlugs) {
      continue;
    }
    final match = RegExp(r'^\s+-\s+(\S+)\s*$').firstMatch(line);
    if (match == null) {
      break;
    }
    plugs.add(match.group(1)!);
  }
  return plugs;
}

void main() {
  test('snap declares the removable-media plug', () {
    // `flutter test` runs from the `authpass` package folder.
    final lines = File('../snap/snapcraft.yaml').readAsLinesSync();
    final plugs = _appPlugs(lines);
    expect(plugs, contains('home'));
    // Without this plug `snap connect authpass:removable-media` fails and the
    // confined app cannot read /media, /run/media or /mnt.
    expect(plugs, contains('removable-media'));
  });
}
