import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

enum StorageExceptionType {
  conflict,
  unknown,
  authentication,
}

abstract class StorageException implements Exception {
  StorageException._(this.type, this.details, {this.errorBody});
  factory StorageException.conflict(String details, {String? errorBody}) =
      StorageConflictException;
  factory StorageException.unknown(String details, {String? errorBody}) =
      StorageUnknownException;
  factory StorageException.authentication(String details) =
      AuthenticationException;

  final StorageExceptionType type;
  final String details;
  final String? errorBody;

  @NonNls
  @override
  String toString() {
    return 'StorageException{type: $type, details: $details, errorBody: $errorBody}';
  }
}

class StorageConflictException extends StorageException {
  StorageConflictException(String details, {String? errorBody})
      : super._(StorageExceptionType.conflict, details, errorBody: errorBody);
}

class AuthenticationException extends StorageException {
  AuthenticationException(String details)
      : super._(StorageExceptionType.authentication, details);
}

class StorageUnknownException extends StorageException {
  StorageUnknownException(String details, {String? errorBody})
      : super._(StorageExceptionType.unknown, details, errorBody: errorBody);
}
