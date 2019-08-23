import 'dart:io';

import 'package:meta/meta.dart';
import 'package:authpass/bloc/kdbx_bloc.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:clock/clock.dart';
import 'package:simple_json_persistence/simple_json_persistence.dart';

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

  @BuiltValueField(compare: false)
  DateTime get lastOpenedAt;

  OpenedFilesSourceType get sourceType;

  String get sourcePath;

  String get name;

  static OpenedFile fromFileSource(FileSource fileSource, String dbName) => OpenedFile(
        (b) {
          b..lastOpenedAt = clock.now().toUtc();
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
        return FileSourceLocal(File(sourcePath));
      case OpenedFilesSourceType.Url:
        return FileSourceUrl(Uri.parse(sourcePath));
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
  final store = SimpleJsonPersistence<AppData>.forType(
    (json) => serializers.deserializeWith(AppData.serializer, json),
    defaultCreator: () => AppData(),
  );

  Future<void> openedFile(FileSource file, {@required String name}) async {
    return update((b) {
      final openedFile = OpenedFile.fromFileSource(file, name);
      b.previousFiles.removeWhere((file) => file == openedFile);
      b.previousFiles.add(openedFile);
    });
  }

  Future<AppData> update(void Function(AppDataBuilder builder) updater) async {
    final appData = await store.load();
    final newAppData = appData.rebuild(updater);
    await store.save(newAppData);
    return newAppData;
  }
}
