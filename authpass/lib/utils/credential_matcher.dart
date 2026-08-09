/// Decides which stored entries may be offered for a fill request, and how
/// well each one fits.
///
/// The rule everywhere is the **registrable domain** (eTLD+1): the public
/// suffix plus one label — `google.co.uk` for `images.google.co.uk`. This
/// cannot be derived by counting dots, hence the vendored public suffix list
/// (see `_tools/update_public_suffix_list.dart`).
///
/// Replaces the substring search the Android autofill path used, which both
/// over-matched (`google.com` matched an entry stored as
/// `google.com.phishing.example`) and under-matched
/// (`login.microsoftonline.com` found nothing for `microsoft.com`).
///
/// Deliberately free of Flutter and `dart:io` so the iOS AutoFill extension's
/// headless module can use the same code. Intended to move into its own
/// package once that module exists.
library;

import 'package:kdbx/kdbx.dart';
import 'package:public_suffix/public_suffix.dart';

import 'public_suffix_list.g.dart';

/// How closely an entry matched the fill request.
///
/// Ordered strongest first, so `List.sort` on [index] ranks sensibly.
enum CredentialMatchQuality {
  /// The entry is for the exact host that was requested.
  host,

  /// The entry is for a different host under the same registrable domain —
  /// an entry stored as `mail.google.com` offered for `accounts.google.com`.
  registrableDomain,

  /// The entry names the native application that requested the fill.
  application,
}

/// What the platform told us about the thing asking for a credential.
class CredentialRequest {
  CredentialRequest.web(String url)
    : webHost = CredentialMatcher.hostOf(url),
      packageName = null;

  CredentialRequest.application(String packageName)
    : webHost = null,
      packageName = packageName.trim().toLowerCase().nullIfEmpty;

  /// Lower-cased host of the requesting page, without `www.`, or null when the
  /// request did not come from a browser (or the url made no sense).
  final String? webHost;

  /// Package name of the requesting native app, or null for web requests.
  final String? packageName;

  bool get isEmpty => webHost == null && packageName == null;
}

/// Matches stored entry urls against a [CredentialRequest].
///
/// Parsing the suffix list costs a few milliseconds, so hold on to an
/// instance rather than creating one per lookup.
class CredentialMatcher {
  /// Uses the public suffix list vendored into the app.
  factory CredentialMatcher() =>
      CredentialMatcher._(SuffixRules.fromString(publicSuffixListData));

  CredentialMatcher._(this._suffixRules);

  /// Mostly for tests which want a small, predictable rule set.
  factory CredentialMatcher.withSuffixList(String suffixList) =>
      CredentialMatcher._(SuffixRules.fromString(suffixList));

  /// Shared instance — parsing ten thousand suffix rules is not free, and the
  /// result never changes.
  static final CredentialMatcher instance = CredentialMatcher();

  final SuffixRules _suffixRules;

  /// Prefix Keepass2Android uses in the url field to record a native app.
  static const _androidAppScheme = 'androidapp://'; // NON-NLS

  /// Percent escapes and whitespace never appear in a real hostname.
  static final _notAHostname = RegExp(r'[%\s]'); // NON-NLS

  /// Lower-cased host of [url], with a leading `www.` removed.
  ///
  /// Accepts what actually turns up in kdbx url fields: full urls, bare hosts,
  /// hosts with a port, and scheme-less values. Returns null for anything that
  /// is not a host — empty strings, `otpauth://` secrets, notes.
  ///
  /// A single word that happens to look like a hostname (`mybank`) is returned
  /// as one. It has no registrable domain, so it can only ever match a request
  /// for that exact host, which no browser will make.
  static String? hostOf(String? url) {
    if (url == null) {
      return null;
    }
    var value = url.trim();
    if (value.isEmpty) {
      return null;
    }
    // a bare host or `host/path` has no scheme; give it one so Uri finds an
    // authority component.
    if (!value.contains('//')) {
      value = 'https://$value'; // NON-NLS
    }
    final Uri uri;
    try {
      uri = Uri.parse(value);
    } on FormatException {
      return null;
    }
    final host = uri.host.toLowerCase();
    if (host.isEmpty || _notAHostname.hasMatch(host)) {
      // Uri percent encodes whatever it could not make sense of, which is how
      // free text in the url field shows up here.
      return null;
    }
    return host.startsWith('www.') ? host.substring(4) : host; // NON-NLS
  }

  /// The registrable domain (eTLD+1) of [url], or null when there is none.
  ///
  /// Null for ip addresses, `localhost`, and hosts which are nothing but a
  /// public suffix (`co.uk` on its own). Those can still match exactly — see
  /// [match] — they just have no domain to widen to.
  String? registrableDomain(String? url) {
    final host = hostOf(url);
    if (host == null) {
      return null;
    }
    final suffix = PublicSuffix.fromString(
      'https://$host', // NON-NLS
      suffixRules: _suffixRules,
      leniency: Leniency.allowAll,
    );
    if (suffix == null || !suffix.hasKnownSuffix()) {
      return null;
    }
    // `domain` rather than `icannDomain`: the private section of the list is
    // what keeps alice.github.io and bob.github.io apart.
    return suffix.domain;
  }

