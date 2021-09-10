// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data.dart';

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
          () => new SetBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>()))
    .build();
Serializer<OpenedFile> _$openedFileSerializer = new _$OpenedFileSerializer();
Serializer<AppData> _$appDataSerializer = new _$AppDataSerializer();

class _$OpenedFileSerializer implements StructuredSerializer<OpenedFile> {
  @override
  final Iterable<Type> types = const [OpenedFile, _$OpenedFile];
  @override
  final String wireName = 'OpenedFile';

  @override
  Iterable<Object?> serialize(Serializers serializers, OpenedFile object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'uuid',
      serializers.serialize(object.uuid, specifiedType: const FullType(String)),
      'sourceType',
      serializers.serialize(object.sourceType,
          specifiedType: const FullType(OpenedFilesSourceType)),
      'sourcePath',
      serializers.serialize(object.sourcePath,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.lastOpenedAt;
    if (value != null) {
      result
        ..add('lastOpenedAt')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.biometricStoreName;
    if (value != null) {
      result
        ..add('biometricStoreName')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.macOsSecureBookmark;
    if (value != null) {
      result
        ..add('macOsSecureBookmark')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.filePickerIdentifier;
    if (value != null) {
      result
        ..add('filePickerIdentifier')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.colorCode;
    if (value != null) {
      result
        ..add('colorCode')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  OpenedFile deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OpenedFileBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'uuid':
          result.uuid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'lastOpenedAt':
          result.lastOpenedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
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
              specifiedType: const FullType(String)) as String?;
          break;
        case 'macOsSecureBookmark':
          result.macOsSecureBookmark = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'filePickerIdentifier':
          result.filePickerIdentifier = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'colorCode':
          result.colorCode = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
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
  Iterable<Object?> serialize(Serializers serializers, AppData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'previousFiles',
      serializers.serialize(object.previousFiles,
          specifiedType:
              const FullType(BuiltList, const [const FullType(OpenedFile)])),
      'passwordGeneratorCharacterSets',
      serializers.serialize(object.passwordGeneratorCharacterSets,
          specifiedType:
              const FullType(BuiltSet, const [const FullType(String)])),
      'systemWideShortcuts',
      serializers.serialize(object.systemWideShortcuts,
          specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.passwordGeneratorLength;
    if (value != null) {
      result
        ..add('passwordGeneratorLength')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.manualUserType;
    if (value != null) {
      result
        ..add('manualUserType')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.firstLaunchedAt;
    if (value != null) {
      result
        ..add('firstLaunchedAt')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.theme;
    if (value != null) {
      result
        ..add('theme')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(AppDataTheme)));
    }
    value = object.dismissedBackupLocalFiles;
    if (value != null) {
      result
        ..add('dismissedBackupLocalFiles')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.dismissedAutofillSuggestion;
    if (value != null) {
      result
        ..add('dismissedAutofillSuggestion')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.themeVisualDensity;
    if (value != null) {
      result
        ..add('themeVisualDensity')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.themeFontSizeFactor;
    if (value != null) {
      result
        ..add('themeFontSizeFactor')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.diacOptIn;
    if (value != null) {
      result
        ..add('diacOptIn')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.lastBuildId;
    if (value != null) {
      result
        ..add('lastBuildId')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.secureWindow;
    if (value != null) {
      result
        ..add('secureWindow')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.localeOverride;
    if (value != null) {
      result
        ..add('localeOverride')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.fetchWebsiteIcons;
    if (value != null) {
      result
        ..add('fetchWebsiteIcons')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.authPassCloudAttachments;
    if (value != null) {
      result
        ..add('authPassCloudAttachments')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.searchFields;
    if (value != null) {
      result
        ..add('searchFields')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  AppData deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'previousFiles':
          result.previousFiles.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(OpenedFile)]))!
              as BuiltList<Object?>);
          break;
        case 'passwordGeneratorLength':
          result.passwordGeneratorLength = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'passwordGeneratorCharacterSets':
          result.passwordGeneratorCharacterSets.replace(serializers.deserialize(
                  value,
                  specifiedType:
                      const FullType(BuiltSet, const [const FullType(String)]))!
              as BuiltSet<Object?>);
          break;
        case 'manualUserType':
          result.manualUserType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'firstLaunchedAt':
          result.firstLaunchedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'theme':
          result.theme = serializers.deserialize(value,
              specifiedType: const FullType(AppDataTheme)) as AppDataTheme?;
          break;
        case 'dismissedBackupLocalFiles':
          result.dismissedBackupLocalFiles.replace(serializers.deserialize(
                  value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'dismissedAutofillSuggestion':
          result.dismissedAutofillSuggestion = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'themeVisualDensity':
          result.themeVisualDensity = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'themeFontSizeFactor':
          result.themeFontSizeFactor = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'diacOptIn':
          result.diacOptIn = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'lastBuildId':
          result.lastBuildId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'secureWindow':
          result.secureWindow = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'localeOverride':
          result.localeOverride = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'fetchWebsiteIcons':
          result.fetchWebsiteIcons = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'authPassCloudAttachments':
          result.authPassCloudAttachments = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'systemWideShortcuts':
          result.systemWideShortcuts = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'searchFields':
          result.searchFields = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
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
  final DateTime? lastOpenedAt;
  @override
  final OpenedFilesSourceType sourceType;
  @override
  final String sourcePath;
  @override
  final String name;
  @override
  final String? biometricStoreName;
  @override
  final String? macOsSecureBookmark;
  @override
  final String? filePickerIdentifier;
  @override
  final int? colorCode;

  factory _$OpenedFile([void Function(OpenedFileBuilder)? updates]) =>
      (new OpenedFileBuilder()..update(updates)).build();

  _$OpenedFile._(
      {required this.uuid,
      this.lastOpenedAt,
      required this.sourceType,
      required this.sourcePath,
      required this.name,
      this.biometricStoreName,
      this.macOsSecureBookmark,
      this.filePickerIdentifier,
      this.colorCode})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(uuid, 'OpenedFile', 'uuid');
    BuiltValueNullFieldError.checkNotNull(
        sourceType, 'OpenedFile', 'sourceType');
    BuiltValueNullFieldError.checkNotNull(
        sourcePath, 'OpenedFile', 'sourcePath');
    BuiltValueNullFieldError.checkNotNull(name, 'OpenedFile', 'name');
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
        filePickerIdentifier == other.filePickerIdentifier &&
        colorCode == other.colorCode;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, uuid.hashCode), sourceType.hashCode),
                            sourcePath.hashCode),
                        name.hashCode),
                    biometricStoreName.hashCode),
                macOsSecureBookmark.hashCode),
            filePickerIdentifier.hashCode),
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
          ..add('filePickerIdentifier', filePickerIdentifier)
          ..add('colorCode', colorCode))
        .toString();
  }
}

class OpenedFileBuilder implements Builder<OpenedFile, OpenedFileBuilder> {
  _$OpenedFile? _$v;

  String? _uuid;
  String? get uuid => _$this._uuid;
  set uuid(String? uuid) => _$this._uuid = uuid;

  DateTime? _lastOpenedAt;
  DateTime? get lastOpenedAt => _$this._lastOpenedAt;
  set lastOpenedAt(DateTime? lastOpenedAt) =>
      _$this._lastOpenedAt = lastOpenedAt;

  OpenedFilesSourceType? _sourceType;
  OpenedFilesSourceType? get sourceType => _$this._sourceType;
  set sourceType(OpenedFilesSourceType? sourceType) =>
      _$this._sourceType = sourceType;

  String? _sourcePath;
  String? get sourcePath => _$this._sourcePath;
  set sourcePath(String? sourcePath) => _$this._sourcePath = sourcePath;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _biometricStoreName;
  String? get biometricStoreName => _$this._biometricStoreName;
  set biometricStoreName(String? biometricStoreName) =>
      _$this._biometricStoreName = biometricStoreName;

  String? _macOsSecureBookmark;
  String? get macOsSecureBookmark => _$this._macOsSecureBookmark;
  set macOsSecureBookmark(String? macOsSecureBookmark) =>
      _$this._macOsSecureBookmark = macOsSecureBookmark;

  String? _filePickerIdentifier;
  String? get filePickerIdentifier => _$this._filePickerIdentifier;
  set filePickerIdentifier(String? filePickerIdentifier) =>
      _$this._filePickerIdentifier = filePickerIdentifier;

  int? _colorCode;
  int? get colorCode => _$this._colorCode;
  set colorCode(int? colorCode) => _$this._colorCode = colorCode;

  OpenedFileBuilder();

  OpenedFileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uuid = $v.uuid;
      _lastOpenedAt = $v.lastOpenedAt;
      _sourceType = $v.sourceType;
      _sourcePath = $v.sourcePath;
      _name = $v.name;
      _biometricStoreName = $v.biometricStoreName;
      _macOsSecureBookmark = $v.macOsSecureBookmark;
      _filePickerIdentifier = $v.filePickerIdentifier;
      _colorCode = $v.colorCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OpenedFile other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OpenedFile;
  }

  @override
  void update(void Function(OpenedFileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$OpenedFile build() {
    final _$result = _$v ??
        new _$OpenedFile._(
            uuid: BuiltValueNullFieldError.checkNotNull(
                uuid, 'OpenedFile', 'uuid'),
            lastOpenedAt: lastOpenedAt,
            sourceType: BuiltValueNullFieldError.checkNotNull(
                sourceType, 'OpenedFile', 'sourceType'),
            sourcePath: BuiltValueNullFieldError.checkNotNull(
                sourcePath, 'OpenedFile', 'sourcePath'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'OpenedFile', 'name'),
            biometricStoreName: biometricStoreName,
            macOsSecureBookmark: macOsSecureBookmark,
            filePickerIdentifier: filePickerIdentifier,
            colorCode: colorCode);
    replace(_$result);
    return _$result;
  }
}

class _$AppData extends AppData {
  @override
  final BuiltList<OpenedFile> previousFiles;
  @override
  final int? passwordGeneratorLength;
  @override
  final BuiltSet<String> passwordGeneratorCharacterSets;
  @override
  final String? manualUserType;
  @override
  final DateTime? firstLaunchedAt;
  @override
  final AppDataTheme? theme;
  @override
  final BuiltList<String>? dismissedBackupLocalFiles;
  @override
  final bool? dismissedAutofillSuggestion;
  @override
  final double? themeVisualDensity;
  @override
  final double? themeFontSizeFactor;
  @override
  final bool? diacOptIn;
  @override
  final int? lastBuildId;
  @override
  final bool? secureWindow;
  @override
  final String? localeOverride;
  @override
  final bool? fetchWebsiteIcons;
  @override
  final bool? authPassCloudAttachments;
  @override
  final bool systemWideShortcuts;
  @override
  final String? searchFields;

  factory _$AppData([void Function(AppDataBuilder)? updates]) =>
      (new AppDataBuilder()..update(updates)).build();

  _$AppData._(
      {required this.previousFiles,
      this.passwordGeneratorLength,
      required this.passwordGeneratorCharacterSets,
      this.manualUserType,
      this.firstLaunchedAt,
      this.theme,
      this.dismissedBackupLocalFiles,
      this.dismissedAutofillSuggestion,
      this.themeVisualDensity,
      this.themeFontSizeFactor,
      this.diacOptIn,
      this.lastBuildId,
      this.secureWindow,
      this.localeOverride,
      this.fetchWebsiteIcons,
      this.authPassCloudAttachments,
      required this.systemWideShortcuts,
      this.searchFields})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        previousFiles, 'AppData', 'previousFiles');
    BuiltValueNullFieldError.checkNotNull(passwordGeneratorCharacterSets,
        'AppData', 'passwordGeneratorCharacterSets');
    BuiltValueNullFieldError.checkNotNull(
        systemWideShortcuts, 'AppData', 'systemWideShortcuts');
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
        theme == other.theme &&
        dismissedBackupLocalFiles == other.dismissedBackupLocalFiles &&
        dismissedAutofillSuggestion == other.dismissedAutofillSuggestion &&
        themeVisualDensity == other.themeVisualDensity &&
        themeFontSizeFactor == other.themeFontSizeFactor &&
        diacOptIn == other.diacOptIn &&
        lastBuildId == other.lastBuildId &&
        secureWindow == other.secureWindow &&
        localeOverride == other.localeOverride &&
        fetchWebsiteIcons == other.fetchWebsiteIcons &&
        authPassCloudAttachments == other.authPassCloudAttachments &&
        systemWideShortcuts == other.systemWideShortcuts &&
        searchFields == other.searchFields;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            0,
                                                                            previousFiles
                                                                                .hashCode),
                                                                        passwordGeneratorLength
                                                                            .hashCode),
                                                                    passwordGeneratorCharacterSets
                                                                        .hashCode),
                                                                manualUserType
                                                                    .hashCode),
                                                            firstLaunchedAt
                                                                .hashCode),
                                                        theme.hashCode),
                                                    dismissedBackupLocalFiles
                                                        .hashCode),
                                                dismissedAutofillSuggestion
                                                    .hashCode),
                                            themeVisualDensity.hashCode),
                                        themeFontSizeFactor.hashCode),
                                    diacOptIn.hashCode),
                                lastBuildId.hashCode),
                            secureWindow.hashCode),
                        localeOverride.hashCode),
                    fetchWebsiteIcons.hashCode),
                authPassCloudAttachments.hashCode),
            systemWideShortcuts.hashCode),
        searchFields.hashCode));
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
          ..add('theme', theme)
          ..add('dismissedBackupLocalFiles', dismissedBackupLocalFiles)
          ..add('dismissedAutofillSuggestion', dismissedAutofillSuggestion)
          ..add('themeVisualDensity', themeVisualDensity)
          ..add('themeFontSizeFactor', themeFontSizeFactor)
          ..add('diacOptIn', diacOptIn)
          ..add('lastBuildId', lastBuildId)
          ..add('secureWindow', secureWindow)
          ..add('localeOverride', localeOverride)
          ..add('fetchWebsiteIcons', fetchWebsiteIcons)
          ..add('authPassCloudAttachments', authPassCloudAttachments)
          ..add('systemWideShortcuts', systemWideShortcuts)
          ..add('searchFields', searchFields))
        .toString();
  }
}

