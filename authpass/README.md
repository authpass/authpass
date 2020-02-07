# AuthPass - Flutter Password Manager

see [../README.md](../README.md) for details.


## MacOS Release

### Build with Flutter

```
# I use `flutter_dev` as an alias to a flutter dev channel.

flutter_dev clean
flutter_dev pub get
flutter_dev build macos -t lib/env/production.dart --release
```

### Open Xcode

Product -> Archive Project.



### Deprecated:

```
flutter channel master && flutter upgrade
flutter clean
# Update buildnumber in `pubspec.yaml`(?)
flutter build macos -t lib/env/production.dart --release

cd build/macos/Build/Products/Release/

# <workaround>
rm AuthPass.app/Contents/Frameworks/App.framework/Versions/Current
ls -l AuthPass.app/Contents/Frameworks/App.framework/Versions/
# </workarorund>

codesign --entitlements ~/dev/authpass/authpass/macos/AuthPass-release.entitlements --options=runtime -f -v --timestamp --deep -s 'Developer ID Application: TaPo-IT OG (2N9YTZSQBW)' AuthPass.app

cd $basedir/macos/
# bundle install
bundle exec fastlane hptest # notarize

```

## Resources

* https://mobile-security.gitbook.io/mobile-security-testing-guide/android-testing-guide/0x05f-testing-local-authentication
