#!/bin/bash
# Exports the macOS archive for direct download: Developer ID signed,
# notarized, stapled, zipped.
#
#   _tools/build-macos.sh -t lib/env/production.dart -b 1234   # makes the archive
#   _tools/notarize-macos.sh                                   # then this
#
# Re-signs the archive build-macos.sh already produced rather than building
# again, so the .pkg on the App Store and the .zip on the website are the same
# build. The result is what _tools/upload-artifact.sh and the GitHub release
# expect, and what Gatekeeper will open without a right-click.
#
# DELIBERATELY NOT PART OF CI, unlike every other release step.
#
# Notarization will not accept the app-scoped individual key the uploaders use
# — it answers 401 — and the team key it does accept cannot be scoped to one
# app. Putting one in blackbox would hand anything with CI access the ability
# to publish every app on the account, which is the whole reason the rest of
# this pipeline avoids team keys. So this step runs from a laptop, against a
# key in ~/.appstoreconnect that never enters the repository.

set -euo pipefail

cd "${0%/*}/.."

ARCHIVE="build/macos/authpass.xcarchive"
OUTPUT="build/macos/direct"
# A team key, from outside the repository. Admin is not required — any team key
# notarytool accepts will do — but it must not be an individual key.
NOTARY_KEY_ID="${AUTHPASS_NOTARY_KEY_ID:-ZHGL57YJVC}"
NOTARY_ISSUER="${AUTHPASS_NOTARY_ISSUER:-0f1ac0c6-ea92-4609-a2f0-c9b239198a75}"
NOTARY_KEY="${AUTHPASS_NOTARY_KEY:-$HOME/.appstoreconnect/private_keys/AuthKey_${NOTARY_KEY_ID}.p8}"

while [ $# -gt 0 ]; do
  case "$1" in
    -a) shift; ARCHIVE="$1" ;;
    -o) shift; OUTPUT="$1" ;;
    *) echo "usage: $0 [-a archive] [-o outdir]" >&2; exit 64 ;;
  esac
  shift
done

SECRETS="_tools/secrets"
P12="$SECRETS/developer_id_application.p12"
P12_PASSWORD_FILE="$SECRETS/developer_id_application_p12_password"
PROFILE="$SECRETS/macos_developerid.provisionprofile"

for f in "$P12" "$P12_PASSWORD_FILE" "$PROFILE"; do
  if [ ! -f "$f" ]; then
    echo "missing $f — decrypt the blackbox secrets first" >&2
    exit 1
  fi
done
if [ ! -d "$ARCHIVE" ]; then
  echo "missing $ARCHIVE — run _tools/build-macos.sh first" >&2
  exit 1
fi
if [ ! -f "$NOTARY_KEY" ]; then
  echo "missing $NOTARY_KEY" >&2
  echo "  Notarization needs a *team* key, and deliberately reads it from" >&2
  echo "  outside the repository. Override with AUTHPASS_NOTARY_KEY." >&2
  exit 1
fi

# defines DEVELOPER_ID_APPLICATION_P12_PASSWORD
# shellcheck disable=SC1090
. "$P12_PASSWORD_FILE"

KEYCHAIN="$HOME/Library/Keychains/authpass-notarize-$$.keychain-db"
KEYCHAIN_PASSWORD="$(openssl rand -hex 24)"
INSTALLED_PROFILE=""

cleanup() {
  security delete-keychain "$KEYCHAIN" 2>/dev/null || true
  [ -n "$INSTALLED_PROFILE" ] && rm -f "$INSTALLED_PROFILE"
}
trap cleanup EXIT INT TERM

echo "==> importing the Developer ID certificate into a temporary keychain"
security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
security set-keychain-settings -lut 3600 "$KEYCHAIN"
security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
security import "$P12" -k "$KEYCHAIN" -P "$DEVELOPER_ID_APPLICATION_P12_PASSWORD" \
  -T /usr/bin/codesign -T /usr/bin/security
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN" >/dev/null
security list-keychains -d user -s "$KEYCHAIN" $(security list-keychains -d user | tr -d '"')

if ! security find-identity -v -p codesigning "$KEYCHAIN" | grep -q "Developer ID Application"; then
  echo "the .p12 did not yield a usable Developer ID identity" >&2
  exit 1
fi

echo "==> installing the Developer ID provisioning profile"
PROFILE_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"
mkdir -p "$PROFILE_DIR"
uuid=$(security cms -D -i "$PROFILE" | plutil -extract UUID raw -)
INSTALLED_PROFILE="$PROFILE_DIR/$uuid.provisionprofile"
cp "$PROFILE" "$INSTALLED_PROFILE"
echo "    $(basename "$PROFILE") -> $uuid"

rm -rf "$OUTPUT"
echo "==> xcodebuild -exportArchive (developer-id)"
xcodebuild -exportArchive -archivePath "$ARCHIVE" -exportPath "$OUTPUT" \
  -exportOptionsPlist macos/ExportOptionsDeveloperId.plist

APP=$(ls -d "$OUTPUT"/*.app | head -1)
if [ -z "$APP" ]; then
  echo "the export produced no .app" >&2
  exit 1
fi

# Notarization takes an archive, not a bundle. ditto rather than zip: zip does
# not preserve the symlinks inside a macOS framework, and the result fails to
# notarize in a way that is tedious to diagnose.
ZIP="$OUTPUT/$(basename "${APP%.app}").zip"
echo "==> zipping for submission"
ditto -c -k --keepParent "$APP" "$ZIP"

echo "==> notarytool submit (this waits for Apple, usually a few minutes)"
xcrun notarytool submit "$ZIP" \
  --key "$NOTARY_KEY" --key-id "$NOTARY_KEY_ID" --issuer "$NOTARY_ISSUER" \
  --wait

# Staple the ticket into the bundle so Gatekeeper does not need the network,
# then re-zip: the submitted zip predates the ticket.
echo "==> stapling"
xcrun stapler staple "$APP"
xcrun stapler validate "$APP"
rm -f "$ZIP"
ditto -c -k --keepParent "$APP" "$ZIP"

echo "==> verifying the way Gatekeeper will"
spctl --assess --type execute --verbose=2 "$APP"

echo
echo "notarized $ZIP"
echo "upload it with: _tools/upload-artifact.sh $ZIP"
