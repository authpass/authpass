import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

part 'cloud_storage_provider.g.dart';

enum CloudStorageEntityType {
  file,
  directory,
}

abstract class CloudStorageEntity implements Built<CloudStorageEntity, CloudStorageEntityBuilder> {
  factory CloudStorageEntity([void updates(CloudStorageEntityBuilder b)]) = _$CloudStorageEntity;
  CloudStorageEntity._();

  String get id;
  CloudStorageEntityType get type;
  String get name;
}

abstract class SearchResponse implements Built<SearchResponse, SearchResponseBuilder> {
  factory SearchResponse([void updates(SearchResponseBuilder b)]) = _$SearchResponse;
  SearchResponse._();

  BuiltList<CloudStorageEntity> get results;
  bool get hasMore;
}

typedef PromptUserForCode = Future<String> Function(String openUri);

abstract class CloudStorageProvider {
  /// whether we are initialized, authenticated and ready for requests.
  bool get isAuthenticated;

  String get id => runtimeType.toString();
  String get displayName;
  Future<bool> startAuth(PromptUserForCode prompt);
  Future<SearchResponse> searchKdbx();
}
