import 'package:authpass/utils/credential_matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kdbx/kdbx.dart';

void main() {
  final matcher = CredentialMatcher();

  KdbxEntry entryWith(Map<String, String> fields) {
    final file = KdbxFormat().create(
      Credentials.composite(ProtectedValue.fromString('asdf'), null),
      'test',
    );
    final entry = KdbxEntry.create(file, file.body.rootGroup);
    for (final field in fields.entries) {
      entry.setString(KdbxKey(field.key), PlainValue(field.value));
    }
    return entry;
  }

  CredentialMatchQuality? matchWeb(String requestUrl, String? entryUrl) =>
      matcher.match(CredentialRequest.web(requestUrl), entryUrl);

  CredentialMatchQuality? matchApp(String package, String? entryUrl) =>
      matcher.match(CredentialRequest.application(package), entryUrl);

  group('hostOf', () {
    test('extracts the host from a full url', () {
      expect(
        CredentialMatcher.hostOf('https://accounts.google.com/signin?a=b'),
        'accounts.google.com',
      );
    });

    test('accepts a bare host', () {
      expect(CredentialMatcher.hostOf('example.com'), 'example.com');
    });

    test('accepts a host with a path but no scheme', () {
      expect(CredentialMatcher.hostOf('example.com/login'), 'example.com');
    });

    test('drops a leading www', () {
      expect(
        CredentialMatcher.hostOf('https://www.example.com'),
        'example.com',
      );
      expect(CredentialMatcher.hostOf('www.example.com'), 'example.com');
    });

    test('keeps other subdomains', () {
      expect(CredentialMatcher.hostOf('wwwx.example.com'), 'wwwx.example.com');
      expect(
        CredentialMatcher.hostOf('www.mail.example.com'),
        'mail.example.com',
      );
    });

    test('lower cases', () {
      expect(CredentialMatcher.hostOf('HTTPS://Example.COM'), 'example.com');
    });

    test('ignores the port', () {
      expect(
        CredentialMatcher.hostOf('https://example.com:8443'),
        'example.com',
      );
    });

    test('returns null for values which are not hosts', () {
      expect(CredentialMatcher.hostOf(null), isNull);
      expect(CredentialMatcher.hostOf(''), isNull);
      expect(CredentialMatcher.hostOf('   '), isNull);
      expect(CredentialMatcher.hostOf('some note about the account'), isNull);
    });
  });

  group('registrableDomain', () {
    test('handles a single label suffix', () {
      expect(
        matcher.registrableDomain('https://images.google.com'),
        'google.com',
      );
    });

    test('handles a multi label suffix', () {
      expect(
        matcher.registrableDomain('https://www.bbc.co.uk'),
        'bbc.co.uk',
      );
      expect(
        matcher.registrableDomain('https://images.google.co.uk'),
        'google.co.uk',
      );
    });

    test('honours the private section of the list', () {
      // github.io is a public suffix, so each pages site is its own domain.
      expect(
        matcher.registrableDomain('https://alice.github.io'),
        'alice.github.io',
      );
      expect(
        matcher.registrableDomain('https://bob.github.io'),
        'bob.github.io',
      );
    });

    test('is null when there is nothing registrable', () {
      expect(matcher.registrableDomain('https://192.168.1.1'), isNull);
      expect(matcher.registrableDomain('https://localhost'), isNull);
      expect(matcher.registrableDomain(''), isNull);
    });
  });

  group('web matching', () {
    test('matches the exact host', () {
      expect(
        matchWeb('https://example.com/login', 'https://example.com'),
        CredentialMatchQuality.host,
      );
    });

    test('matches across subdomains of one registrable domain', () {
      expect(
        matchWeb('https://accounts.google.com', 'https://mail.google.com'),
        CredentialMatchQuality.registrableDomain,
      );
    });

    test('prefers the exact host over the registrable domain', () {
      expect(
        matchWeb('https://mail.google.com', 'https://mail.google.com'),
        CredentialMatchQuality.host,
      );
      expect(
        matchWeb('https://mail.google.com', 'https://google.com'),
        CredentialMatchQuality.registrableDomain,
      );
    });

    test('treats www as the bare domain', () {
      expect(
        matchWeb('https://example.com', 'https://www.example.com'),
        CredentialMatchQuality.host,
      );
    });

    test('rejects a domain which merely contains the request', () {
      // the substring search this replaces offered this entry.
      expect(
        matchWeb('https://google.com', 'https://google.com.evil.example'),
        isNull,
      );
      expect(matchWeb('https://google.com', 'https://notgoogle.com'), isNull);
      expect(matchWeb('https://google.com', 'https://google.company'), isNull);
    });

    test('rejects a request which merely contains the entry', () {
      expect(
        matchWeb('https://evil-example.com', 'https://example.com'),
        isNull,
      );
    });

    test('does not widen past a public suffix', () {
      expect(
        matchWeb('https://alice.github.io', 'https://bob.github.io'),
        isNull,
      );
      expect(matchWeb('https://bbc.co.uk', 'https://itv.co.uk'), isNull);
    });

    test('matches ip addresses exactly and not by domain', () {
      expect(
        matchWeb('https://192.168.1.1', 'https://192.168.1.1'),
        CredentialMatchQuality.host,
      );
      expect(matchWeb('https://192.168.1.1', 'https://192.168.1.2'), isNull);
    });

    test('matches localhost exactly', () {
      expect(
        matchWeb('http://localhost:8080', 'http://localhost'),
        CredentialMatchQuality.host,
      );
    });

    test('ignores entries without a usable url', () {
      expect(matchWeb('https://example.com', null), isNull);
      expect(matchWeb('https://example.com', ''), isNull);
      expect(matchWeb('https://example.com', 'my bank'), isNull);
    });

    test('ignores requests without a usable url', () {
      expect(matchWeb('', 'https://example.com'), isNull);
    });
  });

  group('application matching', () {
    test('matches a package recorded with the androidapp scheme', () {
      expect(
        matchApp('com.example.app', 'androidapp://com.example.app'),
        CredentialMatchQuality.application,
      );
    });

    test('is case insensitive', () {
      expect(
        matchApp('com.Example.App', 'androidapp://com.example.APP'),
        CredentialMatchQuality.application,
      );
    });

    test('rejects a different package', () {
      expect(matchApp('com.example.app', 'androidapp://com.other.app'), isNull);
    });

    test('does not match a package against a web entry', () {
      expect(matchApp('com.example.app', 'https://example.com'), isNull);
    });

    test('does not match a web request against an app entry', () {
      expect(
        matchWeb('https://example.com', 'androidapp://com.example.app'),
        isNull,
      );
    });

    test('ignores an empty package', () {
      expect(matchApp('', 'androidapp://com.example.app'), isNull);
    });
  });

  group('ranking', () {
    test('orders host above registrable domain above application', () {
      final qualities = [
        CredentialMatchQuality.application,
        CredentialMatchQuality.registrableDomain,
        CredentialMatchQuality.host,
      ]..sort((a, b) => a.index.compareTo(b.index));

      expect(qualities, [
        CredentialMatchQuality.host,
        CredentialMatchQuality.registrableDomain,
        CredentialMatchQuality.application,
      ]);
    });
  });

  group('matchBest', () {
    // what a browser fill request actually looks like: the page domain plus
    // the browser's own package name.
    final browser = [
      CredentialRequest.web('https://accounts.google.com'),
      CredentialRequest.application('com.android.chrome'),
    ];

    test('takes the strongest quality across requests and urls', () {
      expect(
        matcher.matchBest(browser, [
          'https://google.com',
          'https://accounts.google.com',
        ]),
        CredentialMatchQuality.host,
      );
    });

    test('order of the urls does not change the result', () {
      expect(
        matcher.matchBest(browser, [
          'https://accounts.google.com',
          'https://google.com',
        ]),
        CredentialMatchQuality.host,
      );
    });

    test('falls back to the weaker match when there is no exact host', () {
      expect(
        matcher.matchBest(browser, ['https://mail.google.com']),
        CredentialMatchQuality.registrableDomain,
      );
    });

    test('does not offer the browser its own credentials by accident', () {
      // an entry for chrome itself must not match because chrome is asking.
      expect(
        matcher.matchBest(
          [CredentialRequest.web('https://example.com')],
          ['androidapp://com.android.chrome'],
        ),
        isNull,
      );
    });

    test('matches the requesting native app', () {
      expect(
        matcher.matchBest(
          [CredentialRequest.application('com.example.app')],
          ['androidapp://com.example.app'],
        ),
        CredentialMatchQuality.application,
      );
    });

    test('is null when nothing matches', () {
      expect(matcher.matchBest(browser, ['https://example.com', null]), isNull);
    });

    test('is null without requests or urls', () {
      expect(matcher.matchBest([], ['https://google.com']), isNull);
      expect(matcher.matchBest(browser, []), isNull);
    });
  });

  group('rank', () {
    List<String> rank(List<CredentialRequest> requests, List<String> urls) =>
        matcher.rank(requests, urls, (url) => [url]);

    final request = [CredentialRequest.web('https://accounts.google.com')];

    test('drops everything which does not match', () {
      expect(
        rank(request, [
          'https://example.com',
          'https://accounts.google.com',
          'https://google.com.evil.example',
        ]),
        ['https://accounts.google.com'],
      );
    });

    test('puts the exact host ahead of the registrable domain', () {
      expect(
        rank(request, [
          'https://mail.google.com',
          'https://accounts.google.com',
          'https://google.com',
        ]),
        [
          'https://accounts.google.com',
          'https://mail.google.com',
          'https://google.com',
        ],
      );
    });

    test('keeps the incoming order within one quality band', () {
      expect(
        rank(request, ['https://z.google.com', 'https://a.google.com']),
        ['https://z.google.com', 'https://a.google.com'],
      );
    });

    test('is empty when nothing matches', () {
      expect(rank(request, ['https://example.com']), isEmpty);
    });

    test('handles candidates carrying several urls', () {
      final candidates = [
        ['https://example.com', 'https://accounts.google.com'],
        ['https://example.org'],
      ];
      expect(
        matcher.rank(request, candidates, (urls) => urls),
        [candidates.first],
      );
    });
  });

  group('autofillUrls', () {
    test('starts with the url field', () {
      expect(
        entryWith({'URL': 'https://example.com'}).autofillUrls,
        ['https://example.com'],
      );
    });

    test('picks up every shape of the KP2A_URL convention', () {
      // KP2A_URL, KP2A_URL_1 and KP2A_URL2 are all in the wild.
      final entry = entryWith({
        'URL': 'https://mail.live.com',
        'KP2A_URL': 'https://login.live.com',
        'KP2A_URL_1': 'https://login.microsoftonline.com',
        'KP2A_URL2': 'https://account.microsoft.com',
      });
      expect(
        entry.autofillUrls,
        containsAll(<String>[
          'https://mail.live.com',
          'https://login.live.com',
          'https://login.microsoftonline.com',
          'https://account.microsoft.com',
        ]),
      );
      expect(entry.autofillUrls, hasLength(4));
    });

    test('is case insensitive about the key, like kdbx is', () {
      expect(
        entryWith({'kp2a_url_1': 'https://login.example.com'}).autofillUrls,
        ['https://login.example.com'],
      );
    });

    test('ignores unrelated custom fields', () {
      final entry = entryWith({
        'URL': 'https://example.com',
        'Notes': 'https://not-a-url-field.example.com',
        'KPEX_PASSKEY_RELYING_PARTY': 'example.org',
      });
      expect(entry.autofillUrls, ['https://example.com']);
    });

    test('skips empty values', () {
      final entry = entryWith({
        'URL': '',
        'KP2A_URL_1': '   ',
        'KP2A_URL_2': 'https://example.com',
      });
      expect(entry.autofillUrls, ['https://example.com']);
    });

    test('is empty for an entry with no urls', () {
      expect(entryWith({'UserName': 'alice'}).autofillUrls, isEmpty);
    });

    test('an additional url is enough to match', () {
      final entry = entryWith({
        'URL': 'https://mail.live.com',
        'KP2A_URL_1': 'https://login.microsoftonline.com',
      });
      expect(
        matcher.matchBest(
          [CredentialRequest.web('https://login.microsoftonline.com/oauth')],
          entry.autofillUrls,
        ),
        CredentialMatchQuality.host,
      );
    });

    test('additional urls do not widen matching beyond their own domain', () {
      final entry = entryWith({
        'URL': 'https://example.com',
        'KP2A_URL_1': 'https://login.example.org',
      });
      expect(
        matcher.matchBest(
          [CredentialRequest.web('https://example.net')],
          entry.autofillUrls,
        ),
        isNull,
      );
    });
  });

  group('with a custom suffix list', () {
    final custom = CredentialMatcher.withSuffixList('''
com
// ===BEGIN PRIVATE DOMAINS===
hosted.com
// ===END PRIVATE DOMAINS===
''');

    test('uses the supplied rules', () {
      expect(
        custom.registrableDomain('https://a.b.example.com'),
        'example.com',
      );
    });

    test('applies private rules too', () {
      expect(
        custom.registrableDomain('https://alice.hosted.com'),
        'alice.hosted.com',
      );
      expect(
        custom.match(
          CredentialRequest.web('https://alice.hosted.com'),
          'https://bob.hosted.com',
        ),
        isNull,
      );
    });

    test('has no opinion about suffixes it was not given', () {
      expect(custom.registrableDomain('https://example.co.uk'), isNull);
    });
  });
}
