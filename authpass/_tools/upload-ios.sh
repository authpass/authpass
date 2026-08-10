#!/bin/bash
# Uploads a signed .ipa to App Store Connect.
#
#   _tools/upload-ios.sh [-i build/ios/ipa/authpass.ipa] [--dry-run]
#
# Replaces `upload_to_testflight`. The only Apple credential in the release
# pipeline, and deliberately the weakest one available: an *individual* API key
# scoped to the AuthPass apps. It cannot read or alter certificates,
# identifiers or profiles — those all answer 401 — and it cannot see the other
# apps in the team. Signing material is supplied by _tools/build-ios.sh from
# the stored profiles, not fetched, so nothing in CI needs more than this.
#
# A team key would work too, and is what fastlane used, but team keys cannot be
# scoped to an app: one would let anything with CI access publish every app in
# the account.

set -euo pipefail

cd "${0%/*}/.."

IPA="build/ios/ipa/authpass.ipa"
EXTRA=()
while [ $# -gt 0 ]; do
  case "$1" in
    -i) shift; IPA="$1" ;;
    *) EXTRA+=("$1") ;;
  esac
  shift
done

SECRETS="_tools/secrets"
# Individual keys are named ApiKey_*, team keys AuthKey_*. The prefix is
# App Store Connect's own, and worth keeping: it is the only visible difference
# between a credential scoped to this app and one that owns the whole account.
KEY_ID="4LJJBK4Z86KR"
KEY_PATH="$SECRETS/ApiKey_${KEY_ID}.p8"

if [ ! -f "$KEY_PATH" ]; then
  echo "missing $KEY_PATH — decrypt the blackbox secrets first" >&2
  exit 1
fi
if [ ! -f "$IPA" ]; then
  echo "missing $IPA — run _tools/build-ios.sh first" >&2
  exit 1
fi

export APPLE_API_KEY_ID="$KEY_ID"
export APPLE_API_PRIVATE_KEY_PATH="$PWD/$KEY_PATH"
# Set even though this is an individual key. The REST API and altool disagree:
# the key's JWT must not name an issuer (it says `sub: user`), but altool
# documents --api-issuer as required with --api-key and refuses to upload
# without it. cux_ship tells the two apart by Apple's ApiKey_ filename prefix,
# so the issuer here only ever reaches altool.
export APPLE_API_ISSUER_ID="0f1ac0c6-ea92-4609-a2f0-c9b239198a75"

# cux_ship infers the project from the *git* root, which in this repository is
# the wrapper above authpass/ and holds no pubspec.yaml or ios/. So the values
# it would normally work out have to be passed.
BUNDLE_ID="design.codeux.authpass.ios"

# Read from the .ipa, not from pubspec.yaml. On CI the build number comes from
# git-buildnumber.sh rather than the pubspec, so the two disagree — and the
# number that matters is the one actually inside the binary. cux_ship checks it
# against what Apple reports, so a mismatch here fails the upload rather than
# publishing something mislabelled.
PLIST=$(mktemp "${TMPDIR:-/tmp}/authpass-ipa-plist.XXXXXX")
trap 'rm -f "$PLIST"' EXIT INT TERM
unzip -p "$IPA" 'Payload/*.app/Info.plist' > "$PLIST"
VERSION=$(plutil -extract CFBundleShortVersionString raw -o - "$PLIST")
BUILD_NUMBER=$(plutil -extract CFBundleVersion raw -o - "$PLIST")

if [ -z "$VERSION" ] || [ -z "$BUILD_NUMBER" ]; then
  echo "could not read the version out of $IPA" >&2
  exit 1
fi

# upload_to_testflight was called with no changelog, so the default here is no
# notes. cux_ship refuses to guess — absent is not the same answer as empty —
# and would otherwise look for a CHANGELOG.md at the *git* root, which in this
# repository is the wrapper above authpass/. Pass --changelog or
# --release-notes to override. Note this failure comes *after* the binary is
# uploaded and processed, so it costs a build number.
NOTES=()
case " ${EXTRA[*]-} " in
  *" --release-notes "* | *" --changelog "*) ;;
  *)
    EMPTY_NOTES=$(mktemp "${TMPDIR:-/tmp}/authpass-release-notes.XXXXXX")
    trap 'rm -f "$PLIST" "$EMPTY_NOTES"' EXIT INT TERM
    NOTES=(--release-notes "$EMPTY_NOTES")
    ;;
esac

echo "==> uploading $IPA"
echo "    bundle id    $BUNDLE_ID"
echo "    version      $VERSION ($BUILD_NUMBER)"
echo "    credential   individual key $KEY_ID, scoped to this app"

# --yes because there is no terminal on CI, and cux_ship treats "no terminal and
# no --yes" as a refusal rather than an assumed yes.
# not exec: the trap above still has a temp file to clean up
cd _tools/cux_ship
dart run cux_ship --yes appstore upload \
  --ipa "../../$IPA" \
  --bundle-id "$BUNDLE_ID" \
  --version-name "$VERSION" \
  --build-number "$BUILD_NUMBER" \
  ${NOTES+"${NOTES[@]}"} \
  ${EXTRA+"${EXTRA[@]}"}
