import 'package:authpass/utils/platform.dart';
import 'package:autofill_shared/credential_matcher.dart';
import 'package:flutter/services.dart';
import 'package:kdbx/kdbx.dart';
import 'package:logging/logging.dart';
import 'package:string_literal_finder_annotations/string_literal_finder_annotations.dart';

final _logger = Logger('autofill_identities');

/// Tells iOS which credentials exist, so it can offer them.
///
/// On iOS 18 and later the QuickType bar is built from
/// `ASCredentialIdentityStore`, and a provider that has registered nothing is
/// never asked for anything — `prepareCredentialList` is not called and the
/// extension appears broken. Publishing here is what makes it reachable.
///
/// Only a domain, a username and an opaque record id leave the app. The
/// password stays in the vault and is read by the extension when a row is
/// actually picked.
class AutofillIdentities {
  AutofillIdentities({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(_channelName);

  @NonNls
  static const _channelName = 'design.codeux.authpass/autofill_identities';

  final MethodChannel _channel;

  /// Record id the extension gets back when the user picks a suggestion.
  ///
  /// Carries the file as well as the entry: the extension holds several vaults
  /// open and an entry uuid alone would not say which one to look in.
  @NonNls
  static String recordIdentifier(String fileUuid, String entryUuid) =>
      '$fileUuid:$entryUuid';

  /// The two halves of [recordIdentifier], or null if it is not one of ours.
  static ({String fileUuid, String entryUuid})? parseRecordIdentifier(
    String value,
  ) {
    final separator = value.indexOf(':');
    if (separator <= 0 || separator == value.length - 1) {
      return null;
    }
    return (
      fileUuid: value.substring(0, separator),
      entryUuid: value.substring(separator + 1),
    );
  }

  bool get _isAvailable => AuthPassPlatform.isIOS;

  /// Publishes every entry of every enabled vault, replacing what was there.
  ///
  /// Replace rather than merge: this is the only moment the whole set is known,
  /// and an entry the user deleted has to stop being offered.
  Future<void> publish(Map<String, KdbxFile> filesByUuid) async {
    if (!_isAvailable) {
      return;
    }
    final identities = <Map<String, String>>[];
    for (final file in filesByUuid.entries) {
      // A vault the extension cannot open must not be advertised. Only kdbx4
      // exposes a transformed key, and without one AutofillMirror refuses to
      // mirror the file — so publishing its entries would offer the user a
      // suggestion that can only fail once they tap it.
      if (file.value.transformedKeyCredentials == null) {
        _logger.fine(
          'Not publishing identities for ${file.key}: no transformed key.',
        );
        continue;
      }
      for (final entry in file.value.body.rootGroup.getAllEntries()) {
        // Deleted entries stay in the file until the bin is emptied. Offering
        // them would resurrect passwords the user believes they threw away.
        if (entry.isInRecycleBin()) {
          continue;
        }
        final user = entry.getString(KdbxKeyCommon.USER_NAME)?.getText() ?? '';
        for (final host in _hostsOf(entry)) {
          identities.add({
            'serviceIdentifier': host, // NON-NLS
            'user': user, // NON-NLS
            'recordIdentifier': recordIdentifier(
              file.key,
              entry.uuid.uuid,
            ), // NON-NLS
          });
        }
      }
    }
    try {
      await _channel.invokeMethod<bool>('replaceIdentities', {
        'identities': identities,
      });
      _logger.fine('published ${identities.length} autofill identities.');
    } on PlatformException catch (e, stackTrace) {
      // Never fatal: failing to advertise a credential costs a suggestion, not
      // the user's data, and the surrounding operation is opening or saving a
      // database.
      _logger.warning('Unable to publish autofill identities.', e, stackTrace);
    }
  }

  /// Whether the user has switched AuthPass on as a credential provider.
  ///
  /// Null when the question does not apply — not iOS, or the platform side
  /// could not answer. Callers use that to say nothing rather than to guess,
  /// because "we could not ask" and "it is off" want different behaviour.
  Future<bool?> isEnabled() async {
    if (!_isAvailable) {
      return null;
    }
    try {
      final state = await _channel.invokeMapMethod<String, Object?>('state');
      return state?['enabled'] as bool?; // NON-NLS
    } on PlatformException catch (e, stackTrace) {
      _logger.warning('Unable to read the autofill state.', e, stackTrace);
      return null;
    }
  }

  /// Asks iOS to turn AuthPass on, and reports whether it now is.
  ///
  /// iOS 18 asks in place. Earlier it can only open Settings, and then this
  /// answers false whatever the user does there — ask [isEnabled] again once
  /// the app is resumed rather than trusting this.
  Future<bool> requestEnable() async {
    if (!_isAvailable) {
      return false;
    }
    try {
      return await _channel.invokeMethod<bool>('requestEnable') ?? false;
    } on PlatformException catch (e, stackTrace) {
      _logger.warning('Unable to request autofill be enabled.', e, stackTrace);
      return false;
    }
  }

  Future<void> removeAll() async {
    if (!_isAvailable) {
      return;
    }
    try {
      await _channel.invokeMethod<bool>('removeAll');
    } on PlatformException catch (e, stackTrace) {
      _logger.warning('Unable to clear autofill identities.', e, stackTrace);
    }
  }

  /// Every host this entry claims, deduplicated.
  ///
  /// iOS matches a service identifier against the page's domain itself, so it
  /// wants hosts rather than full urls — and it does its own registrable-domain
  /// widening, which is why `KP2A_URL` extras are published individually rather
  /// than collapsed.
  static Iterable<String> _hostsOf(KdbxEntry entry) {
    final hosts = <String>{};
    for (final url in entry.autofillUrls) {
      final host = CredentialMatcher.hostOf(url);
      if (host != null) {
        hosts.add(host);
      }
    }
    return hosts;
  }
}
