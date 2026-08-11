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

# --- renamed copies, for embedding --------------------------------------------
#
# The app ends up carrying two Flutter engines: its own, and the extension safe
# one the appex needs. Apple rejects that as it stands, for three separate
# reasons at once (altool 90205, 90206, 90685):
#
#   - an appex may not contain a Frameworks directory, so both of these have to
#     be embedded in the *app* and merely linked from the extension;
#   - which puts them beside the app's own copies in one directory, where their
#     stock identifiers — io.flutter.flutter and io.flutter.flutter.app — are
#     duplicates of what is already there.
#
# So the embedded copies are renamed. The originals stay: the extension is
# compiled against Flutter.xcframework, because `import Flutter` resolves a
# clang module by the framework's own name and renaming it would mean rewriting
# every header that refers to itself. Only the *shipped* copy is renamed, and
# add_autofill_target.rb repoints the extension's binary at it after linking.
rename_framework() {
  local src="$1" dst="$2" old="$3" new="$4" identifier="$5"

  rm -rf "${dst}"
  cp -R "${src}" "${dst}"

  # The wrapper's signature covers the old names, and there is no point
  # re-signing something the app signs on copy.
  rm -rf "${dst}/_CodeSignature"

  # Counted from the plist rather than from the directories, which are not the
  # same thing — _CodeSignature is a directory too, and counting it walked off
  # the end of the array. `grep -o`, not `grep -c`: the json comes out as one
  # line, so counting lines finds every array exactly once and only the first
  # slice gets renamed. Which is a build that fails much later, in xcode, with
  # "Multiple commands produce Flutter.framework".
  local count
  count=$(plutil -convert json -o - "${dst}/Info.plist" | grep -o 'LibraryPath' | wc -l)
  # Every entry gets the same value, so which index is which slice does not
  # matter — only that the count matches.
  local i
  for ((i = 0; i < count; i++)); do
    plutil -replace "AvailableLibraries.${i}.LibraryPath" \
      -string "${new}.framework" "${dst}/Info.plist"
    plutil -replace "AvailableLibraries.${i}.BinaryPath" \
      -string "${new}.framework/${new}" "${dst}/Info.plist"
    # Dropped rather than renamed. The dSYM is named after the framework too,
    # so it collides in the same way, and the copy that is worth symbolicating
    # is the original Flutter.xcframework, which keeps its own.
    plutil -remove "AvailableLibraries.${i}.DebugSymbolsPath" "${dst}/Info.plist" 2>/dev/null || true
  done

  local slice framework
  for slice in "${dst}"/*/; do
    [ -d "${slice}${old}.framework" ] || continue
    rm -rf "${slice}dSYMs"
    framework="${slice}${new}.framework"
    mv "${slice}${old}.framework" "${framework}"
    mv "${framework}/${old}" "${framework}/${new}"
    # Signed for the old layout, and codesign refuses to overwrite a signature
    # it did not make. The app signs these on copy anyway.
    rm -rf "${framework}/_CodeSignature"
    plutil -replace CFBundleExecutable -string "${new}" "${framework}/Info.plist"
    plutil -replace CFBundleIdentifier -string "${identifier}" "${framework}/Info.plist"
    plutil -replace CFBundleName -string "${new}" "${framework}/Info.plist"
    # So the extension's rewritten load command resolves to this file.
    install_name_tool -id "@rpath/${new}.framework/${new}" "${framework}/${new}"

    # The signature carries an identifier of its own, and xcode re-signs
    # embedded frameworks with --preserve-metadata=identifier — so without this
    # the shipped copy keeps saying io.flutter.flutter however its Info.plist
    # reads, and the store rejects the mismatch (altool 90334). Removing it is
    # not enough on its own to be sure which identifier xcode then picks, so an
    # ad-hoc signature names the right one explicitly; the app replaces the
    # signature itself on copy.
    codesign --remove-signature "${framework}" 2>/dev/null || true
    codesign --force --sign - --identifier "${identifier}" "${framework}"
  done

  # Said here rather than discovered in xcode twenty minutes later. The leading
  # quote matters: App.framework is a suffix of AutofillApp.framework.
  if plutil -convert json -o - "${dst}/Info.plist" | grep -q "\"${old}\.framework"; then
    echo "rename left ${old}.framework behind in ${dst}/Info.plist" >&2
    exit 1
  fi
}

rename_framework "${OUTPUT}/${CONFIG}/Flutter.xcframework" \
  "${OUTPUT}/${CONFIG}/FlutterExt.xcframework" \
  Flutter FlutterExt design.codeux.authpass.flutterext

rename_framework "${OUTPUT}/${CONFIG}/App.xcframework" \
  "${OUTPUT}/${CONFIG}/AutofillApp.xcframework" \
  App AutofillApp design.codeux.authpass.autofillapp

# The Xcode target references build/framework/current, so switching between a
# device and a simulator build is running this script again rather than
# editing the project.
ln -sfn "${CONFIG}" "${OUTPUT}/current"

echo "frameworks in ${OUTPUT}/${CONFIG} (extension safe engine), current -> ${CONFIG}"
echo "  linked by the extension: Flutter.xcframework"
echo "  embedded in the app:     FlutterExt.xcframework, AutofillApp.xcframework"
