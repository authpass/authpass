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
  # Both streams via files, replayed to stderr afterwards — two jobs at once.
  # Diagnostics: callers capture stdout with a command substitution, so a
  # dying allocator's last words would otherwise go nowhere; this replays
  # them, and no run can hide how it died. Workaround: on windows a dart
  # child of a dart inheritStdio parent dies writing to the inherited console
  # handle (dart-lang SDK issue pending; minimal repro on the
  # windows-deps-b2110d4 branch), and writing to a *file* sidesteps it. If
  # the SDK fixes that, the diagnostic half still earns the block its place.
  bn_out=$(mktemp)
  bn_err=$(mktemp)
  set +e
  "$dart" run cux_buildnumber:git_buildnumber "$@" >"$bn_out" 2>"$bn_err"
  bn_code=$?
  set -e
  cat "$bn_err" >&2
  if [ "$bn_code" -ne 0 ]; then
    {
      echo "== buildnumber exited $bn_code =="
      echo "== captured stdout =="
      cat "$bn_out"
      echo "== end =="
    } >&2
  fi
  cat "$bn_out"
  exit "$bn_code"
fi

exec "$dart" run cux_ship "$@"