  /// Package name recorded by [entryUrl], if it names a native app.
  static String? applicationOf(String? entryUrl) {
    final value = entryUrl?.trim().toLowerCase();
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.startsWith(_androidAppScheme)) {
      return value.substring(_androidAppScheme.length).nullIfEmpty;
    }
    return null;
  }

  /// How well [entryUrl] answers [request], or null if it does not.
  CredentialMatchQuality? match(CredentialRequest request, String? entryUrl) {
    if (request.isEmpty) {
      return null;
    }

    final application = applicationOf(entryUrl);
    if (application != null) {
      return application == request.packageName
          ? CredentialMatchQuality.application
          : null;
    }

    final requestHost = request.webHost;
    if (requestHost == null) {
      return null;
    }
    final entryHost = hostOf(entryUrl);
    if (entryHost == null) {
      return null;
    }
    if (entryHost == requestHost) {
      return CredentialMatchQuality.host;
    }

    final requestDomain = registrableDomain(requestHost);
    if (requestDomain == null) {
      // an ip address or an unknown suffix only ever matches itself.
      return null;
    }
    return requestDomain == registrableDomain(entryHost)
        ? CredentialMatchQuality.registrableDomain
        : null;
  }

  /// Best quality across every request and every url, or null for no match.
  ///
  /// A fill request usually names more than one thing — a browser reports the
  /// page domain, sometimes several, alongside the browser's own package — and
  /// an entry may carry more than one url. Any pairing counts, and the
  /// strongest one wins.
  CredentialMatchQuality? matchBest(
    Iterable<CredentialRequest> requests,
    Iterable<String?> entryUrls,
  ) {
    CredentialMatchQuality? best;
    for (final request in requests) {
      for (final url in entryUrls) {
        final quality = match(request, url);
        if (quality == null) {
          continue;
        }
        if (quality == CredentialMatchQuality.host) {
          // nothing beats it, stop looking.
          return quality;
        }
        if (best == null || quality.index < best.index) {
          best = quality;
        }
      }
    }
    return best;
  }

  /// The candidates which answer [requests], strongest match first.
  ///
  /// Ties keep the order [candidates] came in, so an existing sort (by title,
  /// say) still shows through within a quality band.
  List<T> rank<T>(
    Iterable<CredentialRequest> requests,
    Iterable<T> candidates,
    Iterable<String?> Function(T candidate) urlsOf,
  ) {
    final matched = <_Ranked<T>>[];
    var position = 0;
    for (final candidate in candidates) {
      final quality = matchBest(requests, urlsOf(candidate));
      if (quality != null) {
        matched.add(_Ranked(candidate, quality, position));
      }
      position++;
    }
    matched.sort((a, b) {
      final byQuality = a.quality.index.compareTo(b.quality.index);
      return byQuality != 0 ? byQuality : a.position.compareTo(b.position);
    });
    return matched.map((e) => e.candidate).toList(growable: false);
  }
}

class _Ranked<T> {
  _Ranked(this.candidate, this.quality, this.position);

  final T candidate;
  final CredentialMatchQuality quality;
  final int position;
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}

/// Prefix Keepass2Android uses for extra urls on an entry, so one login can
/// cover several sign-in domains — a Microsoft account reached via
/// `login.live.com`, `login.microsoftonline.com` and `account.microsoft.com`,
/// say.
///
/// KeePassXC, KeeWeb and KeePassium read the same fields. There is no spec and
/// no consistent shape: `KP2A_URL`, `KP2A_URL_1` and `KP2A_URL2` all occur, so
/// match on the prefix instead of a fixed pattern. Comparison is
/// case-insensitive because kdbx custom string keys are.
const _additionalUrlPrefix = 'KP2A_URL'; // NON-NLS

extension CredentialMatcherEntry on KdbxEntry {
  /// Every url this entry claims — the url field plus any `KP2A_URL*` extras.
  ///
  /// Values are returned as stored; [CredentialMatcher] does the normalising.
  Iterable<String> get autofillUrls sync* {
    final url = getString(KdbxKeyCommon.URL)?.getText();
    if (url != null && url.trim().isNotEmpty) {
      yield url;
    }
    for (final entry in stringEntries) {
      if (!entry.key.key.toUpperCase().startsWith(_additionalUrlPrefix)) {
        continue;
      }
      final value = entry.value?.getText();
      if (value != null && value.trim().isNotEmpty) {
        yield value;
      }
    }
  }
}
