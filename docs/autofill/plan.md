# AutoFill Implementation Plan (iOS + macOS)

Status: proposal, 2026-08-08. Phase 0 done (go, see below).
Background and sources: [research.md](research.md).
Portal checklist: [provisioning.md](provisioning.md).

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
8. **Extension write path (decided 2026-08-08, revised same day)**: the
   extension is **strictly read-only on the main kdbx**. Credentials created
   or changed in the extension are staged in a per-vault **staging mini-kdbx**
   ("update kdbx") in the app-group container, encrypted with a random 256-bit
   key held in the shared keychain (backup-eligible
   `kSecAttrAccessibleWhenUnlocked`, *no* biometry ACL — reads are gated by
   in-code `LAContext` policy per operation, since ACL-bound items don't
   survive device migration and silent-save flows must write without UI).
   The mini-kdbx uses a deliberately cheap KDF (its secret is a random
   256-bit key, so KDF strength is irrelevant — no Argon2 in the extension).
   Staged entries are registered in the identity store so passkeys are
   immediately assertable; the extension's lookup treats the staging kdbx as
   simply one more open file. The main app merges it on next open (plus an
   opportunistic `BGAppRefreshTask`): new UUIDs import, matching UUIDs merge
   as edits with proper history via the existing kdbx merge — through a thin
   wrapper that skips/backdates meta so staging meta never clobbers the main
   file's. Then a normal save (salts rotate as usual) and the staging file is
   cleared. Timeliness: reminder in the extension UI while staging is pending
   (KeePassium 2.4 ships this pattern); optional AuthPass Cloud silent push as
   an accelerator later. macOS additionally prefers IPC-to-app for writes when
   the app is running. Rejected: in-extension saves of the main kdbx with
   KDF-salt reuse (machinery + format deviation for a marginal exposure),
   composite-hash caching for extension saves (Argon2 memory +
   master-password-equivalent secret), ad-hoc per-credential keychain records
   (a second serialization format; the mini-kdbx reuses the entry model and
   merge machinery), and relying on waking the main app (unsupported for this
   extension type; BGTask/push are best-effort only).

   Known system-routed write flows to plan for: passkey registration
   (iOS 17+), automatic passkey upgrades (iOS 18+, skip in v1), password
   save/update + strong-password generation (**iOS 26.2**:
   `ASSavePasswordRequest` / `ASGeneratePasswordsRequest`,
   `SupportsSavePasswordCredentials` — 1Password/Enpass/RoboForm already
   ship it; fast-follow after the MVP), and Signal-API maintenance reports
   (iOS 26: passkey rename/removal hints, unused-password reports —
   background, optional). TOTP setup never routes through the extension —
   registering the app as an `otpauth://` handler is a separate cheap win.

## Phases

### Phase 0 — Spike: headless module + memory — **DONE, go** (2026-08-09)

Measured on an iPhone XR, iOS 18.7.9, release engine in the appex, via
`autofill_module` + the `AuthPassAutofill` target. Two generated vaults, both
opened with an injected transformed key (no Argon2):

| step | 2000 entries / 0.9 MB | 5000 entries / 2.8 MB |
|---|---|---|
| baseline available | 114.8 MB | 114.8 MB |
| engine + channel | 7.0 MB | 7.5 MB |
| vault open | 47.7 MB | 77.6 MB |
| list *all* entries over the channel | 3.0 MB | 17.3 MB |
| lowest available reached | 57.1 MB | 12.4 MB |
| dart time to open | 326 ms | 865 ms |

**Verdict: go.** The headless engine boots and runs in the appex —
flutter#165904 did not bite on iOS 18 — and the engine itself costs only
~7 MB. The KeePassiumLib fallback is not needed.

What the numbers mean for the rest of the plan:

- The cost is the decrypted XML DOM, not Flutter: roughly **28 MB fixed +
  ~13.5 KB per entry** across the two data points, putting the cliff near
  **6000 entries** for a vault of this shape. That is the threshold the
  Phase 4 guardrail should warn at — measured, not guessed.
- **Never send the whole entry list over the channel.** 17 MB of the 5000
  entry run was the spike doing exactly that. Phase 2/3 must filter in Dart
  with the shared matcher and return only what matches, which is worth ~14 MB
  and moves the cliff to ~7500 entries.
- Custom icons are charged twice, once as base64 in the DOM and once decoded.
  The extension never renders them, so a kdbx.dart option to skip binaries and
  custom icons on load is a cheap, large win — see follow-ups.
