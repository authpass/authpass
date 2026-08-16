#!/bin/bash
# Archives and exports the macOS app, signed against the stored profile.
#
#   _tools/build-macos.sh [-t lib/env/production.dart] [-o build/macos/pkg] [-b buildnumber]
#
# The macOS counterpart of build-ios.sh, and deliberately the same shape:
# keychain exec supplies the signing material, so this holds no App Store
# Connect credential and cannot create or revoke anything. Uploading is a
# separate step — see _tools/upload-macos.sh.
#
# Replaces `fastlane match` + `build_mac_app`.

set -euo pipefail

cd "${0%/*}/.."

TARGET="lib/env/production.dart"
OUTPUT="build/macos/pkg"
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
# makes a keychain that lives for one command, imports every certificate it
# finds — the app store one signs the .app, the installer one signs the .pkg —
# installs the profiles where macOS reads them, and destroys all of it however
# this exits:
#
#   _tools/ship.sh keychain exec --profile macos_appstore \
#     -- authpass/_tools/build-macos.sh
#
# Deliberately *not* `secrets exec --api-key`: this script holds no App Store
# Connect credential, and under keychain exec none is placed in the environment
# for it to hold. See _tools/upload-macos.sh for the step that does.
: "${APPLE_KEYCHAIN:?run this under 'cux_ship keychain exec'}"

echo "==> flutter build macos --config-only"
flutter build macos --release --config-only -t "$TARGET" \
  ${BUILD_NUMBER:+--build-number "$BUILD_NUMBER"}

ARCHIVE="build/macos/authpass.xcarchive"
rm -rf "$ARCHIVE" "$OUTPUT"

echo "==> xcodebuild archive"
xcodebuild -workspace macos/Runner.xcworkspace -scheme Runner \
  -configuration Release -destination 'generic/platform=macOS' \
  -archivePath "$ARCHIVE" \
  OTHER_CODE_SIGN_FLAGS="--keychain $APPLE_KEYCHAIN" \
  archive

echo "==> xcodebuild -exportArchive"
xcodebuild -exportArchive -archivePath "$ARCHIVE" -exportPath "$OUTPUT" \
  -exportOptionsPlist macos/ExportOptions.plist

echo
echo "built $(ls "$OUTPUT"/*.pkg)"
