import 'package:authpass/utils/credential_matcher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final matcher = CredentialMatcher();

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