class AppDataBuilder implements Builder<AppData, AppDataBuilder> {
  _$AppData? _$v;

  ListBuilder<OpenedFile>? _previousFiles;
  ListBuilder<OpenedFile> get previousFiles =>
      _$this._previousFiles ??= new ListBuilder<OpenedFile>();
  set previousFiles(ListBuilder<OpenedFile>? previousFiles) =>
      _$this._previousFiles = previousFiles;

  int? _passwordGeneratorLength;
  int? get passwordGeneratorLength => _$this._passwordGeneratorLength;
  set passwordGeneratorLength(int? passwordGeneratorLength) =>
      _$this._passwordGeneratorLength = passwordGeneratorLength;

  SetBuilder<String>? _passwordGeneratorCharacterSets;
  SetBuilder<String> get passwordGeneratorCharacterSets =>
      _$this._passwordGeneratorCharacterSets ??= new SetBuilder<String>();
  set passwordGeneratorCharacterSets(
          SetBuilder<String>? passwordGeneratorCharacterSets) =>
      _$this._passwordGeneratorCharacterSets = passwordGeneratorCharacterSets;

  String? _manualUserType;
  String? get manualUserType => _$this._manualUserType;
  set manualUserType(String? manualUserType) =>
      _$this._manualUserType = manualUserType;