- Skipping Argon2 was load bearing. At KeePass defaults (64 MB+) it would not
  have fit alongside a 48–78 MB DOM.
- 0.9 s / 1.15 s end to end is inside the few second budget for
  `provideCredentialWithoutUserInteraction`, but that path adds a keychain
  read and Face ID on top — measure it again in Phase 2 rather than assuming.

Build notes worth keeping (all three cost time to rediscover):

- The extension embeds the module's **Release** frameworks in every
  configuration, so a Debug host app still yields a release-engine appex —
  which is how to measure without replacing a production-signed app.
- An appex with an empty `CFBundleVersion` is rejected by `installd`. The
  target needs `Flutter/Generated.xcconfig` as its base configuration for
  `$(FLUTTER_BUILD_NUMBER)` to resolve — not `Flutter/Debug.xcconfig`, which
  drags in the app's Pods settings.
- `xcodeproj`'s `new_target` sets no `LD_RUNPATH_SEARCH_PATHS`, so the appex
  cannot resolve `@rpath/Flutter.framework` and dies before running a line of
  code. Xcode's own template sets it; the script now does too.

### Phase 1 — Shared foundations (≈ 2–3 weeks, parallelizable with Phase 0)

- kdbx.dart: export/inject the transformed key (`Credentials` variant carrying
  a pre-derived key; today internal to `_computeKeysV4`); salt-fingerprint
  accessor; `KPEX_*` preservation tests. (No save-path changes — the
  extension never writes the kdbx, see design decision 8.)
- `biometric_storage`: `kSecAttrAccessGroup` support (upstream, own plugin);
  migration for existing quick-unlock items (biometry-bound items cannot be
  moved into a group after the fact — re-create on next unlock).
- Dart eTLD+1 matcher (public-suffix based), wired into Android autofill too.
- App-group mirror layer in the app: copy-on-open/save + manifest.
- Provisioning: register extension bundle ids
  (`design.codeux.authpass.ios[.debug].autofill` — lowercase, like every other
  identifier here; the Xcode *target* stays `AuthPassAutofill`), app group and
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

Order of attack per research: shared pure-Dart authenticator core +
`KPEX_PASSKEY_*` layer (~3–4 weeks, no platform dependency) →
**Android** `CredentialProviderService` (~5–8 weeks; no dependency on the
Apple extensions, full-Flutter UI via PendingIntent) → Apple passkey delta on
the extensions built above (~4–8 weeks shared between iOS and macOS; plus an
ongoing relying-party-compat tail — KeePassium spent ~a year on site-specific
fixes). The staging design (decision 8) and decisions 1–7 are the
prerequisites this plan already provides.

### Follow-up worth doing regardless

**Lazy / skippable binaries in kdbx.dart.** Phase 0 measured the decrypted DOM
at 28 MB + ~13.5 KB per entry, and custom icons are a visible part of that.
The extension never renders an icon and never touches an attachment, so a load
option that skips inner-header binaries and custom icons would buy back a
large slice of the extension's budget — and would speed up opening big vaults
in the app too. Worth doing before Phase 4 sets its warning threshold, since
it moves the threshold.

Once kdbx.dart can export the transformed key (Phase 1), consider migrating
**quick-unlock** itself from caching the composite key hash (all-powerful,
never expires) to salt-bound transformed keys — that gives the
"leaked key goes stale on next save" property to the secret that actually
matters today, not just to the extension's copy.

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
| ~~Headless engine unstable in the appex (flutter#165904)~~ | **retired** — Phase 0 booted it on iOS 18 for ~7 MB; KeePassiumLib fallback dropped |
| Memory blowup on large vaults (XML DOM) | **confirmed real, and now quantified**: ~28 MB + 13.5 KB/entry, cliff near 6000 entries. transformed-key cache removes Argon2; filter in Dart instead of listing every entry; skip binaries/icons on load; memory monitor + user warning in Phase 4 |
| Provisioning/match friction (readonly repo, new ids, app group) | do it in Phase 1, not last; it gates everything |
| biometric_storage migration breaks existing quick-unlock | re-create items lazily on next unlock; namespace new group items |
| Mirror-copy staleness with cloud-synced vaults | manifest mtime check + clear "open AuthPass" UX; bookmark sharing as follow-up |
| Extension write path (needed for passkeys later) | decided — design decision 8: keychain staging + merge in main app; extension never writes the kdbx |
| Staged passkey stranded if user never reopens the app | backup-eligible staging item, reminder UX in extension, opportunistic BGTask; cross-device availability admittedly waits for the next app open |
