# AuthPass - Flutter Password Manager

see [../README.md](../README.md) for details.


## Apple releases

`release.sh` builds, signs and uploads on its own — no fastlane, no Xcode step:

```
# Use the correct flutter version from _tools/_flutter_version.sh
_tools/flutter_run.sh clean
_tools/release.sh macos    # or: ios
```

That runs `_tools/build-macos.sh` (archive + export a signed `.pkg`) and then
`_tools/upload-macos.sh` (App Store Connect), with `-ios` counterparts for iOS.
Either script can also be run on its own, with `-t` for the target and `-b` for
the build number.

Signing material comes from `_tools/secrets`, so the blackbox secrets have to
be decrypted first (`blackbox_postdeploy`, or `blackbox_edit_start` per file).
Nothing here can create or renew signing material — see
[../docs/apple-signing.md](../docs/apple-signing.md) for what is stored, and
for the yearly certificate renewal.

### The macOS direct download

The `.zip` for the website and the GitHub release is Developer ID signed and
notarized, which is a different signature from the App Store `.pkg`. Run it
after `build-macos.sh`, from a laptop:

```
_tools/build-macos.sh -t lib/env/production.dart -b 1234
_tools/notarize-macos.sh
```

It re-signs the archive the first command already produced, so the store build
and the download are the same build. Then submits to Apple, waits, staples the
ticket into the bundle and checks the result with `spctl` — the same thing
Gatekeeper does, so a pass means it opens without a right-click.

Not on CI on purpose: notarization is refused for the app-scoped key the
uploaders use and needs a team key, which cannot be limited to one app. It
reads one from `~/.appstoreconnect`, never from the repository.


## Releasing

One day I have to automate this...

* Write CHANGELOG
  * [`CHANGELOG.md`](./CHANGELOG.md)
  * copy&paste current build to fdroid changelog `../metadata/android/en-US/changelogs/XXX.txt`
* push to `stable` branch `git push origin HEAD:stable` and wait for github builds
  * Generates all artifacts, macos included — `ios.yaml` builds and uploads
    both Apple platforms, and no longer needs `MATCH_PASSWORD`
  * The macOS **direct download** zip is a local step — see below. CI uploads
    the `.pkg` to the Mac App Store, but notarizing needs a *team* App Store
    Connect key, so it deliberately stays off CI
  * `_tools/upload-artifact.sh /Users/herbert/Downloads/tmp/AuthPass.app-1.7.7_1519.zip`
* create tag called `v1.2.3` and `fdroid-v1.2.3`
* data.authpass.app
  * update `public_html/authpass-data/data/artifacts/stable.txt`
  * run `~/public_html/authpass-data/data/update_stable.sh`
  * update `public_html/authpass-data/data/fdroid-version.txt`
* run `appcast.generate.sh` to generate windows appcast update.
* Create GitHub Release
  * Create draft with v1.7.7
  * Run `_tools/release/github-release.sh` - this will upload:
    * AuthPass-setup-1.7.7_1519.exe
    * authpass-sideload-1519.apk
    * AuthPass.app-1.7.7-b1519.zip
    * authpass-linux-1.7.7_1519.tar.gz
* Upload Artifacts to [fosshub.com](https://devzone.fosshub.com/dashboard/projects)
  * run `_tools/release/fosshub-release.sh`
* Submit release to
  * https://play.google.com/apps/publish
  * https://appstoreconnect.apple.com/apps
  * [Samsung Apps](https://seller.samsungapps.com/main/sellerMain.as#)
    * https://galaxy.store/authpass
  * [Huawei App Gallery](https://developer.huawei.com/consumer/en/service/josp/agc/index.html)
    * https://appgallery.huawei.com/#/app/C101955193
  * [Amazon Appstore](https://developer.amazon.com/apps-and-games/console/apps/list.html)
    * https://www.amazon.com/CodeUX-design-AuthPass-Password-Manageer/dp/B088X48S61
  * [Microsoft Store](https://partner.microsoft.com/en-us/dashboard/windows/overview)
    * https://www.microsoft.com/store/apps/9P5N6ZNPSFBN
  * Linux PPA - use [authpass/authpass-deb](https://github.com/authpass/authpass-deb)
    ```shell
    docker-compose run bionic ./update.sh focal
    docker-compose run bionic ./update.sh bionic
    ```
  * snapcraft.io is already published to `edge` channel. [release it to stable](https://snapcraft.io/authpass/releases).
  * flathub.com should already be [updated](https://github.com/flathub/app.authpass.AuthPass) automatically daily. [check download](https://flathub.org/apps/details/app.authpass.AuthPass) ... [stats](https://klausenbusk.github.io/flathub-stats/#ref=app.authpass.AuthPass&interval=infinity&downloadType=installs%2Bupdates)

## Resources

* https://mobile-security.gitbook.io/mobile-security-testing-guide/android-testing-guide/0x05f-testing-local-authentication
