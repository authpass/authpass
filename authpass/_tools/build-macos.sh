#!/bin/bash
# Archives and exports the macOS app, signed against the stored profile.
#
#   _tools/build-macos.sh [-t lib/env/production.dart] [-o build/macos/pkg] [-b buildnumber]
#
# The macOS counterpart of build-ios.sh, and deliberately the same shape: the
# secrets exec supplies the signing material, so this needs no App Store
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

# Signing material comes from the environment, which is where
# `cux_ship secrets exec` puts it:
#
#   cux_ship secrets exec --keystore upload --api-key upload -- _tools/build-macos.sh
#
# The .app is signed by the same universal "Apple Distribution" certificate the
# iOS build uses; the .pkg needs its own installer certificate on top.
: "${APPLE_DISTRIBUTION_P12_PATH:?run this under 'cux_ship secrets exec'}"
: "${APPLE_DISTRIBUTION_P12_PASSWORD:?not set by secrets exec}"
: "${APPLE_MAC_INSTALLER_P12_PASSWORD:?not set by secrets exec}"

P12="$APPLE_DISTRIBUTION_P12_PATH"
INSTALLER_P12="${APPLE_MAC_INSTALLER_P12_PATH:?}"
PROFILES=("${APPLE_PROFILE_MACOS_APPSTORE_PATH:?}")

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
  -P "$APPLE_MAC_INSTALLER_P12_PASSWORD" \
  -T /usr/bin/codesign -T /usr/bin/security -T /usr/bin/productbuild
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN" >/dev/null
# A line at a time rather than `tr -d '"'`: the list is quote-delimited so a
# path may contain a space, and stripping the quotes splits one such path into
# two arguments, dropping keychains out of the search list. See build-ios.sh.
SEARCH_LIST=()
while IFS= read -r keychain_line; do
  keychain_line="${keychain_line#"${keychain_line%%[![:space:]]*}"}"
  keychain_line="${keychain_line%\"}"
  keychain_line="${keychain_line#\"}"
  if [ -n "$keychain_line" ]; then
    SEARCH_LIST+=("$keychain_line")
  fi
done < <(security list-keychains -d user)
security list-keychains -d user -s "$KEYCHAIN" ${SEARCH_LIST+"${SEARCH_LIST[@]}"}

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
  destination="$PROFILE_DIR/$uuid.provisionprofile"
  # Only clean up what this build put there — see build-ios.sh.
  if [ ! -e "$destination" ]; then
    INSTALLED_PROFILES+=("$destination")
  fi
  cp "$profile" "$destination"
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
