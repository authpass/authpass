#!/bin/bash
# Uploads a signed .aab to Google Play.
#
#   _tools/upload-android.sh -f playstore|playstoredev [-t internal|beta] [-b buildnumber] [--dry-run]
#
# Replaces the three fastlane lanes in android/fastlane/Fastfile, which all did
# the same `upload_to_play_store` with the listing switched off. Metadata is
# opt-in here (`--metadata`), so the pile of skip_upload_* flags is gone.
#
# The credential is the Play service account in secrets/release.yaml — cux_ship
# takes it as JSON in the environment rather than as a path.

set -euo pipefail

cd "${0%/*}/.."

FLAVOR=""
TRACK="internal"
BUILD_NUMBER=""
EXTRA=()
while [ $# -gt 0 ]; do
  case "$1" in
    -f) shift; FLAVOR="$1" ;;
    -t) shift; TRACK="$1" ;;
    -b) shift; BUILD_NUMBER="$1" ;;
    *) EXTRA+=("$1") ;;
  esac
  shift
done

case "$FLAVOR" in
  playstore)
    PACKAGE="design.codeux.authpass"
    AAB="build/app/outputs/bundle/playstoreRelease/app-playstore-release.aab"
    ;;
  playstoredev)
    # A separate listing, not a track of the main one.
    PACKAGE="design.codeux.authpass.dev"
    AAB="build/app/outputs/bundle/playstoredevRelease/app-playstoredev-release.aab"
    ;;
  *)
    echo "usage: $0 -f playstore|playstoredev [-t internal|beta] [-b buildnumber]" >&2
    exit 64
    ;;
esac

# The service account comes from the environment, which is where
# `cux_ship secrets exec` puts it:
#
#   cux_ship secrets exec --keystore upload -- _tools/upload-android.sh
#
# As a value rather than a path: cux_ship's Play client reads the JSON itself,
# so nothing has to be written to disk for this one.
: "${GOOGLE_PLAY_SERVICE_ACCOUNT_JSON:?run this under 'cux_ship secrets exec'}"

VERSION=$(grep '^version:' pubspec.yaml | head -1 | sed 's/version: *//' | cut -d+ -f1)

# Refuse a versionCode Play already has, before spending the upload on it. Play
# rejects a duplicate anyway, but only after the whole bundle has gone up — and
# on the playstoredev lane that failure is deliberately tolerated, so it would
# otherwise pass by unnoticed. Only checked when a build number was given;
# without -b there is nothing to compare yet.
#
# This checks the number passed in, not the one inside the bundle — reading a
# versionCode out of an .aab needs bundletool. cux_ship checks the bundle
# itself, so a disagreement between the two still fails, just later. The iOS
# and macOS uploaders read theirs out of the built artifact directly.
#
# Set AUTHPASS_ALLOW_REUSED_BUILD_NUMBER=1 to skip.
if [ -n "$BUILD_NUMBER" ]; then
  echo "==> checking versionCode $BUILD_NUMBER is newer than what Play holds"
  NEWEST=$(cd _tools/cux_ship && dart run cux_ship play version-code \
    --package "$PACKAGE" --track "$TRACK" 2>/dev/null | tail -1 | tr -dc '0-9')
  if [ -n "$NEWEST" ] && [ "$BUILD_NUMBER" -le "$NEWEST" ] \
     && [ "${AUTHPASS_ALLOW_REUSED_BUILD_NUMBER:-}" != "1" ]; then
    echo "    newest on \"$TRACK\" is $NEWEST" >&2
    echo "versionCode $BUILD_NUMBER is not newer than $NEWEST — Play would reject it" >&2
    echo "  Rebuild with a higher -b, or set AUTHPASS_ALLOW_REUSED_BUILD_NUMBER=1" >&2
    exit 1
  fi
  echo "    newest is ${NEWEST:-unknown}, ours is $BUILD_NUMBER"
fi

# The lanes this replaced all passed skip_upload_changelogs, so the default here
# is no notes. cux_ship refuses to guess — absent is not the same answer as
# empty — and an empty file is how you say "leave the listing alone", which
# keeps whatever Play already shows. Pass --changelog or --release-notes to
# override — cux_ship would otherwise read the CHANGELOG.md at the repository
# root, which is a real file and would start publishing notes that no release
# has ever published.
NOTES=()
case " ${EXTRA[*]-} " in
  *" --release-notes "* | *" --changelog "*) ;;
  *)
    EMPTY_NOTES=$(mktemp "${TMPDIR:-/tmp}/authpass-release-notes.XXXXXX")
    trap 'rm -f "$EMPTY_NOTES"' EXIT INT TERM
    NOTES=(--release-notes "$EMPTY_NOTES")
    ;;
esac

echo "==> uploading $AAB"
echo "    package      $PACKAGE"
echo "    track        $TRACK"
echo "    version      $VERSION${BUILD_NUMBER:+ ($BUILD_NUMBER)}"

# --yes because there is no terminal on CI, and cux_ship treats "no terminal and
# no --yes" as a refusal rather than an assumed yes. --build-number is checked
# against the versionCode inside the bundle, so a mismatch fails here rather
# than publishing something mislabelled.
cd _tools/cux_ship
# not exec: the trap above still has an empty notes file to clean up
dart run cux_ship --yes play upload \
  --aab "../../$AAB" \
  --package "$PACKAGE" \
  --track "$TRACK" \
  --version-name "$VERSION" \
  ${BUILD_NUMBER:+--build-number "$BUILD_NUMBER"} \
  ${NOTES+"${NOTES[@]}"} \
  ${EXTRA+"${EXTRA[@]}"}
