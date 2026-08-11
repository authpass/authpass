#!/bin/bash
# Archives and exports the iOS app, signed against the stored profiles.
#
#   _tools/build-ios.sh [-t lib/env/production.dart] [-o build/ios/ipa]
#
# Needs the blackbox secrets decrypted (blackbox_postdeploy on CI,
# blackbox_edit_start locally). Needs no App Store Connect credential at all:
# signing material is supplied, not fetched, so nothing here can create or
# revoke it. Uploading is a separate step and the only one holding a key —
# see _tools/upload-ios.sh.
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

# Signing material comes from the environment, which is where
# `cux_ship secrets exec` puts it:
#
#   cux_ship secrets exec --keystore upload --api-key upload -- _tools/build-ios.sh
#
# The blackbox files are the fallback while the migration is in flight, so this
# still works under the old arrangement. When they are gone, so is the else.
SECRETS="_tools/secrets"

if [ -n "${APPLE_DISTRIBUTION_P12_PATH:-}" ]; then
  P12="$APPLE_DISTRIBUTION_P12_PATH"
  # One per signed target. The extension has its own, and a matching entry in
  # ios/ExportOptions.plist.
  PROFILES=(
    "$APPLE_PROFILE_IOS_APPSTORE_PATH"
    "$APPLE_PROFILE_IOS_APPSTORE_AUTOFILL_PATH"
  )
else
  P12="$SECRETS/apple_distribution.p12"
  P12_PASSWORD_FILE="$SECRETS/apple_distribution_p12_password"
  PROFILES=(
    "$SECRETS/ios_appstore.mobileprovision"
    "$SECRETS/ios_appstore_autofill.mobileprovision"
  )
  for f in "$P12" "$P12_PASSWORD_FILE" "${PROFILES[@]}"; do
    if [ ! -f "$f" ]; then
      echo "missing $f — run under 'cux_ship secrets exec', or decrypt" >&2
      echo "the blackbox secrets first" >&2
      exit 1
    fi
  done
  # defines APPLE_DISTRIBUTION_P12_PASSWORD
  # shellcheck disable=SC1090
  . "$P12_PASSWORD_FILE"
fi

# A keychain that exists for this build and no longer. Named per-process so two
# builds on one runner cannot delete each other's.
KEYCHAIN="$HOME/Library/Keychains/authpass-build-$$.keychain-db"
# openssl rather than `tr </dev/urandom | head`: head exits at its byte count,
# tr takes SIGPIPE, and pipefail turns that into a fatal 141.
KEYCHAIN_PASSWORD="$(openssl rand -hex 24)"
INSTALLED_PROFILES=()

cleanup() {
  security delete-keychain "$KEYCHAIN" 2>/dev/null || true
  for p in ${INSTALLED_PROFILES+"${INSTALLED_PROFILES[@]}"}; do
    rm -f "$p"
  done
}
trap cleanup EXIT INT TERM

echo "==> importing the distribution certificate into a temporary keychain"
security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
security set-keychain-settings -lut 3600 "$KEYCHAIN"
security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
# -A would let any binary use the key without prompting; -T codesign keeps that
# to the one tool that needs it.
security import "$P12" -k "$KEYCHAIN" -P "$APPLE_DISTRIBUTION_P12_PASSWORD" \
  -T /usr/bin/codesign -T /usr/bin/security
# Without this, codesign blocks on a UI prompt that a runner cannot answer.
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN" >/dev/null
# Prepend rather than replace: the login keychain still holds what other tools
# expect, and xcodebuild searches the whole list.
security list-keychains -d user -s "$KEYCHAIN" $(security list-keychains -d user | tr -d '"')

if ! security find-identity -v -p codesigning "$KEYCHAIN" | grep -q "Apple Distribution"; then
  echo "the .p12 did not yield a usable distribution identity" >&2
  exit 1
fi

echo "==> installing provisioning profiles"
PROFILE_DIR="$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles"
mkdir -p "$PROFILE_DIR"
for profile in "${PROFILES[@]}"; do
  # Xcode finds a profile by the uuid in its filename, not by its path.
  uuid=$(security cms -D -i "$profile" | plutil -extract UUID raw -)
  cp "$profile" "$PROFILE_DIR/$uuid.mobileprovision"
  INSTALLED_PROFILES+=("$PROFILE_DIR/$uuid.mobileprovision")
  echo "    $(basename "$profile") -> $uuid"
done

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
  OTHER_CODE_SIGN_FLAGS="--keychain $KEYCHAIN" \
  archive

echo "==> xcodebuild -exportArchive"
xcodebuild -exportArchive -archivePath "$ARCHIVE" -exportPath "$OUTPUT" \
  -exportOptionsPlist ios/ExportOptions.plist

echo
echo "built $(ls "$OUTPUT"/*.ipa)"