  DateTime? _firstLaunchedAt;
  DateTime? get firstLaunchedAt => _$this._firstLaunchedAt;
  set firstLaunchedAt(DateTime? firstLaunchedAt) =>
      _$this._firstLaunchedAt = firstLaunchedAt;

  AppDataTheme? _theme;
  AppDataTheme? get theme => _$this._theme;
  set theme(AppDataTheme? theme) => _$this._theme = theme;

  ListBuilder<String>? _dismissedBackupLocalFiles;
  ListBuilder<String> get dismissedBackupLocalFiles =>
      _$this._dismissedBackupLocalFiles ??= new ListBuilder<String>();
  set dismissedBackupLocalFiles(
          ListBuilder<String>? dismissedBackupLocalFiles) =>
      _$this._dismissedBackupLocalFiles = dismissedBackupLocalFiles;

  bool? _dismissedAutofillSuggestion;
  bool? get dismissedAutofillSuggestion => _$this._dismissedAutofillSuggestion;
  set dismissedAutofillSuggestion(bool? dismissedAutofillSuggestion) =>
      _$this._dismissedAutofillSuggestion = dismissedAutofillSuggestion;

  double? _themeVisualDensity;
  double? get themeVisualDensity => _$this._themeVisualDensity;
  set themeVisualDensity(double? themeVisualDensity) =>
      _$this._themeVisualDensity = themeVisualDensity;

