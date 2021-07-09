// copied from the screenshots package
// https://github.com/mmcc007/screenshots/

import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:yaml/yaml.dart' as yaml;

// ignore_for_file: avoid_print

/// Called by integration test to capture images.
Future screenshot(final FlutterDriver? driver, Config config, String name,
    {Duration timeout = const Duration(seconds: 30),
    bool silent = false,
    bool waitUntilNoTransientCallbacks = true}) async {
  if (config.isScreenShotsAvailable) {
    // todo: auto-naming scheme
    if (waitUntilNoTransientCallbacks) {
      await driver!.waitUntilNoTransientCallbacks(timeout: timeout);
    }

    final pixels = await driver!.screenshot();
    final testDir = '${config.stagingDir}/$kTestScreenshotsDir';
    final file =
        await File('$testDir/$name.$kImageExtension').create(recursive: true);
    await file.writeAsBytes(pixels);
    print('Screenshot $name created');
  } else {
    print('Warning: screenshot $name not created');
  }
}

const kEnvConfigPath = 'SCREENSHOTS_YAML';

/// Config info used to manage screenshots for android and ios.
// Note: should not have context dependencies as is also used in driver.
class Config {
  Config({this.configPath = kConfigFileName, String? configStr}) {
    if (configStr != null) {
      // used by tests
      _configInfo = parseYamlStr(configStr);
    } else {
      if (isScreenShotsAvailable) {
        final envConfigPath = Platform.environment[kEnvConfigPath];
        if (envConfigPath == null) {
          // used by command line and by driver if using kConfigFileName
          _configInfo = parseYamlFile(configPath);
        } else {
          // used by driver
          _configInfo = parseYamlFile(envConfigPath);
        }
      } else {
        stdout.writeln('Warning: screenshots not available.\n'
            '\tTo enable set $kEnvConfigPath environment variable\n'
            '\tor create $kConfigFileName.');
      }
    }
  }

  /// Checks if screenshots is available.
  ///
  /// Created for use in driver.
  // Note: order of boolean tests is important
  bool get isScreenShotsAvailable =>
      Platform.environment[kEnvConfigPath] != null ||
      File(configPath).existsSync();

  final String configPath;

  Map? _configInfo;

  // // Getters
  String? get stagingDir => _configInfo!['staging'] as String?;
}

/// Parse a yaml file.
Map? parseYamlFile(String yamlPath) =>
    jsonDecode(jsonEncode(yaml.loadYaml(fs.file(yamlPath).readAsStringSync())))
        as Map?;

/// Parse a yaml string.
Map? parseYamlStr(String yamlString) =>
    jsonDecode(jsonEncode(yaml.loadYaml(yamlString))) as Map?;

/// default config file name
const String kConfigFileName = 'screenshots.yaml';

/// screenshots environment file name
const String kEnvFileName = 'env.json';

/// Image extension
const kImageExtension = 'png';

/// Directory for capturing screenshots during a test
const kTestScreenshotsDir = 'test';

/// Distinguish device OS.
enum DeviceType { android, ios }

/// Run mode
enum RunMode { normal, recording, comparison, archive }

/// No flavor
const String kNoFlavor = 'no flavor';
