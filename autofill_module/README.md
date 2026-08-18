# authpass_autofill_module

Headless Dart module for the AuthPass credential provider extensions. Runs
inside the appex, answers "which entries match" and "what is the password", and
has no UI — the native Swift side owns the OS protocol and the picker.

See [`docs/autofill/plan.md`](../docs/autofill/plan.md).

## Why it is separate from the app

Booting the whole AuthPass app inside an extension was tried twice and rejected:
it forces a fork of every plugin that touches `UIApplication`. This module
depends on `kdbx` and nothing else.

It notably does **not** depend on `argon2_ffi`. The extension never derives a
key — the app hands it the post-KDF transformed key
(`KdbxFile.transformedKeyCredentials`), which is what keeps the process inside
the ~120 MB extension memory cap.

## Phase 0 spike — running the measurement

The spike answers one question: does a Flutter engine plus a realistic kdbx fit
in the extension's memory budget? It needs a **physical device** and a
**release** build. The simulator has no memory cap, and a debug engine exceeds
the budget on its own ([flutter#135243](https://github.com/flutter/flutter/issues/135243)),
so neither tells you anything.

```bash
cd autofill_module && dart run tool/generate_test_vault.dart
```

Writes a 2000 entry / 30 custom icon vault plus its transformed key to
`authpass/ios/AuthPassAutofill/Fixtures/`. Both are gitignored. Pass different
counts to make it heavier — `dart run tool/generate_test_vault.dart 5000 100`.

```bash
cd autofill_module && ./build_ios_framework.sh Release
```

Builds `App.xcframework` and swaps in the extension-safe engine.

```bash
cd authpass/ios && bundle exec ruby add_autofill_target.rb
```

Adds (or refreshes) the `AuthPassAutofill` target in `Runner.xcodeproj`. Only
needed after changing that script or adding Swift files.

```bash
cd authpass && flutter build ios --release -t lib/env/development.dart
```

Then in Xcode: open `authpass/ios/Runner.xcworkspace`, select the
**AuthPassAutofill** scheme and your device, and Run. Xcode asks which app to
run it in — pick AuthPass.

Read the numbers off the extension's screen, or from Console.app filtered on
`autofill-spike`. What matters is the memory still available after the vault is
open and an entry is decrypted; compare it against the ~120 MB other password
managers report as the cap.
