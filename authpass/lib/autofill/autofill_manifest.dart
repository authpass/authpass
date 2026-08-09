import 'dart:convert';

import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

/// Index of the vaults mirrored into the app group container for the
/// credential provider extension.
///
/// The extension has no access to `AppData`, the security scoped bookmarks the
/// app opens files with, or anything else app-side — this file plus the
/// mirrored kdbx bytes are the whole of what it can see.
///
/// Written by the app only. Deliberately plain json rather than built_value:
/// the extension's Dart module parses it too, and that module depends on
/// `kdbx` and nothing else.
@NonNls
class AutofillManifest {
  AutofillManifest({required this.entries});

  factory AutofillManifest.fromJson(Map<String, Object?> json) {
    final version = json['version'] as int? ?? 0;
    if (version > currentVersion) {
      // written by a newer app than the extension bundled with it. Refuse
      // rather than guess at the shape.
      throw FormatException('unsupported autofill manifest version $version');
    }
    return AutofillManifest(
      entries: (json['entries'] as List<Object?>? ?? [])
          .map(
            (e) => AutofillManifestEntry.fromJson(
              (e as Map<Object?, Object?>).cast<String, Object?>(),
            ),
          )
          .toList(),
    );
  }

  factory AutofillManifest.parse(String source) => AutofillManifest.fromJson(
    (json.decode(source) as Map<Object?, Object?>).cast<String, Object?>(),
  );

  static const currentVersion = 1;

  static const fileName = 'autofill_manifest.json';

  final List<AutofillManifestEntry> entries;

  AutofillManifestEntry? byFileUuid(String fileUuid) =>
      entries.where((entry) => entry.fileUuid == fileUuid).firstOrNull;

  /// Replaces the entry for [entry]'s file, or appends it.
  AutofillManifest withEntry(AutofillManifestEntry entry) => AutofillManifest(
    entries: [
      ...entries.where((e) => e.fileUuid != entry.fileUuid),
      entry,
    ],
  );

  AutofillManifest withoutFileUuid(String fileUuid) => AutofillManifest(
    entries: entries.where((e) => e.fileUuid != fileUuid).toList(),
  );

  Map<String, Object?> toJson() => {
    'version': currentVersion,
    'entries': entries.map((e) => e.toJson()).toList(),
  };

  String encode() => json.encode(toJson());

  @override
  String toString() => 'AutofillManifest{entries: ${entries.length}}';
}

/// One mirrored vault.
@NonNls
class AutofillManifestEntry {
  AutofillManifestEntry({
    required this.fileUuid,
    required this.name,
    required this.fileName,
    required this.updatedAt,
    required this.kdfFingerprint,
  });

  factory AutofillManifestEntry.fromJson(Map<String, Object?> json) =>
      AutofillManifestEntry(
        fileUuid: json['fileUuid']! as String,
        name: json['name']! as String,
        fileName: json['fileName']! as String,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          json['updatedAt']! as int,
          isUtc: true,
        ),
        kdfFingerprint: json['kdfFingerprint']! as String,
      );

  /// Uuid of the [FileSource], which is also the key the transformed key is
  /// stored under in the shared keychain.
  final String fileUuid;

  /// Database name, for the extension's picker.
  final String name;

  /// Name of the mirrored kdbx inside the container, relative to the manifest.
  final String fileName;

  /// When the app last wrote this copy.
  final DateTime updatedAt;

  /// [KdbxFile.kdfFingerprint] of the mirrored copy.
  ///
  /// The extension compares this against the fingerprint stored with its
  /// cached key. A mismatch means the vault was saved elsewhere and the key is
  /// stale, which is a "open AuthPass to refresh" case rather than an error.
  final String kdfFingerprint;

  Map<String, Object?> toJson() => {
    'fileUuid': fileUuid,
    'name': name,
    'fileName': fileName,
    'updatedAt': updatedAt.toUtc().millisecondsSinceEpoch,
    'kdfFingerprint': kdfFingerprint,
  };

  @override
  String toString() =>
      'AutofillManifestEntry{fileUuid: $fileUuid, name: $name, '
      'fileName: $fileName, updatedAt: $updatedAt}';
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
