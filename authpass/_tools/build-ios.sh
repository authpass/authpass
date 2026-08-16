#!/bin/bash
# Archives and exports the iOS app, signed against the stored profiles.
#
#   _tools/build-ios.sh [-t lib/env/production.dart] [-o build/ios/ipa]
#
# Run under `cux_ship keychain exec`, which is where the keychain and the
# installed profiles come from. Holds no App Store Connect credential: signing
# material is supplied, not fetched, so nothing here can create or revoke it.
# Uploading is a separate step and the only one holding a key — see
# _tools/upload-ios.sh.
#
# Replaces `fastlane match` + `build_app`. `flutter build ipa` is not used
# because it cannot pass an -exportOptionsPlist, and the export options are
# where the profile mapping and manageAppVersionAndBuildNumber live.

set -euo pipefail

cd "${0%/*}/.."

TARGET="lib/env/production.dart"
OUTPUT="build/ios/ipa"
BUILD_NUMBER=""
while [ $# -gt 0 ]; do
  case "$1" in
    -t) shift; TARGET="$1" ;;
    -o) shift; OUTPUT="$1" ;;
    -b) shift; BUILD_NUMBER="$1" ;;
    *) echo "usage: $0 [-t target.dart] [-o outdir] [-b buildnumber]" >&2; exit 64 ;;
  esac
  shift
done

# The keychain and the profiles arrive from `cux_ship keychain exec`, which
# makes a keychain that lives for one command, imports the certificate,
# installs the profiles under the uuid Xcode looks them up by, and destroys all
# of it however this exits:
#
#   _tools/ship.sh keychain exec \
#     --profile ios_appstore --profile ios_appstore_autofill \
#     -- authpass/_tools/build-ios.sh
#
# Deliberately *not* `secrets exec --api-key`. Under keychain exec no App Store
# Connect credential is placed in the environment at all, so this script cannot
# acquire one by accident — which is what makes the claim above true rather
# than aspirational. Uploading is a separate step and the only one holding a
# key; see _tools/upload-ios.sh and how _tools/release.sh wraps it.
#
# What used to be here — the temporary keychain, the partition list, the search
# list, the identity check, the profile installation — was forty lines that
# three projects each kept a slightly different copy of. Two bugs in this copy
# were found by review against the one that became cux_ship's.
: "${APPLE_KEYCHAIN:?run this under 'cux_ship keychain exec'}"

echo "==> autofill module frameworks"
# The extension embeds a separate Flutter module, and its xcframeworks are
# build output — gitignored, so a fresh checkout has none and the archive fails
# with "There is no XCFramework found at .../build/framework/current". Building
# them here rather than expecting them to be lying around is what makes a clean
# machine, CI included, able to build at all.
#
# Release: a debug engine in an appex exceeds the extension memory cap on its
# own (flutter#135243). The script points `current` at whatever it just built.
../autofill_module/build_ios_framework.sh Release

echo "==> flutter build ios --config-only"
# --config-only writes Generated.xcconfig and stops; xcodebuild does the rest.
# The build number lands in FLUTTER_BUILD_NUMBER there, which is where the
# Info.plist reads it from — and ExportOptions.plist sets
# manageAppVersionAndBuildNumber false so the export cannot overwrite it.
flutter build ios --release --config-only -t "$TARGET" \
  ${BUILD_NUMBER:+--build-number "$BUILD_NUMBER"}

ARCHIVE="build/ios/authpass.xcarchive"
rm -rf "$ARCHIVE" "$OUTPUT"

echo "==> xcodebuild archive"
xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner \
  -configuration Release -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE" \
  OTHER_CODE_SIGN_FLAGS="--keychain $APPLE_KEYCHAIN" \
  archive

echo "==> xcodebuild -exportArchive"
xcodebuild -exportArchive -archivePath "$ARCHIVE" -exportPath "$OUTPUT" \
  -exportOptionsPlist ios/ExportOptions.plist

echo
echo "built $(ls "$OUTPUT"/*.ipa)"
