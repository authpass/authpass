enum CloudStorageEntityType {
  file,
  directory,
}

abstract class CloudStorageEntity {
  String get id;
  CloudStorageEntity get type;
  String get name;
}

abstract class SearchResponse {
  List<CloudStorageEntity> get results;
  bool get hasMore;
}

typedef PromptUserForCode = Future<String> Function(String openUri);

abstract class CloudStorageProvider {
  Future<bool> startAuth(PromptUserForCode prompt);
  Future<SearchResponse> searchKdbx();
}
