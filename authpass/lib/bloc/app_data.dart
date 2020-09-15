import 'dart:convert';
import 'dart:io';

import 'package:authpass/bloc/kdbx/file_source.dart';
import 'package:authpass/bloc/kdbx/file_source_cloud_storage.dart';
import 'package:authpass/bloc/kdbx/file_source_local.dart';
import 'package:authpass/cloud_storage/cloud_storage_bloc.dart';
import 'package:authpass/env/_base.dart';
import 'package:authpass/utils/path_utils.dart';
import 'package:authpass/utils/uuid_util.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart' show Color;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:simple_json_persistence/simple_json_persistence.dart';

part 'app_data.g.dart';

final _logger = Logger('app_data');

enum OpenedFilesSourceType { Local, Url, CloudStorage }

class SimpleEnumSerializer<T> extends PrimitiveSerializer<T> {
  SimpleEnumSerializer(this.enumValues);

//  final Type type;
  final List<T> enumValues;

  @override
  T deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    assert(serialized is String);
    return enumValues.singleWhere((val) => val.toString() == serialized);
  }

  @override
  Object serialize(Serializers serializers, T object,
      {FullType specifiedType = FullType.unspecified}) {
    return object?.toString();
  }

  @override
  Iterable<Type> get types => [T];

  @override
  String get wireName => T.toString();
}

abstract class OpenedFile implements Built<OpenedFile, OpenedFileBuilder> {
  factory OpenedFile([void Function(OpenedFileBuilder b) updates]) =
      _$OpenedFile;

  OpenedFile._();

  static Serializer<OpenedFile> get serializer => _$openedFileSerializer;

  static const SOURCE_CLOUD_STORAGE_ID = 'storageId';
  static const SOURCE_CLOUD_STORAGE_DATA = 'data';

  /// unique id to identify this open file across sessions.
  @nullable
  String get uuid;

  @BuiltValueField(compare: false)
  DateTime get lastOpenedAt;

  OpenedFilesSourceType get sourceType;

  String get sourcePath;

  String get name;

  /// when the user to choose to store password behind biometric keystore
  /// we generate a (more or less) random name to store it into.
  @nullable
  String get biometricStoreName;

  @nullable
  String get macOsSecureBookmark;

  /// stores the identifier as returned by [FilePickerWritable]
  @nullable
  String get filePickerIdentifier;

  @nullable
  int get colorCode;

  Color get color => colorCode == null ? null : Color(colorCode);

  bool isSameFileAs(OpenedFile other) =>
      other.sourceType == sourceType && other.sourcePath == sourcePath;

  static OpenedFile fromFileSource(FileSource fileSource, String dbName,
          [void Function(OpenedFileBuilder b) customize]) =>
      OpenedFile(
        (b) {
          b..lastOpenedAt = clock.now().toUtc();
          b..uuid = fileSource.uuid ?? AppDataBloc.createUuid();
          if (fileSource is FileSourceLocal) {
            b
              ..sourceType = OpenedFilesSourceType.Local
              ..sourcePath = fileSource.file.absolute.path
              ..macOsSecureBookmark = fileSource.macOsSecureBookmark
              ..filePickerIdentifier = fileSource.filePickerIdentifier
              ..name = dbName;
          } else if (fileSource is FileSourceUrl) {
            b
              ..sourceType = OpenedFilesSourceType.Url
              ..sourcePath = fileSource.url.toString()
              ..name = dbName;
          } else if (fileSource is FileSourceCloudStorage) {
            b
              ..sourceType = OpenedFilesSourceType.CloudStorage
              ..sourcePath = json.encode({
                SOURCE_CLOUD_STORAGE_ID: fileSource.provider.id,
                SOURCE_CLOUD_STORAGE_DATA: fileSource.fileInfo,
              })
              ..name = dbName;
          } else {
            throw ArgumentError.value(fileSource, 'fileSource',
                'Unsupported file type ${fileSource.runtimeType}');
          }
          if (customize != null) {
            customize(b);
          }
        },
      );

  FileSource toFileSource(CloudStorageBloc cloudStorageBloc) {
    switch (sourceType) {
      case OpenedFilesSourceType.Local:
        return FileSourceLocal(
          File(sourcePath),
          macOsSecureBookmark: macOsSecureBookmark,
          filePickerIdentifier: filePickerIdentifier,
          uuid: uuid ?? AppDataBloc.createUuid(),
          databaseName: name,
        );
      case OpenedFilesSourceType.Url:
        return FileSourceUrl(
          Uri.parse(sourcePath),
          uuid: uuid ?? AppDataBloc.createUuid(),
          databaseName: name,
        );
      case OpenedFilesSourceType.CloudStorage:
        final sourceInfo = json.decode(sourcePath) as Map<String, dynamic>;
        final storageId = sourceInfo[SOURCE_CLOUD_STORAGE_ID] as String;
        final provider = cloudStorageBloc.providerById(storageId);
        if (provider == null) {
          throw StateError('Invalid cloud storage provider id $storageId');
        }
        return provider.toFileSource(
          (sourceInfo[SOURCE_CLOUD_STORAGE_DATA] as Map).cast<String, String>(),
          uuid: uuid ?? UuidUtil.createUuid(),
          databaseName: name,
        );
    }
    throw ArgumentError.value(sourceType, 'sourceType', 'Unsupported value.');
  }
}

