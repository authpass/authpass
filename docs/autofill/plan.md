# AutoFill Implementation Plan (iOS + macOS)

Status: proposal, 2026-08-08. Background and sources: [research.md](research.md).

## Goal

OS-level credential autofill for AuthPass: QuickType-bar password filling on
iOS (all browsers + native apps) and Safari/native-app filling on macOS,
via AuthenticationServices Credential Provider extensions. Passkey support is
explicitly **out of scope** for the MVP but shapes several design decisions
below so it can be added later without a redesign.

## Architecture

**Extension = native Swift shell + headless kdbx.dart.**

- A minimal, separate Flutter module (pubspec with only `kdbx`, `argon2_ffi`
  and dart:io — *not* the AuthPass app) runs headless inside the extension.
  Native Swift renders the picker UI and speaks the OS protocol; Dart answers
  "entries for domain X" / "decrypt entry Y" over a MethodChannel. This avoids
  the plugin-compatibility problem that killed the 2020/2024 full-app attempts
  (`ios-autofill-provider` branch — reviewed, not worth resurrecting).
- **Vault key**: cache the **post-Argon2 transformed key** per file
  (KeePassium's "remember final key") in a shared keychain access group,
  protected by `WhenPasscodeSetThisDeviceOnly` + `.biometryCurrentSet`.
  The extension never runs Argon2 → the ~120 MB iOS memory cap becomes a
  non-issue. The key is salt-bound; `generateSalts()` on save rotates it, and
  the app re-caches on every unlock/save.
- **Vault file**: mirror copy in the app-group container
  (`group.design.codeux.authpass`), refreshed by the main app on open/save,
  plus a small manifest (file uuid, name, mtime, salt fingerprint).
  Designed **read-write** from day one (passkey registration will need to save
  from the extension); v1 only reads. Shared-bookmark resolution is a later
  refinement.
- **Stale-key case** (file saved elsewhere, salt mismatch): show
  "Open AuthPass to refresh AutoFill" and cancel. No master-password entry in
  the extension in v1 (would pull Argon2 back in).
- **macOS**: same extension design, plus (optionally, later) IPC to the
  running app as a fast path. Starting with the identical self-unlock model
  keeps the two platforms on one code path.

### Design decisions locked in for passkey-readiness

1. Extension deployment target **iOS 17 / macOS 14**; use only the
   `ASCredentialRequest`-based API surface (passkeys become a `switch` on
   request type).
2. Declare `ASCredentialProviderExtensionCapabilities`
   (`ProvidesPasswords: true`) from day one.
3. Identity-store sync is type-agnostic (`[ASCredentialIdentity]`, record id =
   file uuid + entry uuid); main app writes the store, never the extension.
4. Biometric gate in the extension is a reusable UV/auth policy component
   (reuse duration à la KeePassium), not inlined in the fill path.
5. kdbx.dart must preserve unknown `KPEX_*` custom strings through
   edit/merge (users already share vaults with KeePassXC/KeePassium) —
   verified by tests.
6. One Dart eTLD+1 registrable-domain matcher, used by the extension *and* by
   Android autofill (fixes AUDIT 2026-07-28 C1).
7. The group-container file layer keeps a write-back path in its design even
   while v1 is read-only.
8. **Extension save path (decided 2026-08-08)**: extension saves reuse the KDF
   salt (master seed / IV / stream key still rotate, so ciphertext freshness
   is preserved) and write a `Meta/CustomData` flag
   (`AUTHPASS_KDF_SALT_REUSED` = salt fingerprint + timestamp) into the file.
   Any full AuthPass instance that later opens the file re-saves with fresh
   salts and clears the flag (fingerprint mismatch = someone else already
   rotated → clear lazily). Auto-rotation save is gated on a writable source
   with no pending sync conflict. macOS additionally prefers IPC-to-app for
   writes when the app is running. Rejected: caching the composite hash for
   extension saves (Argon2 memory + a master-password-equivalent secret) and
   staged writes (passkey lockout risk).

## Phases

### Phase 0 — Spike: headless module + memory (≈ 1 week)

Fresh from `main` (do not rebase the old branches):

- Xcode-wizard `AuthPassAutofill` extension target in `ios/Runner.xcodeproj`;
  entitlements (autofill capability + app group) on both targets; dev-signing
  only.
- Minimal Flutter module with `kdbx` + `argon2_ffi`; boot it headless behind a
  bare Swift `ASCredentialProviderViewController`; hand it a kdbx file +
  pre-derived key, get an entry back over the channel.
- Measure `os_proc_available_memory()` with a realistic vault, release mode,
  physical device.

**Exit criteria / go–no-go**: entry decrypted in-extension with comfortable
memory headroom, headless engine stable (watch flutter#165904). Fallback if it
fails: native Swift extension reusing KeePassiumLib (GPLv3-compatible), same
key/file sharing design — Phases 1, 3, 4 survive unchanged.

### Phase 1 — Shared foundations (≈ 2–3 weeks, parallelizable with Phase 0)

- kdbx.dart: export/inject the transformed key (`Credentials` variant carrying
  a pre-derived key; today internal to `_computeKeysV4`); save option that
  skips KDF-salt rotation + the `AUTHPASS_KDF_SALT_REUSED` custom-data flag
  handling (design decision 8); salt-fingerprint accessor; `KPEX_*`
  preservation tests.
- `biometric_storage`: `kSecAttrAccessGroup` support (upstream, own plugin);
  migration for existing quick-unlock items (biometry-bound items cannot be
  moved into a group after the fact — re-create on next unlock).
- Dart eTLD+1 matcher (public-suffix based), wired into Android autofill too.
- App-group mirror layer in the app: copy-on-open/save + manifest.
- Provisioning: register extension bundle ids
  (`design.codeux.authpass.ios[.debug].AuthPassAutofill`), app group and
  autofill capability in the portal; generate + push match profiles
  (needs write access to the private cert repo); `Appfile`/`Fastfile` updated
  for two identifiers.

### Phase 2 — iOS extension MVP (≈ 3–4 weeks)

- Swift: `prepareCredentialList` picker (native list fed by Dart lookups),
  `provideCredentialWithoutUserInteraction` fast path (keychain read →
  Face ID → decrypt → `ASPasswordCredential` within the time budget),
  `userInteractionRequired` fallback, stale-key and no-vault error screens,
  configuration UI (`prepareInterfaceForExtensionConfiguration`).
- Extension pods target (argon2_ffi against the extension-safe engine);
  Flutter build phases for the module; `release.sh`/CI wiring so the target
  builds in `ios.yaml`.
- Preferences screen: enable-autofill flow
  (`ASSettingsHelper.requestToTurnOnCredentialProviderExtension` on 18+,
  settings deep-link on 17), reusing the Android preferences pattern.

### Phase 3 — QuickType / identity sync (≈ 1.5–2 weeks)

- Sync identities (URL + username + record id) to
  `ASCredentialIdentityStore` on unlock/save/close; per-database opt-in
  (Strongbox/KeePassium precedent); incremental saves; cleanup on file close
  and opt-out.
- Match ranking: exact host > registrable domain (shared matcher).

### Phase 4 — Hardening + release (≈ 1–2 weeks)

- Memory guardrail (KeePassium-style monitor) + user-facing warning when a
  vault's Argon2/size makes autofill risky (even though the extension skips
  Argon2, huge DOMs still cost memory).
- TestFlight matrix (iOS 17/18/26; extension-absent pitfalls: deployment
  target, profile capability mismatches), webauthn-free real-site testing,
  analytics events, docs.

### Phase 5 — macOS (≈ 4–6 weeks, after iOS ships)

- Deployment target 10.15 → 14 (Podfile + pbxproj); macOS extension target in
  the SPM+CocoaPods hybrid project; AppKit (or SwiftUI, shared with iOS)
  picker UI; same headless module, key cache and group container.
- match profiles for the macOS extension id; verify MAS review passes.
- Optional fast path: local-socket/XPC to the running app (skip Face ID when
  the vault is open); "app not running" already handled by the shared
  self-unlock model.
- Out of scope here: Chrome/Firefox on macOS (needs a WebExtension + native
  messaging — separate project).

### Later — passkeys (separate plan when scheduled)

Order of attack per research: shared pure-Dart authenticator core →
**Android** `CredentialProviderService` (no dependency on the Apple
extensions, full-Flutter UI) → Apple passkey delta on the extensions built
above. The write-back path (Phase 1/2 design) and decisions 1–7 are the
prerequisites this plan already provides.

## Effort summary

| Phase | Estimate |
|---|---|
| 0 Spike | 1 week |
| 1 Foundations | 2–3 weeks |
| 2 iOS MVP | 3–4 weeks |
| 3 QuickType | 1.5–2 weeks |
| 4 Hardening | 1–2 weeks |
| **iOS total** | **~9–12 weeks** |
| 5 macOS | +4–6 weeks |

## Main risks

| Risk | Mitigation |
|---|---|
| Headless engine unstable in the appex (flutter#165904) | Phase 0 spike decides early; KeePassiumLib fallback keeps the rest of the plan intact |
| Memory blowup on large vaults (XML DOM) | transformed-key cache removes Argon2; memory monitor + user warning; test with big vaults in Phase 0 |
| Provisioning/match friction (readonly repo, new ids, app group) | do it in Phase 1, not last; it gates everything |
| biometric_storage migration breaks existing quick-unlock | re-create items lazily on next unlock; namespace new group items |
| Mirror-copy staleness with cloud-synced vaults | manifest mtime check + clear "open AuthPass" UX; bookmark sharing as follow-up |
| Save-path salt rotation vs cached key (needed for passkeys later) | decided — design decision 8: salt-reuse saves + in-file rotation flag; rotate on next full-app open |
