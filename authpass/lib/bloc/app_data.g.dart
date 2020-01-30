// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data.dart';

// **************************************************************************
// AnalyticsEventGenerator
// **************************************************************************

// ignore_for_file: unnecessary_statements

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(AppData.serializer)
      ..add(OpenedFile.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OpenedFile)]),
          () => new ListBuilder<OpenedFile>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(String)]),
          () => new SetBuilder<String>()))
    .build();
Serializer<OpenedFile> _$openedFileSerializer = new _$OpenedFileSerializer();
Serializer<AppData> _$appDataSerializer = new _$AppDataSerializer();

class _$OpenedFileSerializer implements StructuredSerializer<OpenedFile> {
  @override
  final Iterable<Type> types = const [OpenedFile, _$OpenedFile];
  @override
  final String wireName = 'OpenedFile';

  @override
  Iterable<Object> serialize(Serializers serializers, OpenedFile object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'lastOpenedAt',
      serializers.serialize(object.lastOpenedAt,
          specifiedType: const FullType(DateTime)),
      'sourceType',
      serializers.serialize(object.sourceType,
          specifiedType: const FullType(OpenedFilesSourceType)),
      'sourcePath',
      serializers.serialize(object.sourcePath,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    if (object.uuid != null) {
      result
        ..add('uuid')
        ..add(serializers.serialize(object.uuid,
            specifiedType: const FullType(String)));
    }
    if (object.biometricStoreName != null) {
      result
        ..add('biometricStoreName')
        ..add(serializers.serialize(object.biometricStoreName,
            specifiedType: const FullType(String)));
    }
    if (object.macOsSecureBookmark != null) {
      result
        ..add('macOsSecureBookmark')
        ..add(serializers.serialize(object.macOsSecureBookmark,
            specifiedType: const FullType(String)));
    }
    if (object.colorCode != null) {
      result
        ..add('colorCode')
        ..add(serializers.serialize(object.colorCode,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  OpenedFile deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OpenedFileBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'uuid':
          result.uuid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'lastOpenedAt':
          result.lastOpenedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'sourceType':
          result.sourceType = serializers.deserialize(value,
                  specifiedType: const FullType(OpenedFilesSourceType))
              as OpenedFilesSourceType;
          break;
        case 'sourcePath':
          result.sourcePath = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'biometricStoreName':
          result.biometricStoreName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'macOsSecureBookmark':
          result.macOsSecureBookmark = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'colorCode':
          result.colorCode = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$AppDataSerializer implements StructuredSerializer<AppData> {
  @override
  final Iterable<Type> types = const [AppData, _$AppData];
  @override
  final String wireName = 'AppData';

  @override
  Iterable<Object> serialize(Serializers serializers, AppData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'previousFiles',
      serializers.serialize(object.previousFiles,
          specifiedType:
              const FullType(BuiltList, const [const FullType(OpenedFile)])),
      'passwordGeneratorCharacterSets',
      serializers.serialize(object.passwordGeneratorCharacterSets,
          specifiedType:
              const FullType(BuiltSet, const [const FullType(String)])),
    ];
    if (object.passwordGeneratorLength != null) {
      result
        ..add('passwordGeneratorLength')
        ..add(serializers.serialize(object.passwordGeneratorLength,
            specifiedType: const FullType(int)));
    }
    if (object.manualUserType != null) {
      result
        ..add('manualUserType')
        ..add(serializers.serialize(object.manualUserType,
            specifiedType: const FullType(String)));
    }
    if (object.firstLaunchedAt != null) {
      result
        ..add('firstLaunchedAt')
        ..add(serializers.serialize(object.firstLaunchedAt,
            specifiedType: const FullType(DateTime)));
    }
    if (object.lastBuildId != null) {
      result
        ..add('lastBuildId')
        ..add(serializers.serialize(object.lastBuildId,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  AppData deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'previousFiles':
          result.previousFiles.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(OpenedFile)]))
              as BuiltList<Object>);
          break;
        case 'passwordGeneratorLength':
          result.passwordGeneratorLength = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'passwordGeneratorCharacterSets':
          result.passwordGeneratorCharacterSets.replace(serializers.deserialize(
                  value,
                  specifiedType:
                      const FullType(BuiltSet, const [const FullType(String)]))
              as BuiltSet<Object>);
          break;
        case 'manualUserType':
          result.manualUserType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'firstLaunchedAt':
          result.firstLaunchedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'lastBuildId':
          result.lastBuildId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$OpenedFile extends OpenedFile {
  @override
  final String uuid;
  @override
  final DateTime lastOpenedAt;
  @override
  final OpenedFilesSourceType sourceType;
  @override
  final String sourcePath;
  @override
  final String name;
  @override
  final String biometricStoreName;
  @override
  final String macOsSecureBookmark;
  @override
  final int colorCode;

  factory _$OpenedFile([void Function(OpenedFileBuilder) updates]) =>
      (new OpenedFileBuilder()..update(updates)).build();

  _$OpenedFile._(
      {this.uuid,
      this.lastOpenedAt,
      this.sourceType,
      this.sourcePath,
      this.name,
      this.biometricStoreName,
      this.macOsSecureBookmark,
      this.colorCode})
      : super._() {
    if (lastOpenedAt == null) {
      throw new BuiltValueNullFieldError('OpenedFile', 'lastOpenedAt');
    }
    if (sourceType == null) {
      throw new BuiltValueNullFieldError('OpenedFile', 'sourceType');
    }
    if (sourcePath == null) {
      throw new BuiltValueNullFieldError('OpenedFile', 'sourcePath');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('OpenedFile', 'name');
    }
  }

  @override
  OpenedFile rebuild(void Function(OpenedFileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OpenedFileBuilder toBuilder() => new OpenedFileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OpenedFile &&
        uuid == other.uuid &&
        sourceType == other.sourceType &&
        sourcePath == other.sourcePath &&
        name == other.name &&
        biometricStoreName == other.biometricStoreName &&
        macOsSecureBookmark == other.macOsSecureBookmark &&
        colorCode == other.colorCode;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, uuid.hashCode), sourceType.hashCode),
                        sourcePath.hashCode),
                    name.hashCode),
                biometricStoreName.hashCode),
            macOsSecureBookmark.hashCode),
        colorCode.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('OpenedFile')
          ..add('uuid', uuid)
          ..add('lastOpenedAt', lastOpenedAt)
          ..add('sourceType', sourceType)
          ..add('sourcePath', sourcePath)
          ..add('name', name)
          ..add('biometricStoreName', biometricStoreName)
          ..add('macOsSecureBookmark', macOsSecureBookmark)
          ..add('colorCode', colorCode))
        .toString();
  }
}

