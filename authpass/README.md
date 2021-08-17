# AuthPass - Flutter Password Manager

see [../README.md](../README.md) for details.


## MacOS Release


### Build with Flutter

```
# Use the  correct flutter version from _tools/_flutter_version.sh

_tools/flutter_run.sh clean
_tools/release.sh macos
```

### Open Xcode

Product -> Archive Project.


## Releasing

One day I have to automate this...

* Write CHANGELOG
  * [`CHANGELOG.md`](./CHANGELOG.md)
  * copy&paste current build to fdroid changelog `metadata/android/en-US/changelogs/XXX.txt`
* push to `stable` branch `git push origin HEAD:stable` and wait for github builds
  * Already generates all artifacts except macos
  * Run macOS build locally (see above step), publish to app store and create distribution zip file
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

## Resources

* https://mobile-security.gitbook.io/mobile-security-testing-guide/android-testing-guide/0x05f-testing-local-authentication
