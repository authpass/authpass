#!/bin/bash
# Uploads a signed .pkg to App Store Connect.
#
#   _tools/upload-macos.sh [-p build/macos/pkg/authpass.pkg] [--dry-run]
#
# The macOS counterpart of upload-ios.sh, and uses the same credential: the
# individual API key scoped to the AuthPass apps. See that script for why the
# release pipeline holds nothing stronger.

set -euo pipefail

cd "${0%/*}/.."

PKG=""
ARCHIVE="build/macos/authpass.xcarchive"
EXTRA=()
while [ $# -gt 0 ]; do
  case "$1" in
    -p) shift; PKG="$1" ;;
    -a) shift; ARCHIVE="$1" ;;
    *) EXTRA+=("$1") ;;
  esac
  shift
done

# The export directory holds exactly one .pkg, whose name follows the scheme
# rather than the product, so glob rather than hardcode.
if [ -z "$PKG" ]; then
  PKG=$(ls build/macos/pkg/*.pkg 2>/dev/null | head -1 || true)
fi

# The key comes from the environment, which is where `cux_ship secrets exec`
# puts it:
#
#   cux_ship secrets exec --api-key upload -- _tools/upload-macos.sh
#
# Nothing is exported here any more, including the issuer — see upload-ios.sh
# for why altool needs one even for an individual key.
: "${APPLE_API_KEY_ID:?run this under 'cux_ship secrets exec'}"
: "${APPLE_API_PRIVATE_KEY_PATH:?not set by secrets exec}"

if [ -z "$PKG" ] || [ ! -f "$PKG" ]; then
  echo "no .pkg found — run _tools/build-macos.sh first" >&2
  exit 1
fi

# Explicit for the reasons in upload-ios.sh, and for one more: this is not the
# iOS bundle id with a suffix, it is a different app record entirely, so
# inference reading the wrong project would be plausible rather than obviously
# broken.
BUNDLE_ID="design.codeux.authpass"

# Read from the archive the .pkg was exported from, in the same run. A .pkg
# keeps its Info.plist inside a compressed payload, so reading it back means
# expanding the whole thing; the archive holds the same built app as a plain
# bundle. Still the built artifact, not pubspec.yaml — on CI the build number
# comes from git-buildnumber.sh and the two disagree.
APP_PLIST=$(ls -d "$ARCHIVE"/Products/Applications/*.app 2>/dev/null | head -1)/Contents/Info.plist
if [ ! -f "$APP_PLIST" ]; then
  echo "could not find the built app in $ARCHIVE" >&2
  exit 1
fi
VERSION=$(plutil -extract CFBundleShortVersionString raw -o - "$APP_PLIST")
BUILD_NUMBER=$(plutil -extract CFBundleVersion raw -o - "$APP_PLIST")

if [ -z "$VERSION" ] || [ -z "$BUILD_NUMBER" ]; then
  echo "could not read the version out of $APP_PLIST" >&2
  exit 1
fi

# See upload-ios.sh. macOS keeps its own build numbers, so this asks about the
# macos platform of the same app rather than iOS.
echo "==> checking build $BUILD_NUMBER is newer than what Apple holds"
# Through ship.sh, for its dart resolution — see upload-ios.sh.
NEWEST=$(./_tools/ship.sh appstore build-number \
  --bundle-id "$BUNDLE_ID" --platform macos 2>/dev/null | tail -1 | tr -dc '0-9')
if [ -n "$NEWEST" ] && [ "$BUILD_NUMBER" -le "$NEWEST" ] \
   && [ "${AUTHPASS_ALLOW_REUSED_BUILD_NUMBER:-}" != "1" ]; then
  echo "    newest on App Store Connect is $NEWEST" >&2
  echo "build $BUILD_NUMBER is not newer than $NEWEST — Apple would reject it" >&2
  echo "  Rebuild with a higher -b, or set AUTHPASS_ALLOW_REUSED_BUILD_NUMBER=1" >&2
  exit 1
fi
echo "    newest is ${NEWEST:-unknown}, ours is $BUILD_NUMBER"

# See upload-ios.sh: no notes by default, matching what fastlane did.
NOTES=()
case " ${EXTRA[*]-} " in
  *" --release-notes "* | *" --changelog "*) ;;
  *)
    EMPTY_NOTES=$(mktemp "${TMPDIR:-/tmp}/authpass-release-notes.XXXXXX")
    trap 'rm -f "$EMPTY_NOTES"' EXIT INT TERM
    NOTES=(--release-notes "$EMPTY_NOTES")
    ;;
esac

echo "==> uploading $PKG"
echo "    bundle id    $BUNDLE_ID"
echo "    version      $VERSION ($BUILD_NUMBER)"
echo "    credential   $APPLE_API_KEY_ID, scoped to this app"

# --yes: see upload-ios.sh.
# not exec: the trap above still has a temp file to clean up.
# Paths stay ../../-relative: ship.sh runs cux_ship from _tools/cux_ship.
./_tools/ship.sh --yes appstore upload \
  --platform macos \
  --ipa "../../$PKG" \
  --bundle-id "$BUNDLE_ID" \
  --version-name "$VERSION" \
  --build-number "$BUILD_NUMBER" \
  ${NOTES+"${NOTES[@]}"} \
  ${EXTRA+"${EXTRA[@]}"}
