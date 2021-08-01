# Contributing to AuthPass

We appreciate any kind of contributions to AuthPass 😅️ 


* [Visit the forum which lists many ways for contributing](https://forum.authpass.app/c/contributors/contribute/13): https://forum.authpass.app/c/contributors/contribute/13
* [Check out the article on helping support AuthPass on our website.](https://authpass.app/docs/support-authpass-get-involved/)

If you want to contribute documentation or code, never hesitate to [get in contact](https://authpass.app/docs/about-authpass-password-manager/#getting-in-touch).

[💬 Also, join our discord channel. 💬](https://authpass.app/go/discord)

# Translations

The actual translations are handled by the crowdin platform at: <https://translate.authpass.app/authpass>. Do **not** modify any translated 
`app_XX.arb` files manually.

If you want to contribute new translations:

1. check if your lanuage already exists at: <https://translate.authpass.app/authpass>
2. If not, join [our discord channel and ping @hpoul](https://authpass.app/go/discord)

## New strings

All new code should have translatable strings, even if the code base still does not 100% use externalized strings. See https://github.com/authpass/authpass/issues/78 -- This might also be a good first PR ;-) Pick a few source files and externalize the strings.

* Add your string into `app_en.arb` - give a useful `description` (and/or `context`). (do NOT translate it in any other `app_XX.arb` file, as this is handled [through crowdin](https://translate.authpass.app/authpass)).
* In the code typically use a variable in the `build` method: `final loc = AppLocalizations.of(context)` and access your string through `loc.xxxx`.
* See the flutter [i18n/l10n documentation](https://flutter.dev/go/i18n-user-guide).

# Code / Development

AuthPass is based on Flutter, so you should get familiar with the Dart programming language
as well as Flutter itself. You can checkout the Flutter website at https://flutter.dev/

If you have never used Flutter before you might [want to walk through a few codelabs](https://flutter.dev/docs/get-started/codelab) before getting into AuthPass.

## Cloning/Forking

AuthPass makes [heavy use of submodules right now](https://github.com/authpass/authpass/blob/master/.gitmodules). If you fork the repository you might experience a few
permission denied errors when you clone using ssh. To work around those you might need to add the follwing to your `~/.gitconfig`:

```
[url "https://github.com/"]
  insteadOf = git@github.com:
[url "git@github.com:"]
  pushInsteadOf = "https://github.com/"
```

(If you don't want it for all github repositories, you might only configure it for `github:hpoul/` and `github:authpass/`).

## Setup Development Environment

1. [Download Flutter](https://flutter.dev/docs/get-started/install) and make sure `flutter doctor` shows no errors.
   * Latest Flutter dev channel should typically work, check out
     [authpass/_tools/_flutter_version.sh](authpass/_tools/_flutter_version.sh) for what's being used in the CI.
   * ⚠️ *no longer required*: (this should be fixed, just leaving it in, in case people still see this error) Right now one extra step is required after installing flutter: in the flutter directory change to `flutter/dev/tools` and run: `flutter pub get`. See the (flutter issue #65023)[https://github.com/flutter/flutter/issues/65023] for details.
     otherwise you will stumble on errors like:
     ```flutter/dev/tools/localization/bin/gen_l10n.dart:7:8: Error: Error when reading '/flutter/.pub-cache/hosted/pub.dartlang.org/args-1.6.0/lib/args.dart': The system cannot find the path specified.```
2. Clone the repository `git clone https://github.com/authpass/authpass.git` (or better yet, create your own fork to make later creating Pull Requests easier).
3. Initialize submodules `git submodule update --init`
4. Change to the `authpass/` subdirectory:

    ```shell
    git clone https://github.com/authpass/authpass.git
    cd authpass/authpass
    ```
5. Launch AuthPass
    ```shell
    flutter run -t lib/env/development.dart
    ```

You are required to select a specific target file,
usually this will be `lib/env/development.dart`.

## Running on Android

For android you have to add an additional flavor:

```
flutter run --target=lib/env/development.dart --flavor=playstore
```


# Code Style

Make sure to follow common Dart coding conventions, and follow all lints provided
by `analysis_options.yaml` and [activate auto-formatting](https://flutter.dev/docs/development/tools/formatting) using `dartfmt`.

# CLA - Contributor License Agreement

When creating your first Pull Request you will be asked to sign the 
[Contributor License Agreement](https://cla-assistant.io/authpass/authpass). This ensures there
is no (less?) ambiguity regarding copyright and licensing rights in case of any disputes.
If you have any concerns just ping [@hpoul](https://github.com/hpoul).
