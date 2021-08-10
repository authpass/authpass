import 'dart:io' as io;
import 'dart:isolate';

import 'package:authpass/utils/path_utils.dart';
import 'package:authpass/utils/platform.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('logging_utils');

class LoggingUtils {
  factory LoggingUtils() => _instance;

  LoggingUtils._();

  static final _instance = LoggingUtils._();

  late final AsyncInitializingLogHandler<RotatingFileAppender>?
      _rotatingFileLogger = AuthPassPlatform.isWeb
          ? null
          : AsyncInitializingLogHandler<RotatingFileAppender>(
              builder: () async {
              await PathUtils.waitForRunAppFinished;
              final logsDir = await PathUtils().getLogDirectory();
              final appLogFile = logsDir.childFile(nonNls('app.log.txt'));
              await appLogFile.parent.create(recursive: true);
              _logger.fine('Logging into $appLogFile');
              return RotatingFileAppender(
                rotateAtSizeBytes: 10 * 1024 * 1024,
                baseFilePath: appLogFile.path,
              );
            });

  List<io.File> get rotatingFileLoggerFiles =>
      _rotatingFileLogger?.delegatedLogHandler?.getAllLogFiles() ?? [];

  void setupLogging({bool fromMainIsolate = false}) {
    Logger.root.level = Level.ALL;
    PrintAppender().attachToLogger(Logger.root);
    if (kIsWeb) {
      return;
    }
    if (fromMainIsolate) {
      _rotatingFileLogger?.attachToLogger(Logger.root);
    }
    final isolateDebug =
        '${Isolate.current.debugName} (${Isolate.current.hashCode})'; // NON-NLS
    _logger.info(
        'Running in isolate $isolateDebug ${Isolate.current.debugName} (${Isolate.current.hashCode})');

    Isolate.current.addOnExitListener(RawReceivePort((dynamic val) {
      // ignore: avoid_print
      print(nonNls('exiting isolate $isolateDebug'));
    }).sendPort);

    final exitPort = ReceivePort();
    exitPort.listen((dynamic data) {
      _logger.info(
          'Exiting isolate $isolateDebug ${Isolate.current.debugName} (${Isolate.current.hashCode}');
    }, onDone: () {
      _logger.info('Done $isolateDebug');
    });
    Isolate.current
        .addOnExitListener(exitPort.sendPort, response: nonNls('exit'));
  }

  @NonNls
  static Future<Map<String, dynamic>> getDebugDeviceInfo() async {
    final di = DeviceInfoPlugin();
    if (AuthPassPlatform.isWeb) {
      return (await di.webBrowserInfo).importantInfo();
    }
    if (AuthPassPlatform.isAndroid) {
      return (await di.androidInfo).importantInfo();
    }
    if (AuthPassPlatform.isIOS) {
      return (await di.iosInfo).importantInfo();
    }
    if (AuthPassPlatform.isLinux) {
      return (await di.linuxInfo).importantInfo();
    }
    if (AuthPassPlatform.isWindows) {
      return (await di.windowsInfo).importantInfo();
    }
    if (AuthPassPlatform.isMacOS) {
      return (await di.macOsInfo).importantInfo();
    }
    return <String, dynamic>{
      'unknownPlatform': AuthPassPlatform.operatingSystem
    };
  }
}

extension on AndroidDeviceInfo {
  @NonNls
  Map<String, dynamic> importantInfo() => <String, dynamic>{
        'id': id,
        'tags': tags,
        'type': type,
        'model': model,
        'board': board,
        'brand': brand,
        'device': device,
        'product': product,
        'display': display,
        'hardware': hardware,
        'version': version.toMap(),
        'manufacturer': manufacturer,
        'isPhysicalDevice': isPhysicalDevice,
      };
}

extension on IosDeviceInfo {
  @NonNls
  Map<String, dynamic> importantInfo() => <String, dynamic>{
        'name': name,
        'model': model,
        'systemName': systemName,
        'systemVersion': systemVersion,
        'localizedModel': localizedModel,
        'utsname': toMap()['utsname'],
      };
}

extension on WebBrowserInfo {
  @NonNls
  Map<String, dynamic> importantInfo() => <String, dynamic>{
        'userAgent': userAgent,
      };
}

extension on LinuxDeviceInfo {
  @NonNls
  Map<String, dynamic> importantInfo() => <String, dynamic>{
        'name': name,
        'version': version,
      };
}

extension on WindowsDeviceInfo {
  @NonNls
  Map<String, dynamic> importantInfo() => <String, dynamic>{
        'systemMemoryInMegabytes': systemMemoryInMegabytes,
      };
}

extension on MacOsDeviceInfo {
  @NonNls
  Map<String, dynamic> importantInfo() => <String, dynamic>{
        'arch': arch,
        'model': model,
        'hostName': hostName,
        'osRelease': osRelease,
      };
}

class StringBufferWrapper with ChangeNotifier {
  final StringBuffer _buffer = StringBuffer();

  void writeln(String line) {
    _buffer.writeln(line);
    notifyListeners();
  }

  @override
  String toString() => _buffer.toString();
}

class MemoryAppender extends BaseLogAppender {
  MemoryAppender({this.minLevel = Level.ALL})
      : super(const DefaultLogRecordFormatter());

  final Level minLevel;
  final StringBufferWrapper log = StringBufferWrapper();

  @override
  void handle(LogRecord record) {
    if (record.level.value >= minLevel.value) {
      log.writeln(formatter.format(record));
    }
  }
}
