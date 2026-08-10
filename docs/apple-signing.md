# Apple signing and release

iOS and macOS releases are built and signed by `_tools/build-ios.sh` /
`_tools/build-macos.sh` and uploaded by `_tools/upload-ios.sh` /
`_tools/upload-macos.sh`. None of them uses fastlane, match, or the certificate
repository. macOS ships to the Mac App Store only — there is no Developer ID
build and nothing to notarize.

## The shape of it

Signing is **manual**: the certificate and the provisioning profile are stored
in blackbox and CI signs against them. Nothing on CI can mint a new profile.

That is a deliberate trade against automatic signing, which is genuinely less
to maintain. Automatic signing needs a credential that can create and renew
provisioning profiles, and an App Store Connect **team** key cannot be scoped
to a single app — so CI would hold a key able to publish every app on the
account. Manual signing keeps CI's only Apple credential an app-scoped
*individual* key that can upload builds and do nothing else.

The cost is a yearly manual renewal. See below.

## What CI holds

All blackbox encrypted, under `authpass/_tools/secrets/`:

| file | what |
|---|---|
| `apple_distribution.p12` | Apple Distribution certificate + private key |
| `apple_distribution_p12_password` | its export passphrase |
| `ios_appstore.mobileprovision` | profile `AuthPass iOS AppStore` |
| `macos_appstore.provisionprofile` | profile `AuthPass macOS AppStore` |
| `mac_installer_distribution.p12` | installer certificate, to sign the `.pkg` |
| `mac_installer_distribution_p12_password` | its export passphrase |
| `ApiKey_4LJJBK4Z86KR.p8` | individual API key, scoped to AuthPass, upload only |

"Apple Distribution" is universal — the same certificate signs the iOS app and
the macOS app. The Mac App Store additionally requires the installer `.pkg` to
be signed by a separate certificate, which Apple still labels "3rd Party Mac
Developer Installer"; that is the only macOS-specific piece of signing
material.

**Admin API keys never go in the repo, encrypted or not.** They live only in
`~/.appstoreconnect/private_keys/` on a laptop. Anything needing Admin (making
certificates or profiles) is therefore a local operation, never a CI one.

`build-ios.sh` imports the `.p12` into an ephemeral keychain it deletes on
exit, installs the profile by UUID, then runs `xcodebuild archive` and
`-exportArchive` against `ios/ExportOptions.plist`.

## Current certificates and profiles

Team `64ZPC769JY`.

| | id / uuid | expires |
|---|---|---|
| Apple Distribution | `MKK2855C7U` | 2027-08-10 |
| 3rd Party Mac Developer Installer | `WJPHRR6CJ7` | 2027-01-24 |
| `AuthPass iOS AppStore` (`…authpass.ios`) | `73903dfd-e7e7-457d-8951-80c8a363b935` | 2027-08-10 |
| `AuthPass macOS AppStore` (`…authpass`) | `0d395894-b9b8-4243-9e5e-5762c3866db0` | 2027-08-10 |

A profile cannot outlive the certificate it references, so a profile and its
certificate roll together. The installer certificate expires on its own
schedule and is not referenced by any profile.

## Auditing

Read-only, needs a key with at least App Manager:

```bash
cd authpass/_tools/cux_ship && dart run cux_ship appstore signing --bundle-id design.codeux.authpass.ios
```

It lists certificates, bundle ids and profiles with their expiry dates, so it
answers "what is about to expire" without opening the portal.

## Renewal

Before the certificate expires, from a laptop, with an **Admin** key:

1. Create a new Apple Distribution certificate. Generate the private key
   locally (Keychain Access → Certificate Assistant → Request a Certificate
   from a Certificate Authority) and upload only the CSR — the private key
   should never have existed anywhere else.
2. Regenerate the App Store profile for `design.codeux.authpass.ios` against
   the new certificate, and download it.
3. Export the certificate and its private key as a `.p12` with a fresh random
   passphrase.
4. Replace the four files above and re-encrypt:
   `blackbox_edit_start` / `blackbox_edit_end`, or `blackbox_register_new_file`
   for anything new.
5. Run a release build and confirm the `.ipa` is signed by the new certificate
   before revoking the old one.

If the app gains an app extension, each extension is a separate App ID with its
own profile, and every one of them needs an entry in the `provisioningProfiles`
dict in `ios/ExportOptions.plist` and in the `PROFILES` array in
`_tools/build-ios.sh`. Omitting one does not fail the export — it produces an
`.ipa` that Apple rejects at upload.

Profiles can also be created through the App Store Connect API rather than the
portal: `POST /v1/profiles` with the bundle id and certificate ids, which is
how `AuthPass macOS AppStore` was made. `cux_ship appstore signing` reads the
ids back but deliberately writes nothing.

## Still on fastlane

**Android**, which uses fastlane `supply` to reach the Play Store — a different
tool for a different store, unaffected by any of this. `android/Gemfile` is
its own.

`ios/Gemfile` survives for `xcodeproj`, not fastlane: scripts that edit
`Runner.xcodeproj` rather than hand-editing `project.pbxproj`.