class OpenedFileBuilder implements Builder<OpenedFile, OpenedFileBuilder> {
  _$OpenedFile _$v;

  String _uuid;
  String get uuid => _$this._uuid;
  set uuid(String uuid) => _$this._uuid = uuid;

  DateTime _lastOpenedAt;
  DateTime get lastOpenedAt => _$this._lastOpenedAt;
  set lastOpenedAt(DateTime lastOpenedAt) =>
      _$this._lastOpenedAt = lastOpenedAt;

  OpenedFilesSourceType _sourceType;
  OpenedFilesSourceType get sourceType => _$this._sourceType;
  set sourceType(OpenedFilesSourceType sourceType) =>
      _$this._sourceType = sourceType;

  String _sourcePath;
  String get sourcePath => _$this._sourcePath;
  set sourcePath(String sourcePath) => _$this._sourcePath = sourcePath;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _biometricStoreName;
  String get biometricStoreName => _$this._biometricStoreName;
  set biometricStoreName(String biometricStoreName) =>
      _$this._biometricStoreName = biometricStoreName;

  String _macOsSecureBookmark;
  String get macOsSecureBookmark => _$this._macOsSecureBookmark;
  set macOsSecureBookmark(String macOsSecureBookmark) =>
      _$this._macOsSecureBookmark = macOsSecureBookmark;

  int _colorCode;
  int get colorCode => _$this._colorCode;
  set colorCode(int colorCode) => _$this._colorCode = colorCode;

  OpenedFileBuilder();

