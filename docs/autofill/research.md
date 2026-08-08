# OS-level AutoFill for AuthPass — Research Notes

Research date: 2026-08-08. Covers macOS and iOS credential-provider autofill and
passkey provider support (iOS / macOS / Android). Companion document:
[plan.md](plan.md).

## Summary

- Both Apple platforms support third-party password managers via
  **Credential Provider app extensions** (AuthenticationServices,
  `ASCredentialProviderViewController`). Passwords since iOS 12 / macOS 11,
  passkeys since iOS 17 / macOS 14, TOTP since iOS 18 / macOS 15.
- **iOS**: one extension covers *every* browser (all WebKit) plus native apps
  via the QuickType bar. Constraints: ~100–120 MB extension memory cap, the
  main app cannot be assumed running (no IPC), and a strict few-second window
  for the no-UI fill path.
- **macOS**: system autofill reaches **Safari and native apps only** —
  Chrome/Firefox always need per-browser WebExtensions. No memory cap, and the
  main app is usually running, so a thin extension + IPC design works.
- **Flutter**: a FlutterEngine **cannot** boot inside a macOS `.appex`
  ([flutter#124755](https://github.com/flutter/flutter/issues/124755)). On iOS
  it can (Flutter ≥ 3.16, extension-safe framework), but no shipping password
  manager does it; the ecosystem standard is a thin native Swift extension.
- **Passkeys**: stored in kdbx via KeePassXC's de-facto `KPEX_PASSKEY_*`
  attribute convention (Strongbox, KeePassium, KeePassDX interoperate). The
  WebAuthn authenticator core is small (~1.5–2 kLOC in real apps) and feasible
  in **pure Dart** (`package:cbor` + `pointycastle`), shareable across all
  platforms.

## macOS platform facts

- API available macOS 11+ (`ASCredentialProviderViewController` subclasses
  `NSViewController`). Passkey provision macOS 14+, OTP / text-to-insert
  macOS 15+ (`ASCredentialProviderExtensionCapabilities` Info.plist keys:
  `ProvidesPasswords`, `ProvidesPasskeys`, `ProvidesOneTimeCodes`,
  `ProvidesTextToInsert`, `ShowsConfigurationUI`,
  `SupportsConditionalPasskeyRegistration`).
- Entitlement `com.apple.developer.authentication-services.autofill-credential-provider`
  on **both** app and extension. Works for Mac App Store **and** Developer ID
  distribution (Apple DTS confirmed; an Xcode 13 automatic-signing bug required
  manual profiles — [forums 690381](https://developer.apple.com/forums/thread/690381)).
- User enablement: System Settings → General → AutoFill & Passwords
  ("AutoFill from"). Helpers: `ASSettingsHelper.openCredentialProviderAppSettings()`
  (14+), `requestToTurnOnCredentialProviderExtension()` (15+).
- Coverage: Safari + AppKit apps with `NSTextContentType`-tagged fields.
  Chrome/Edge/Brave/Arc/Firefox do **not** consume the system framework —
  every desktop password manager also ships browser extensions.
- No extension memory cap on macOS (jetsam limit −1).
- macOS 26: FIDO Credential Exchange (CXP/CXF) import/export, WebAuthn Signal
  API (`ASCredentialUpdater`).

## iOS platform facts

- API iOS 12+; passkeys iOS 17+; OTP + text-to-insert + automatic passkey
  upgrades iOS 18+ (`performWithoutUserInteractionIfPossible(passkeyRegistration:)`).
- Coverage: QuickType bar in **all** browsers (WebKit mandate; EU alt-engine
  browsers keep it via BrowserEngineKit) and native apps via `UITextContentType`.
- **Memory cap ~100–120 MB** for the extension process (vendor-measured;
  KeePassium hardcodes 120 MB and monitors `os_proc_available_memory()`).
  Argon2 at common KeePass defaults (64 MB+) crashes autofill extensions —
  KeePassium/Strongbox tell users to use 16–32 MB. Large decrypted XML DOMs
  (custom icons!) also OOM.
- **No IPC to the main app** (extensions are isolated; the app is usually not
  running). Sanctioned sharing: app-group container, shared `UserDefaults`,
  shared Keychain access group, Darwin notifications (payload-less).
- Timing: `provideCredentialWithoutUserInteraction` must answer, request UI,
  or cancel within a few seconds or the system cancels the fill.
- Enablement: Settings → General → AutoFill & Passwords (iOS 18 path); up to
  3 simultaneous providers. iOS 18 one-tap prompt:
  `ASSettingsHelper.requestToTurnOnCredentialProviderExtension`.
- `ASCredentialIdentityStore` holds **metadata only** (service id + username +
  recordIdentifier, never secrets), writable by the app (extension writes are
  unreliable — design for main-app writes), fails while device locked.
- Testing: credential-provider extensions effectively require a **physical
  device**; Flutter-in-extension debug mode on device OOMs (test release/profile).

## Flutter constraints

- macOS: engine cannot locate assets inside `.appex`, sandbox blocks loading
  the host bundle — [flutter#124755](https://github.com/flutter/flutter/issues/124755)
  (open). Extension must be native.
- iOS: supported since Flutter 3.16 via the extension-safe framework
  (`bin/cache/artifacts/engine/ios/extension_safe/Flutter.xcframework`);
  `FlutterSharedApplication.application` returns nil in extensions. Known
  issues: plugin pods don't apply to extension targets
  ([#142136](https://github.com/flutter/flutter/issues/142136)), headless
  engines create UI layers off-main-thread
  ([#165904](https://github.com/flutter/flutter/issues/165904)), extension
  missing from Settings ([#145589](https://github.com/flutter/flutter/issues/145589)),
  debug >120 MB ([#135243](https://github.com/flutter/flutter/issues/135243)).
- A Flutter **plugin cannot ship an appex** — extension targets must be added
  to the app's Xcode project by hand; a plugin can only wrap app-side APIs.

## Existing art

| App | Stack | iOS autofill | macOS autofill |
|---|---|---|---|
| Bitwarden | native Swift (2024 rewrite; Xamarin before) | thin native ext + `BitwardenShared` framework, app group | Swift appex + Unix-socket IPC to Electron app (Rust/UniFFI) |
| 1Password 8 | Electron/Rust | native ext | Accessibility "Universal Autofill"; native credential provider since v8.12 (2026) |
| Strongbox | native Swift/ObjC | ext self-unlocks; Secure-Enclave "Wormhole" to running app | same, since macOS 11 |
| KeePassium | native Swift (Catalyst on Mac) | ext re-decrypts kdbx itself; "remember final key" skips Argon2 | same |
| KeePassXC | Qt/C++ | n/a | none — browser extensions + auto-type only |
| Enpass | Qt | ext | browser extensions only |

Pattern: **nobody runs a cross-platform framework inside the appex.** Native
apps decrypt in-extension; Electron apps use IPC (macOS only).

## AuthPass current state (relevant findings)

- **Android autofill** (`deps/autofill_service`): thin MethodChannel plugin;
  Dart flow = engine boots with `initialRoute: /autofill` →
  `password_list.dart` detects autofill mode → search-filtered picker →
  `resultWithDataset`. Reusable UX + channel API. No real domain matching —
  origin becomes a substring search (flagged as AUDIT 2026-07-28 C1).
- **Quick unlock**: `QuickUnlockStorage` caches the kdbx **composite key hash**
  via `biometric_storage`. macOS keychain access group is declared;
  iOS entitlements have **no** keychain-access-groups and **no app group**.
  `biometric_storage` (own plugin) has no `kSecAttrAccessGroup` support —
  upstream patch required.
- **File access**: iOS/macOS use security-scoped bookmarks
  (`file_picker_writable` / `macos_secure_bookmarks`) stored in `AppData` —
  not reachable from an extension; group-container mirroring or re-bookmarking
  needed.
- **kdbx.dart key chain** (KDBX4): `credentials.getHash()` → Argon2 with
  header KDF salt → transformed key → +master seed → cipher/HMAC keys.
  `header.generateSalts()` rotates salts **on every save**, so a cached
  transformed key is invalidated by each save (good: bounded lifetime; catch:
  saving in the extension needs new-salt key derivation — see plan.md).
- **Prior iOS attempts**: branch `ios-autofill-provider` (2024) boots the full
  Flutter app in an `AuthPassAutofill` extension via the
  `codeux.design/autofill_service` channel — proves rendering works, but the
  full-app approach forces forking every `UIApplication`-touching plugin, has
  no pods/build-phase wiring, and was reviewed as **not worth resurrecting**
  (keep only the ideas: channel shim, `resultWithDataset` →
  `ASPasswordCredential`, app group `group.design.codeux.authpass`).
  `origin/ios-autofill-playground` (2020) is older/rougher.
- **Signing/CI**: fastlane match (private GitLab cert repo, `readonly: true`)
  with one bundle id per platform; new extension bundle ids + app group +
  autofill capability need portal + match-repo write access. macOS has no CI;
  iOS has `ios.yaml` → TestFlight.
- macOS deployment target 10.15 (needs ≥ 11, realistically 14); iOS 13.0
  (extension should target 17+).

## Vault access designs for the extension ("how does it get the secret")

1. **Composite key hash** (what quick-unlock stores today) — forces Argon2
   inside the extension (memory risk) and is the most powerful secret
   (file-independent, never expires). Avoid for the extension.
2. **Post-Argon2 transformed key** (KeePassium's "remember final key") —
   extension skips Argon2 entirely; bound to the file's current KDF salt, so
   every save rotates it. Needs a small kdbx.dart API (export/inject the
   transformed key; today it is internal to `_computeKeysV4`). **Recommended.**
3. **Sync all credentials to shared keychain** (Apple's WWDC18 demo pattern) —
   simplest, no Dart in extension, but duplicates every secret outside the
   vault and cannot support passkey registration (needs DB writes). Fallback
   only.

Keychain items: shared access group, `kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly`
+ `.biometryCurrentSet` → Face ID/Touch ID per read. kdbx file: mirror copy in
the app-group container refreshed on open/save (bookmark sharing as a later
refinement — KeePassium does resolve shared bookmarks in the extension).

## Passkeys

- **Storage**: `KPEX_PASSKEY_CREDENTIAL_ID` (protected, base64url),
  `KPEX_PASSKEY_PRIVATE_KEY_PEM` (protected, **PKCS#8** PEM),
  `KPEX_PASSKEY_USER_HANDLE` (protected), `KPEX_PASSKEY_RELYING_PARTY`,
  `KPEX_PASSKEY_USERNAME`, `KPEX_PASSKEY_FLAG_BE` / `_BS` (`"1"`/`"0"`,
  default set). Legacy aliases: `KPEX_PASSKEY_GENERATED_USER_ID`,
  `KPXC_PASSKEY_USERNAME`. KeePassDX adds `KPEX_PASSKEY_PRF` and
  `AndroidApp`(+` Signature`). No formal spec; KeePassXC's source is the
  reference. kdbx.dart needs only a convention layer
  (`KdbxEntry.setString` already handles protected custom strings).
- **Authenticator core** (provider does all crypto; system only routes +
  hashes clientData): ES256/P-256 only in practice, credential id = 32 random
  bytes, `authData` built by hand, CBOR `attestationObject` with
  `fmt:"none"`, signature = DER-ECDSA over `authData ‖ clientDataHash`,
  **signCount always 0**, BE/BS = 1, UV flag = database unlocked. Real
  implementations ~1.5–2 kLOC; pure Dart feasible (`cbor`, `pointycastle`
  incl. RFC 6979; verify PKCS#8-vs-SEC1 PEM interop against KeePassXC files).
- **Apple**: delta over a working extension is small (KeePassium's core is
  420 LOC Swift; Strongbox shipped both platforms in ~6–7 weeks). Registration
  must **save the kdbx from inside the extension** (or route through the main
  app). AAGUID gets zeroed by the system; only `fmt:"none"` attestation; no
  Simulator support; expect a long relying-party-compat tail (KeePassium: ~1
  year of fixes). Conditional registration + largeBlob: skipped by all
  KeePass-family apps in v1.
- **Android**: `CredentialProviderService` (API 34+, androidx.credentials;
  no provider backport). Complements — does not replace — the AutofillService;
  register both. PendingIntent launches the full app for UI → **no extension
  sandbox, no memory cap**: architecturally the easiest AuthPass passkey
  platform, independent of the Apple extensions. Fiddly part: origin
  validation (privileged-browser allowlist JSON, assetlinks for native apps).
  Chrome (Android 14+) and Firefox 128+ route to third-party providers; some
  OEMs (Xiaomi) block them. KeePassDX is a GPL-3 reference with the same kdbx
  format.

## Key references

- Apple: [ASCredentialProviderViewController](https://developer.apple.com/documentation/authenticationservices/ascredentialproviderviewcontroller),
  [ASCredentialIdentityStore](https://developer.apple.com/documentation/authenticationservices/ascredentialidentitystore),
  [entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.authentication-services.autofill-credential-provider),
  [credential provider security](https://support.apple.com/guide/security/credential-provider-extensions-sec6319ac7b9/web),
  WWDC 2018-721, 2020-10115, 2024-10125, 2025-279.
- Flutter: [iOS app extensions](https://docs.flutter.dev/platform-integration/ios/app-extensions),
  issues [#124755](https://github.com/flutter/flutter/issues/124755),
  [#142136](https://github.com/flutter/flutter/issues/142136),
  [#165904](https://github.com/flutter/flutter/issues/165904),
  [#135243](https://github.com/flutter/flutter/issues/135243).
- KeePass ecosystem: [KeePassium](https://github.com/keepassium/KeePassium)
  (GPLv3 — `Passkey.swift`, `MemoryMonitor.swift`, `DatabaseSettings.swift`),
  [Strongbox](https://github.com/strongbox-password-safe/Strongbox),
  [KeePassXC passkeys](https://github.com/keepassxreboot/keepassxc/pull/8825)
  + [BE/BS flags PR](https://github.com/keepassxreboot/keepassxc/pull/13042),
  [KeePassDX passkeys](https://github.com/Kunzisoft/KeePassDX/wiki/Passkeys),
  [KeePassium autofill memory](https://support.keepassium.com/kb/autofill-memory/).
- Android: [credential provider guide](https://developer.android.com/identity/sign-in/credential-provider),
  [androidx.credentials releases](https://developer.android.com/jetpack/androidx/releases/credentials).
- Samples: [Dashlane apple-credential-provider-example](https://github.com/Dashlane/apple-credential-provider-example),
  [1Password passkey-rs](https://github.com/1Password/passkey-rs).
- AuthPass: issues [#31](https://github.com/authpass/authpass/issues/31) (iOS
  autofill), [#13](https://github.com/authpass/authpass/issues/13) (mac
  auto-type — Accessibility/CGEvent, sandbox-incompatible with MAS builds).