  double? _themeFontSizeFactor;
  double? get themeFontSizeFactor => _$this._themeFontSizeFactor;
  set themeFontSizeFactor(double? themeFontSizeFactor) =>
      _$this._themeFontSizeFactor = themeFontSizeFactor;

  bool? _diacOptIn;
  bool? get diacOptIn => _$this._diacOptIn;
  set diacOptIn(bool? diacOptIn) => _$this._diacOptIn = diacOptIn;

  int? _lastBuildId;
  int? get lastBuildId => _$this._lastBuildId;
  set lastBuildId(int? lastBuildId) => _$this._lastBuildId = lastBuildId;

  bool? _secureWindow;
  bool? get secureWindow => _$this._secureWindow;
  set secureWindow(bool? secureWindow) => _$this._secureWindow = secureWindow;

  String? _localeOverride;
  String? get localeOverride => _$this._localeOverride;
  set localeOverride(String? localeOverride) =>
      _$this._localeOverride = localeOverride;

  bool? _fetchWebsiteIcons;
  bool? get fetchWebsiteIcons => _$this._fetchWebsiteIcons;
  set fetchWebsiteIcons(bool? fetchWebsiteIcons) =>
      _$this._fetchWebsiteIcons = fetchWebsiteIcons;

  bool? _authPassCloudAttachments;
  bool? get authPassCloudAttachments => _$this._authPassCloudAttachments;
  set authPassCloudAttachments(bool? authPassCloudAttachments) =>
      _$this._authPassCloudAttachments = authPassCloudAttachments;