  OpenedFileBuilder get _$this {
    if (_$v != null) {
      _uuid = _$v.uuid;
      _lastOpenedAt = _$v.lastOpenedAt;
      _sourceType = _$v.sourceType;
      _sourcePath = _$v.sourcePath;
      _name = _$v.name;
      _biometricStoreName = _$v.biometricStoreName;
      _macOsSecureBookmark = _$v.macOsSecureBookmark;
      _colorCode = _$v.colorCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OpenedFile other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$OpenedFile;
  }

  @override
  void update(void Function(OpenedFileBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$OpenedFile build() {
    final _$result = _$v ??
        new _$OpenedFile._(
            uuid: uuid,
            lastOpenedAt: lastOpenedAt,
            sourceType: sourceType,
            sourcePath: sourcePath,
            name: name,
            biometricStoreName: biometricStoreName,
            macOsSecureBookmark: macOsSecureBookmark,
            colorCode: colorCode);
    replace(_$result);
    return _$result;
  }
}

class _$AppData extends AppData {
  @override
  final BuiltList<OpenedFile> previousFiles;
  @override
  final int passwordGeneratorLength;
  @override
  final BuiltSet<String> passwordGeneratorCharacterSets;
  @override
  final String manualUserType;
  @override
  final DateTime firstLaunchedAt;
  @override
  final int lastBuildId;

  factory _$AppData([void Function(AppDataBuilder) updates]) =>
      (new AppDataBuilder()..update(updates)).build();

  _$AppData._(
      {this.previousFiles,
      this.passwordGeneratorLength,
      this.passwordGeneratorCharacterSets,
      this.manualUserType,
      this.firstLaunchedAt,
      this.lastBuildId})
      : super._() {
    if (previousFiles == null) {
      throw new BuiltValueNullFieldError('AppData', 'previousFiles');
    }
    if (passwordGeneratorCharacterSets == null) {
      throw new BuiltValueNullFieldError(
          'AppData', 'passwordGeneratorCharacterSets');
    }
  }

  @override
  AppData rebuild(void Function(AppDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppDataBuilder toBuilder() => new AppDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppData &&
        previousFiles == other.previousFiles &&
        passwordGeneratorLength == other.passwordGeneratorLength &&
        passwordGeneratorCharacterSets ==
            other.passwordGeneratorCharacterSets &&
        manualUserType == other.manualUserType &&
        firstLaunchedAt == other.firstLaunchedAt &&
        lastBuildId == other.lastBuildId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc(0, previousFiles.hashCode),
                        passwordGeneratorLength.hashCode),
                    passwordGeneratorCharacterSets.hashCode),
                manualUserType.hashCode),
            firstLaunchedAt.hashCode),
        lastBuildId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppData')
          ..add('previousFiles', previousFiles)
          ..add('passwordGeneratorLength', passwordGeneratorLength)
          ..add(
              'passwordGeneratorCharacterSets', passwordGeneratorCharacterSets)
          ..add('manualUserType', manualUserType)
          ..add('firstLaunchedAt', firstLaunchedAt)
          ..add('lastBuildId', lastBuildId))
        .toString();
  }
}

class AppDataBuilder implements Builder<AppData, AppDataBuilder> {
  _$AppData _$v;

  ListBuilder<OpenedFile> _previousFiles;
  ListBuilder<OpenedFile> get previousFiles =>
      _$this._previousFiles ??= new ListBuilder<OpenedFile>();
  set previousFiles(ListBuilder<OpenedFile> previousFiles) =>
      _$this._previousFiles = previousFiles;

  int _passwordGeneratorLength;
  int get passwordGeneratorLength => _$this._passwordGeneratorLength;
  set passwordGeneratorLength(int passwordGeneratorLength) =>
      _$this._passwordGeneratorLength = passwordGeneratorLength;

  SetBuilder<String> _passwordGeneratorCharacterSets;
  SetBuilder<String> get passwordGeneratorCharacterSets =>
      _$this._passwordGeneratorCharacterSets ??= new SetBuilder<String>();
  set passwordGeneratorCharacterSets(
          SetBuilder<String> passwordGeneratorCharacterSets) =>
      _$this._passwordGeneratorCharacterSets = passwordGeneratorCharacterSets;

  String _manualUserType;
  String get manualUserType => _$this._manualUserType;
  set manualUserType(String manualUserType) =>
      _$this._manualUserType = manualUserType;

  DateTime _firstLaunchedAt;
  DateTime get firstLaunchedAt => _$this._firstLaunchedAt;
  set firstLaunchedAt(DateTime firstLaunchedAt) =>
      _$this._firstLaunchedAt = firstLaunchedAt;

  int _lastBuildId;
  int get lastBuildId => _$this._lastBuildId;
  set lastBuildId(int lastBuildId) => _$this._lastBuildId = lastBuildId;

  AppDataBuilder();

  AppDataBuilder get _$this {
    if (_$v != null) {
      _previousFiles = _$v.previousFiles?.toBuilder();
      _passwordGeneratorLength = _$v.passwordGeneratorLength;
      _passwordGeneratorCharacterSets =
          _$v.passwordGeneratorCharacterSets?.toBuilder();
      _manualUserType = _$v.manualUserType;
      _firstLaunchedAt = _$v.firstLaunchedAt;
      _lastBuildId = _$v.lastBuildId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppData;
  }

  @override
  void update(void Function(AppDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppData build() {
    _$AppData _$result;
    try {
      _$result = _$v ??
          new _$AppData._(
              previousFiles: previousFiles.build(),
              passwordGeneratorLength: passwordGeneratorLength,
              passwordGeneratorCharacterSets:
                  passwordGeneratorCharacterSets.build(),
              manualUserType: manualUserType,
              firstLaunchedAt: firstLaunchedAt,
              lastBuildId: lastBuildId);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'previousFiles';
        previousFiles.build();

        _$failedField = 'passwordGeneratorCharacterSets';
        passwordGeneratorCharacterSets.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AppData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

// **************************************************************************
// StaticTextGenerator
// **************************************************************************

// ignore_for_file: implicit_dynamic_parameter,strong_mode_implicit_dynamic_parameter,strong_mode_implicit_dynamic_variable,non_constant_identifier_names,unused_element
