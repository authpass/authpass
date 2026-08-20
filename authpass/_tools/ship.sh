#!/usr/bin/env bash
# Runs the release tooling.
#
#   _tools/ship.sh deps install
#   _tools/ship.sh secrets place
#   _tools/ship.sh secrets exec --keystore upload --api-key upload -- _tools/…
#
# Three things it settles, all of which were repeated at every call site before.
#
# The Dart to use is the one inside the pinned Flutter SDK. The runners ship no
# Dart of their own, so a bare `dart` works only if some earlier step happened
# to put one on PATH — and which SDK that is would then depend on step order.
# Falls back to PATH for a developer machine, where flutter usually is on it.
#
# `dart run` resolves a package from the directory it runs in, and for cux_ship
# that has to be the _tools/cux_ship wrapper: the app's own pubspec does not
# depend on it, deliberately.
#
# `secrets exec` runs its child at the repository root, whatever this script
# had to cd into to start it. Paths passed after `--` are repo-relative.

set -euo pipefail

DEPS=${DEPS:-~/deps}

dart="${DEPS}/flutter/bin/dart"
if [ ! -x "$dart" ]; then
  dart=dart
fi

cd "${0%/*}/cux_ship"

# Resolved on demand rather than in a separate install step, so a workflow that
# needs one credential and no build does not have to know about this directory.
if [ ! -f .dart_tool/package_config.json ]; then
  "$dart" pub get >&2
fi

# The build number allocator. A separate package from cux_ship, resolved by the
# same lockfile here so there is exactly one pin. Replaces the
# git-buildnumber.sh release.sh used to curl from a mutable branch and execute.
# Runs from this directory, which is inside the repository; git does not care
# where inside, and `generate` prints the number on stdout and everything else
# on stderr, same as the script it replaces.
if [ "${1:-}" = "buildnumber" ]; then
  shift
  exec "$dart" run cux_buildnumber:git_buildnumber "$@"
fi

exec "$dart" run cux_ship "$@"
