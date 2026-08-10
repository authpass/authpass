# Provisioning the iOS AutoFill extension

The last Phase 1 item from [plan.md](plan.md). Everything here needs an Apple
Developer portal login and an Admin App Store Connect key, neither of which
this repo carries, so it is a manual checklist rather than a script.

Dev signing already works without any of this: Xcode's automatic signing has
been creating what it needs. What follows is what App Store / TestFlight builds
need.

## What you are registering

| | identifier |
|---|---|
| app | `design.codeux.authpass.ios` |
| extension | `design.codeux.authpass.ios.autofill` |
| app (debug) | `design.codeux.authpass.ios.debug` |
| extension (debug) | `design.codeux.authpass.ios.debug.autofill` |
| app group | `group.design.codeux.authpass` |

Team `64ZPC769JY`. An extension's bundle id **must** be prefixed by its host
app's — that is a hard Apple rule, not a convention.

The app group doubles as the keychain access group. An app group identifier is
a valid `kSecAttrAccessGroup` and needs no team-id prefix, which is why there is
no Keychain Sharing capability to add.

> Automatic signing may already have created
> `design.codeux.authpass.ios.debug.autofill` (and, from an earlier iteration,
> a stale `…debug.AuthPassAutofill`). Registering an existing id is a no-op;
> delete the stale CamelCase one if you see it.

## 1. App group — already done

`group.design.codeux.authpass` is registered (confirmed in the portal
2026-08-09, under Identifiers → App Groups). Nothing to do; kept here so the
checklist reads completely.

The `group.` prefix is mandatory on iOS — Apple rejects anything else and adds
the team id itself. **macOS works differently**: a sandboxed app needs the
group prefixed with the team id, authorized by an embedded provisioning
profile, or distributed via the Mac App Store. Since AuthPass ships both MAS
and Developer ID builds, the macOS extension in phase 5 may need
`64ZPC769JY.group.design.codeux.authpass` instead — see
`Env.autofillAppGroupIdentifier`.

## 2. Extension App IDs

> These are **App IDs**, not app groups, even though the portal lists both
> under "Identifiers" — they are two values of the filter dropdown at the top
> right. Only one app group is ever needed (step 1) and it is the only
> identifier that starts with `group.`. An extension's App ID must instead be
> prefixed by its host app's App ID, which is why these read
> `design.codeux.authpass.ios` + `.autofill`.

Identifiers → **switch the top right filter to App IDs** → **+** →
**App IDs** → **App** → Continue.

Do this twice, once per row:

| Description | Bundle ID (explicit) |
|---|---|
| `AuthPass iOS AutoFill` | `design.codeux.authpass.ios.autofill` |
| `AuthPass iOS AutoFill Debug` | `design.codeux.authpass.ios.debug.autofill` |

For each, before saving, tick under **Capabilities**:

- **App Groups**
- **AutoFill Credential Provider**

Then Continue → Register.

## 3. Attach the app group to all four App IDs

The capability checkbox only says "this app may use app groups"; the group
itself is assigned separately, and it is easy to miss.

For each of the four App IDs (the two apps **and** the two extensions):

1. Identifiers → click the App ID.
2. **App Groups** row → **Configure** (or **Edit**).
3. Tick `group.design.codeux.authpass` → Continue → Save.

While you are in the two *app* App IDs, also confirm **AutoFill Credential
Provider** is ticked there. The containing app needs it too, not just the
extension.

Saving a capability change invalidates existing profiles — that is expected,
step 4 regenerates them.

## 3b. What automatic signing already did

Building to a device with automatic signing registers the App ID *and* enables
the capabilities for you. After the first dev build, the portal already had
`design.codeux.authpass.ios.debug.autofill` with both
`autofill-credential-provider` and `group.design.codeux.authpass` — which is
why trying to register it by hand answers "An App ID with Identifier … is not
available".

So steps 2 and 3 in practice only concern the two **production** identifiers,
`design.codeux.authpass.ios` and `design.codeux.authpass.ios.autofill`. Check
before creating; an existing one is fine, not a mistake.

Automatic signing may also have left a stale
`design.codeux.authpass.ios.debug.AuthPassAutofill` from before the bundle id
was lowercased. Harmless, but worth deleting.

## 4. The extension's distribution profile

Match is gone — releases sign manually against profiles stored in blackbox. The
general procedure, and the yearly certificate renewal, are in
[../ios-signing.md](../ios-signing.md); this is only what the extension adds.

The app already has `AuthPass iOS AppStore`. The extension needs its own, named
exactly **`AuthPass iOS AutoFill AppStore`** — `EXTENSION_PROFILE` in
`ios/add_autofill_target.rb` writes that name into the target's Release and
Profile configurations, so the two must agree.

From a laptop, with an **Admin** App Store Connect key (an App Manager key can
read profiles but is refused on writes):

1. Create an App Store distribution profile for
   `design.codeux.authpass.ios.autofill`, against the same Apple Distribution
   certificate the app uses. A profile cannot outlive its certificate, so both
   roll together.
2. Download it to `authpass/_tools/secrets/ios_appstore_autofill.mobileprovision`.
3. Register it: `blackbox_register_new_file` — it is already listed in
   `.blackbox/blackbox-files.txt`, so in practice this is
   `blackbox_edit_start` / `blackbox_edit_end`.

Debug stays on automatic signing, which is what keeps device testing working
without any of this.

## 5. Wire it into the release

Two places, both of which already name the app and need the extension added
alongside it:

- `ios/ExportOptions.plist` — a `provisioningProfiles` entry mapping
  `design.codeux.authpass.ios.autofill` to `AuthPass iOS AutoFill AppStore`.
  A target missing here does not fail the export; it produces an `.ipa` Apple
  rejects at upload.
- `_tools/build-ios.sh` — the `PROFILES` array, so the profile is installed
  into the keychain before `xcodebuild`.

`xcodebuild -scheme Runner` needs no change: the extension is a dependency of
the Runner target, so it is built and signed as part of it.

## 6. Verify

```bash
cd authpass && ./_tools/build-ios.sh -t lib/env/production.dart
```

Then check both binaries carry the entitlements:

```bash
codesign -d --entitlements - --xml build/ios/iphoneos/Runner.app | plutil -p - | grep -E "autofill|application-groups"
```

```bash
codesign -d --entitlements - --xml build/ios/iphoneos/Runner.app/PlugIns/AuthPassAutofill.appex | plutil -p - | grep -E "autofill|application-groups"
```

Each should show
`com.apple.developer.authentication-services.autofill-credential-provider` and
`group.design.codeux.authpass`.

## Known failure modes

**"Provisioning profile doesn't include the AutoFill Credential Provider
capability"** — step 2 or 3 was missed for that identifier, or the profile
predates the change. Saving a capability invalidates existing profiles, so
regenerate and re-encrypt it (step 4).

**"doesn't support the group.design.codeux.authpass App Group"** — the
capability is ticked but the group was never assigned. Step 3.

**"Unable to log in with account … The login details were rejected"** — the
Xcode account session expired. Xcode → Settings → Accounts → re-authenticate.
Automatic signing cannot create anything until this is fixed.

**appex rejected at install with "does not have a CFBundleVersion key"** — the
extension target lost `Flutter/Generated.xcconfig` as its base configuration.
Re-run `bundle exec ruby add_autofill_target.rb`.
