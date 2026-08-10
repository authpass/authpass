#!/bin/bash
# Builds the headless module as frameworks the AuthPassAutofill extension can
# embed, and swaps in the extension safe engine.
#
# `flutter build ios-framework` always emits the regular Flutter.xcframework.
# App extensions have to link the extension safe variant instead — it is built
# with -fapplication-extension and keeps out of the UIApplication APIs that are
# unavailable (and rejected at review) in an appex.
#
#   ./build_ios_framework.sh [Release|Debug|Profile]
#
# Use Release. A debug engine in an extension exceeds the memory cap on its own
# (flutter#135243), which makes any measurement meaningless.

set -xeuo pipefail

cd "${0%/*}"

CONFIG="${1:-Release}"
OUTPUT="build/framework"

case "${CONFIG}" in
Release) FLUTTER_ARGS=(--release --no-debug --no-profile) ; ENGINE_DIR=ios-release ;;
Profile) FLUTTER_ARGS=(--profile --no-debug --no-release) ; ENGINE_DIR=ios-profile ;;
Debug) FLUTTER_ARGS=(--debug --no-profile --no-release) ; ENGINE_DIR=ios ;;
*)
  echo "unknown configuration: ${CONFIG}" >&2
  exit 1
  ;;
esac

# --no-codesign because the app target signs the embedded frameworks on copy
# anyway ("CodeSignOnCopy"), and signing here only introduces a way to fail:
# two development certificates with the same common name in the keychain make
# the automatic choice ambiguous, which stops the build.
flutter build ios-framework "${FLUTTER_ARGS[@]}" --no-codesign --output="${OUTPUT}"

FLUTTER_ROOT="$(dirname "$(dirname "$(readlink -f "$(command -v flutter)")")")"
EXTENSION_SAFE="${FLUTTER_ROOT}/bin/cache/artifacts/engine/${ENGINE_DIR}/extension_safe/Flutter.xcframework"

if [ ! -d "${EXTENSION_SAFE}" ]; then
  echo "extension safe engine not found at ${EXTENSION_SAFE}" >&2
  echo "run 'flutter precache --ios' and try again" >&2
  exit 1
fi

rm -rf "${OUTPUT}/${CONFIG}/Flutter.xcframework"
cp -R "${EXTENSION_SAFE}" "${OUTPUT}/${CONFIG}/Flutter.xcframework"

echo "frameworks in ${OUTPUT}/${CONFIG} (extension safe engine)"
