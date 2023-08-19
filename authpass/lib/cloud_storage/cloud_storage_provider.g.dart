// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloud_storage_provider.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CloudStorageEntity extends CloudStorageEntity {
  @override
  final String id;
  @override
  final CloudStorageEntityType? type;
  @override
  final String? name;
  @override
  final String? path;

  factory _$CloudStorageEntity(
          [void Function(CloudStorageEntityBuilder)? updates]) =>
      (new CloudStorageEntityBuilder()..update(updates))._build();

  _$CloudStorageEntity._({required this.id, this.type, this.name, this.path})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'CloudStorageEntity', 'id');
  }

  @override
  CloudStorageEntity rebuild(
          void Function(CloudStorageEntityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CloudStorageEntityBuilder toBuilder() =>
      new CloudStorageEntityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CloudStorageEntity &&
        id == other.id &&
        type == other.type &&
        name == other.name &&
        path == other.path;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CloudStorageEntity')
          ..add('id', id)
          ..add('type', type)
          ..add('name', name)
          ..add('path', path))
        .toString();
  }
}

class CloudStorageEntityBuilder
    implements Builder<CloudStorageEntity, CloudStorageEntityBuilder> {
  _$CloudStorageEntity? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CloudStorageEntityType? _type;
  CloudStorageEntityType? get type => _$this._type;
  set type(CloudStorageEntityType? type) => _$this._type = type;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  CloudStorageEntityBuilder();

  CloudStorageEntityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _name = $v.name;
      _path = $v.path;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CloudStorageEntity other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CloudStorageEntity;
  }

  @override
  void update(void Function(CloudStorageEntityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CloudStorageEntity build() => _build();

  _$CloudStorageEntity _build() {
    final _$result = _$v ??
        new _$CloudStorageEntity._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CloudStorageEntity', 'id'),
            type: type,
            name: name,
            path: path);
    replace(_$result);
    return _$result;
  }
}

class _$SearchResponse extends SearchResponse {
  @override
  final BuiltList<CloudStorageEntity?> results;
  @override
  final bool hasMore;

  factory _$SearchResponse([void Function(SearchResponseBuilder)? updates]) =>
      (new SearchResponseBuilder()..update(updates))._build();

  _$SearchResponse._({required this.results, required this.hasMore})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        results, r'SearchResponse', 'results');
    BuiltValueNullFieldError.checkNotNull(
        hasMore, r'SearchResponse', 'hasMore');
  }

  @override
  SearchResponse rebuild(void Function(SearchResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchResponseBuilder toBuilder() =>
      new SearchResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchResponse &&
        results == other.results &&
        hasMore == other.hasMore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, results.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchResponse')
          ..add('results', results)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class SearchResponseBuilder
    implements Builder<SearchResponse, SearchResponseBuilder> {
  _$SearchResponse? _$v;

  ListBuilder<CloudStorageEntity?>? _results;
  ListBuilder<CloudStorageEntity?> get results =>
      _$this._results ??= new ListBuilder<CloudStorageEntity?>();
  set results(ListBuilder<CloudStorageEntity?>? results) =>
      _$this._results = results;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  SearchResponseBuilder();

  SearchResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _results = $v.results.toBuilder();
      _hasMore = $v.hasMore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SearchResponse;
  }

  @override
  void update(void Function(SearchResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchResponse build() => _build();

  _$SearchResponse _build() {
    _$SearchResponse _$result;
    try {
      _$result = _$v ??
          new _$SearchResponse._(
              results: results.build(),
              hasMore: BuiltValueNullFieldError.checkNotNull(
                  hasMore, r'SearchResponse', 'hasMore'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'results';
        results.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'SearchResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
