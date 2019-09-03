# AuthPass - Flutter Password Manager

see [../README.md](../README.md) for details.


## MacOS Release


```
flutter channel master && flutter upgrade
flutter clean
flutter build macos -t lib/env/production.dart --release

cd build/macos/Build/Products/Release/

# <workaround>
rm AuthPass.app/Contents/Frameworks/App.framework/Versions/Current
ls -l AuthPass.app/Contents/Frameworks/App.framework/Versions/
# </workarorund>

codesign --entitlements ~/dev/authpass/authpass/macos/AuthPass.entitlements --options=runtime -f -v --timestamp --deep -s 'Developer ID Application: TaPo-IT OG (2N9YTZSQBW)' AuthPass.app

cd $basedir/macos/
# bundle install
bundle exec fastlane hptpest # notarize

```

## Resources

* https://mobile-security.gitbook.io/mobile-security-testing-guide/android-testing-guide/0x05f-testing-local-authentication
