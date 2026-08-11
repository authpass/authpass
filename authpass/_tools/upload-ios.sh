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

# The key comes from the environment, which is where `cux_ship secrets exec`
# puts it:
#
#   cux_ship secrets exec --api-key upload -- _tools/upload-ios.sh
#
# Nothing is exported here any more. The three variables below used to be set by
# this script from a decrypted file; they now arrive already set, and the file
# lives in a temp directory removed however the run ends.
#
# The issuer is one of them, and is set even for an individual key: the REST API
# and altool disagree — the key's JWT must not name an issuer, but altool
# documents --api-issuer as required with --api-key and refuses without it.
# cux_ship tells the two kinds apart by the declared `kind`, which decides the
# ApiKey_/AuthKey_ filename, so the issuer only ever reaches altool.
: "${APPLE_API_KEY_ID:?run this under 'cux_ship secrets exec'}"
: "${APPLE_API_PRIVATE_KEY_PATH:?not set by secrets exec}"

if [ ! -f "$IPA" ]; then
  echo "missing $IPA — run _tools/build-ios.sh first" >&2
  exit 1
fi

# Explicit, though .cux-ship.yaml now points cux_ship at authpass/ and it could
# read this out of the Xcode project. A release script naming the app it is
# about to publish to is worth the duplication: it is printed in the summary
# below, and it means a wrong app-dir cannot quietly redirect an upload.
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

# Refuse a build number the store already has, before spending the upload on
# it. Apple rejects a duplicate anyway, but only after the whole binary has
# gone up and been processed — minutes later, and the number is burnt either
# way. Build numbers have to increase, so "not greater than the newest" is the
# same question asked cheaply.
#
# Set AUTHPASS_ALLOW_REUSED_BUILD_NUMBER=1 to skip, e.g. when deliberately
# re-uploading after a processing failure.
echo "==> checking build $BUILD_NUMBER is newer than what Apple holds"
NEWEST=$(cd _tools/cux_ship && dart run cux_ship appstore build-number \
  --bundle-id "$BUNDLE_ID" 2>/dev/null | tail -1 | tr -dc '0-9')
if [ -n "$NEWEST" ] && [ "$BUILD_NUMBER" -le "$NEWEST" ] \
   && [ "${AUTHPASS_ALLOW_REUSED_BUILD_NUMBER:-}" != "1" ]; then
  echo "    newest on App Store Connect is $NEWEST" >&2
  echo "build $BUILD_NUMBER is not newer than $NEWEST — Apple would reject it" >&2
  echo "  Rebuild with a higher -b, or set AUTHPASS_ALLOW_REUSED_BUILD_NUMBER=1" >&2
  exit 1
fi
echo "    newest is ${NEWEST:-unknown}, ours is $BUILD_NUMBER"

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
echo "    credential   $APPLE_API_KEY_ID, scoped to this app"

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