  bool? _systemWideShortcuts;
  bool? get systemWideShortcuts => _$this._systemWideShortcuts;
  set systemWideShortcuts(bool? systemWideShortcuts) =>
      _$this._systemWideShortcuts = systemWideShortcuts;

  String? _searchFields;
  String? get searchFields => _$this._searchFields;
  set searchFields(String? searchFields) => _$this._searchFields = searchFields;

  AppDataBuilder() {
    AppData._setDefaults(this);
  }

  AppDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _previousFiles = $v.previousFiles.toBuilder();
      _passwordGeneratorLength = $v.passwordGeneratorLength;
      _passwordGeneratorCharacterSets =
          $v.passwordGeneratorCharacterSets.toBuilder();
      _manualUserType = $v.manualUserType;
      _firstLaunchedAt = $v.firstLaunchedAt;
      _theme = $v.theme;
      _dismissedBackupLocalFiles = $v.dismissedBackupLocalFiles?.toBuilder();
      _dismissedAutofillSuggestion = $v.dismissedAutofillSuggestion;
      _themeVisualDensity = $v.themeVisualDensity;
      _themeFontSizeFactor = $v.themeFontSizeFactor;
      _diacOptIn = $v.diacOptIn;
      _lastBuildId = $v.lastBuildId;
      _secureWindow = $v.secureWindow;
      _localeOverride = $v.localeOverride;
      _fetchWebsiteIcons = $v.fetchWebsiteIcons;
      _authPassCloudAttachments = $v.authPassCloudAttachments;
      _systemWideShortcuts = $v.systemWideShortcuts;
      _searchFields = $v.searchFields;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AppData;
  }

  @override
  void update(void Function(AppDataBuilder)? updates) {
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
              theme: theme,
              dismissedBackupLocalFiles: _dismissedBackupLocalFiles?.build(),
              dismissedAutofillSuggestion: dismissedAutofillSuggestion,
              themeVisualDensity: themeVisualDensity,
              themeFontSizeFactor: themeFontSizeFactor,
              diacOptIn: diacOptIn,
              lastBuildId: lastBuildId,
              secureWindow: secureWindow,
              localeOverride: localeOverride,
              fetchWebsiteIcons: fetchWebsiteIcons,
              authPassCloudAttachments: authPassCloudAttachments,
              systemWideShortcuts: BuiltValueNullFieldError.checkNotNull(
                  systemWideShortcuts, 'AppData', 'systemWideShortcuts'),
              searchFields: searchFields);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'previousFiles';
        previousFiles.build();

        _$failedField = 'passwordGeneratorCharacterSets';
        passwordGeneratorCharacterSets.build();

        _$failedField = 'dismissedBackupLocalFiles';
        _dismissedBackupLocalFiles?.build();
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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
