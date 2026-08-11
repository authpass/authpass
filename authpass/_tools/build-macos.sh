#!/bin/bash
# Archives and exports the macOS app, signed against the stored profile.
#
#   _tools/build-macos.sh [-t lib/env/production.dart] [-o build/macos/pkg] [-b buildnumber]
#
# The macOS counterpart of build-ios.sh, and deliberately the same shape: the
# blackbox secrets supply the signing material, so this needs no App Store
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

SECRETS="_tools/secrets"
# The .app is signed by the same universal "Apple Distribution" certificate the
# iOS build uses; the .pkg needs its own installer certificate on top.
P12="$SECRETS/apple_distribution.p12"
P12_PASSWORD_FILE="$SECRETS/apple_distribution_p12_password"
INSTALLER_P12="$SECRETS/mac_installer_distribution.p12"
INSTALLER_P12_PASSWORD_FILE="$SECRETS/mac_installer_distribution_p12_password"
PROFILES=("$SECRETS/macos_appstore.provisionprofile")

for f in "$P12" "$P12_PASSWORD_FILE" "$INSTALLER_P12" \
         "$INSTALLER_P12_PASSWORD_FILE" "${PROFILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo "missing $f — decrypt the blackbox secrets first" >&2
    exit 1
  fi
done

# defines APPLE_DISTRIBUTION_P12_PASSWORD
# shellcheck disable=SC1090
. "$P12_PASSWORD_FILE"
# defines MAC_INSTALLER_DISTRIBUTION_P12_PASSWORD
# shellcheck disable=SC1090
. "$INSTALLER_P12_PASSWORD_FILE"

# A keychain that exists for this build and no longer. Named per-process so two
# builds on one runner cannot delete each other's.
KEYCHAIN="$HOME/Library/Keychains/authpass-build-macos-$$.keychain-db"
KEYCHAIN_PASSWORD="$(openssl rand -hex 24)"
INSTALLED_PROFILES=()

cleanup() {
  security delete-keychain "$KEYCHAIN" 2>/dev/null || true
  for p in ${INSTALLED_PROFILES+"${INSTALLED_PROFILES[@]}"}; do
    rm -f "$p"
  done
}
trap cleanup EXIT INT TERM

echo "==> importing the signing certificates into a temporary keychain"
security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
security set-keychain-settings -lut 3600 "$KEYCHAIN"
security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
# productbuild signs the installer, so it needs the key too — codesign alone is
# not enough here, unlike on iOS.
security import "$P12" -k "$KEYCHAIN" -P "$APPLE_DISTRIBUTION_P12_PASSWORD" \
  -T /usr/bin/codesign -T /usr/bin/security -T /usr/bin/productbuild
security import "$INSTALLER_P12" -k "$KEYCHAIN" \
  -P "$MAC_INSTALLER_DISTRIBUTION_P12_PASSWORD" \
  -T /usr/bin/codesign -T /usr/bin/security -T /usr/bin/productbuild
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN" >/dev/null
security list-keychains -d user -s "$KEYCHAIN" $(security list-keychains -d user | tr -d '"')

if ! security find-identity -v -p codesigning "$KEYCHAIN" | grep -q "Apple Distribution"; then
  echo "the .p12 did not yield a usable distribution identity" >&2
  exit 1
fi
if ! security find-identity -v "$KEYCHAIN" | grep -q "Mac Developer Installer"; then
  echo "the installer .p12 did not yield a usable installer identity" >&2
  exit 1
fi

echo "==> installing the provisioning profile"
# macOS reads profiles from a different directory than iOS, and by filename
# uuid just the same.
PROFILE_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"
mkdir -p "$PROFILE_DIR"
for profile in "${PROFILES[@]}"; do
  uuid=$(security cms -D -i "$profile" | plutil -extract UUID raw -)
  cp "$profile" "$PROFILE_DIR/$uuid.provisionprofile"
  INSTALLED_PROFILES+=("$PROFILE_DIR/$uuid.provisionprofile")
  echo "    $(basename "$profile") -> $uuid"
done

echo "==> flutter build macos --config-only"
flutter build macos --release --config-only -t "$TARGET" \
  ${BUILD_NUMBER:+--build-number "$BUILD_NUMBER"}

ARCHIVE="build/macos/authpass.xcarchive"
rm -rf "$ARCHIVE" "$OUTPUT"

echo "==> xcodebuild archive"
xcodebuild -workspace macos/Runner.xcworkspace -scheme Runner \
  -configuration Release -destination 'generic/platform=macOS' \
  -archivePath "$ARCHIVE" \
  OTHER_CODE_SIGN_FLAGS="--keychain $KEYCHAIN" \
  archive

echo "==> xcodebuild -exportArchive"
xcodebuild -exportArchive -archivePath "$ARCHIVE" -exportPath "$OUTPUT" \
  -exportOptionsPlist macos/ExportOptions.plist

echo
echo "built $(ls "$OUTPUT"/*.pkg)"
