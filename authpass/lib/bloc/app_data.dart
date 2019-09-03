import 'dart:io';

import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:simple_json_persistence/simple_json_persistence.dart';
import 'package:uuid/uuid.dart';

part 'app_data.g.dart';

enum OpenedFilesSourceType { Local, Url }

class SimpleEnumSerializer<T> extends PrimitiveSerializer<T> {
  SimpleEnumSerializer(this.enumValues);

//  final Type type;
  final List<T> enumValues;

  @override
  T deserialize(Serializers serializers, Object serialized, {FullType specifiedType = FullType.unspecified}) {
    assert(serialized is String);
    return enumValues.singleWhere((val) => val.toString() == serialized);
  }

  @override
  Object serialize(Serializers serializers, T object, {FullType specifiedType = FullType.unspecified}) {
    return object?.toString();
  }

  @override
  Iterable<Type> get types => [T];

  @override
  String get wireName => T.toString();
}

abstract class OpenedFile implements Built<OpenedFile, OpenedFileBuilder> {
  factory OpenedFile([void updates(OpenedFileBuilder b)]) = _$OpenedFile;

  OpenedFile._();

  static Serializer<OpenedFile> get serializer => _$openedFileSerializer;

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

  bool isSameFileAs(OpenedFile other) => other.sourceType == sourceType && other.sourcePath == sourcePath;

  static OpenedFile fromFileSource(FileSource fileSource, String dbName) => OpenedFile(
        (b) {
          b..lastOpenedAt = clock.now().toUtc();
          b..uuid = fileSource.uuid ?? AppDataBloc.createUuid();
          if (fileSource is FileSourceLocal) {
            b
              ..sourceType = OpenedFilesSourceType.Local
              ..sourcePath = fileSource.file.absolute.path
              ..name = dbName;
          } else if (fileSource is FileSourceUrl) {
            b
              ..sourceType = OpenedFilesSourceType.Url
              ..sourcePath = fileSource.url.toString()
              ..name = dbName;
          } else {
            throw ArgumentError.value(fileSource, 'fileSource', 'Unsupported file type ${fileSource.runtimeType}');
          }
        },
      );

  FileSource toFileSource() {
    switch (sourceType) {
      case OpenedFilesSourceType.Local:
        return FileSourceLocal(File(sourcePath), uuid: uuid ?? AppDataBloc.createUuid());
      case OpenedFilesSourceType.Url:
        return FileSourceUrl(Uri.parse(sourcePath), uuid: uuid ?? AppDataBloc.createUuid());
    }
    throw ArgumentError.value(sourceType, 'sourceType', 'Unsupported value.');
  }
}

abstract class AppData implements Built<AppData, AppDataBuilder>, HasToJson {
  factory AppData([void updates(AppDataBuilder b)]) = _$AppData;

  AppData._();

  static Serializer<AppData> get serializer => _$appDataSerializer;

  BuiltList<OpenedFile> get previousFiles;

  @override
  Map<String, dynamic> toJson() => serializers.serialize(this) as Map<String, dynamic>;

  OpenedFile recentFileByUuid(String uuid) {
    return previousFiles.firstWhere((f) => f.uuid == uuid, orElse: () => null);
  }
}

@SerializersFor([
  AppData,
  OpenedFile,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(SimpleEnumSerializer<OpenedFilesSourceType>(OpenedFilesSourceType.values))
      ..addPlugin(StandardJsonPlugin()))
    .build();

class AppDataBloc {
  final store = SimpleJsonPersistence.getForTypeSync(
    (json) => serializers.deserializeWith(AppData.serializer, json),
    defaultCreator: () => AppData(),
    baseDirectoryBuilder: () =>
        Platform.isIOS || Platform.isAndroid ? getApplicationDocumentsDirectory() : _getDesktopDirectory(),
  );

  static final _uuid = Uuid();
  static String createUuid() => _uuid.v4();

  static Future<Directory> _getDesktopDirectory() async {
    // https://stackoverflow.com/a/32937974/109219
    final userHome = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    final dataDir = Directory(path.join(userHome, '.authpass', 'data'));
    await dataDir.create(recursive: true);
    return dataDir;
  }

  Future<OpenedFile> openedFile(FileSource file, {@required String name}) async {
    final openedFile = OpenedFile.fromFileSource(file, name);
    await update((b) {
      // TODO remove potential old storages?
      b.previousFiles.removeWhere((file) => file.isSameFileAs(openedFile));
      b.previousFiles.add(openedFile);
    });
    return openedFile;
  }

  Future<AppData> update(void Function(AppDataBuilder builder) updater) async {
    final appData = await store.load();
    final newAppData = appData.rebuild(updater);
    await store.save(newAppData);
    return newAppData;
  }
}
