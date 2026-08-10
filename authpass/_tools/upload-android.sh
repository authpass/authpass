#!/bin/bash
# Uploads a signed .aab to Google Play.
#
#   _tools/upload-android.sh -f playstore|playstoredev [-t internal|beta] [-b buildnumber] [--dry-run]
#
# Replaces the three fastlane lanes in android/fastlane/Fastfile, which all did
# the same `upload_to_play_store` with the listing switched off. Metadata is
# opt-in here (`--metadata`), so the pile of skip_upload_* flags is gone.
#
# The credential is the Play service account already in blackbox — cux_ship
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

SERVICE_ACCOUNT="_tools/secrets/api-project-284252947431-83b019c3ca1e.json"

if [ ! -f "$SERVICE_ACCOUNT" ]; then
  echo "missing $SERVICE_ACCOUNT — decrypt the blackbox secrets first" >&2
  exit 1
fi
if [ ! -f "$AAB" ]; then
  echo "missing $AAB — build the $FLAVOR appbundle first" >&2
  exit 1
fi

# The JSON itself, not a path to it.
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON="$(cat "$SERVICE_ACCOUNT")"
export GOOGLE_PLAY_SERVICE_ACCOUNT_JSON

VERSION=$(grep '^version:' pubspec.yaml | head -1 | sed 's/version: *//' | cut -d+ -f1)

echo "==> uploading $AAB"
echo "    package      $PACKAGE"
echo "    track        $TRACK"
echo "    version      $VERSION${BUILD_NUMBER:+ ($BUILD_NUMBER)}"

# --yes because there is no terminal on CI, and cux_ship treats "no terminal and
# no --yes" as a refusal rather than an assumed yes. --build-number is checked
# against the versionCode inside the bundle, so a mismatch fails here rather
# than publishing something mislabelled.
cd _tools/cux_ship
exec dart run cux_ship --yes play upload \
  --aab "../../$AAB" \
  --package "$PACKAGE" \
  --track "$TRACK" \
  --version-name "$VERSION" \
  ${BUILD_NUMBER:+--build-number "$BUILD_NUMBER"} \
  ${EXTRA+"${EXTRA[@]}"}