enum AppDataTheme { dark, light }

abstract class AppData implements Built<AppData, AppDataBuilder>, HasToJson {
  factory AppData([void Function(AppDataBuilder b) updates]) = _$AppData;

  AppData._();

  static Serializer<AppData> get serializer => _$appDataSerializer;

  BuiltList<OpenedFile> get previousFiles;

  @nullable
  int get passwordGeneratorLength;

  BuiltSet<String> get passwordGeneratorCharacterSets;

  @nullable
  String get manualUserType;

  @nullable
  DateTime get firstLaunchedAt;

  /// Theme of the app, either light or dark (null means system default)
  @nullable
  AppDataTheme get theme;

  @nullable
  double get themeVisualDensity;

  @nullable
  double get themeFontSizeFactor;

  @nullable
  bool get diacOptIn;

  /// remember which build id was used, so we might be
  /// able to show a changelog in the future..
  @nullable
  int get lastBuildId;

  /// Android only: disable screenshots, etc. (FLAG_SECURE)
  @nullable
  bool get secureWindow;
  bool get secureWindowOrDefault => secureWindow ?? false;

  /// allows overriding system locale to a specific language.
  @nullable
  String get localeOverride;

  /// whether to fetch icons for password entries with websites from
  /// the internet, instead of showing kdbx icons.
  /// (right now: off by default).
  @nullable
  bool get fetchWebsiteIcons;
  bool get fetchWebsiteIconsOrDefault => fetchWebsiteIcons ?? false;

  @override
  Map<String, dynamic> toJson() =>
      serializers.serialize(this) as Map<String, dynamic>;

  OpenedFile recentFileByUuid(String uuid) {
    return previousFiles.firstWhere((f) => f.uuid == uuid, orElse: () => null);
  }
}

@SerializersFor([
  AppData,
  OpenedFile,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(SimpleEnumSerializer<OpenedFilesSourceType>(
          OpenedFilesSourceType.values))
      ..add(SimpleEnumSerializer<AppDataTheme>(AppDataTheme.values))
      ..addPlugin(StandardJsonPlugin()))
    .build();

class AppDataBloc {
  AppDataBloc(this.env) {
    _init();
  }

  final Env env;

  final store = SimpleJsonPersistence.getForTypeSync(
    (json) => serializers.deserializeWith(AppData.serializer, json),
    defaultCreator: () =>
        AppData((b) => b..firstLaunchedAt = clock.now().toUtc()),
    storeBackend: createStoreBackend(
        () async => (await PathUtils().getAppDataDirectory()).path),
  );

  static String createUuid() => UuidUtil.createUuid();

  Future<void> _init() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    final data = await store.load();
    final appInfo = await env.getAppInfo();
    if (data.firstLaunchedAt == null ||
        data.lastBuildId != appInfo.buildNumber) {
      await update((b, data) => b
        ..lastBuildId = appInfo.buildNumber
        ..firstLaunchedAt ??= clock.now().toUtc());
    }
  }

  ///
  /// if [oldFile] is defined non-essential data (e.g. colorCode) is copied from it.
  Future<OpenedFile> openedFile(FileSource file,
          {@required String name,
          OpenedFile oldFile,
          Color defaultColor}) async =>
      await update((b, data) {
        final recentFile = data.recentFileByUuid(file.uuid) ?? oldFile;
        final colorCode =
            recentFile?.colorCode ?? oldFile?.colorCode ?? defaultColor?.value;
        final openedFile = OpenedFile.fromFileSource(
            file, name, (b) => b..colorCode = colorCode);
        _logger.finest('openedFile: $openedFile');
        // TODO remove potential old storages?
        b.previousFiles.removeWhere((file) => file.isSameFileAs(openedFile));
        b.previousFiles.add(openedFile);
        return openedFile;
      });

  Future<T> update<T>(
      T Function(AppDataBuilder builder, AppData data) updater) async {
    final appData = await store.load();
    T ret;
    final newAppData = appData.rebuild((b) => ret = updater(b, appData));
    await store.save(newAppData);
    return ret;
  }

  Future<AppDataTheme> updateNextTheme() async {
    final updated = await update((builder, data) {
      final nextTheme = data.theme == null
          ? AppDataTheme.light
          : data.theme == AppDataTheme.light ? AppDataTheme.dark : null;
      return builder.theme = nextTheme;
    });
    return updated;
  }
}
