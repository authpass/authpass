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
# Deliberately unset: an individual key has no issuer id, and cux_ship uses its
# absence to pick the `sub: user` JWT claim instead of `iss`. Setting it to a
# team issuer produces a 401 that explains nothing.
unset APPLE_API_ISSUER_ID

# cux_ship infers the project from the *git* root, which in this repository is
# the wrapper above authpass/ and holds no pubspec.yaml or ios/. So the values
# it would normally work out have to be passed.
BUNDLE_ID="design.codeux.authpass.ios"
VERSION=$(grep '^version:' pubspec.yaml | head -1 | sed 's/version: *//' | cut -d+ -f1)
BUILD_NUMBER=$(grep '^version:' pubspec.yaml | head -1 | sed 's/version: *//' | cut -d+ -f2)

echo "==> uploading $IPA"
echo "    bundle id    $BUNDLE_ID"
echo "    version      $VERSION ($BUILD_NUMBER)"
echo "    credential   individual key $KEY_ID, scoped to this app"

cd _tools/cux_ship
exec dart run cux_ship appstore upload \
  --ipa "../../$IPA" \
  --bundle-id "$BUNDLE_ID" \
  --version-name "$VERSION" \
  --build-number "$BUILD_NUMBER" \
  ${EXTRA+"${EXTRA[@]}"}
