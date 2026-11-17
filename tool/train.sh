#!/usr/bin/env bash
# Orders the steps of a release.
#
#   tool/train.sh status --build 2196 --release 1.9.13
#   tool/train.sh production --build 2196 --release 1.9.13 --dry-run
#   tool/train.sh production --build 2196 --release 1.9.13
#
# The table of where a release goes is `.cux-train.yaml` beside this script's
# parent — the repository root, which is where this runs from and where
# `.cux-ship.yaml`, `CHANGELOG.md` and `store/` already live. The train reads
# the destination table and the `uploaded/` and `promoted/` tags from there,
# and both have to be the same directory or a run reports one repository's
# progress against another's list of destinations.
#
# **At the root rather than in `authpass/_tools/`, and that is a new
# convention here.** Every existing release script lives under
# `authpass/_tools/`, and CLAUDE.md tells readers to run Flutter commands from
# `authpass/`. The train is not a Flutter command: it is about what the
# *repository* shipped, which is why the files it reads are the ones already
# at this level. The donor repository has the same shape — `tool/` at a root
# holding `.cux-ship.yaml` and `CHANGELOG.md` and no `pubspec.yaml` — and
# typing the same path in both is most of the point.
#
# The Dart to use and the directory to resolve from are settled exactly as
# `authpass/_tools/ship.sh` settles them, for the same reasons; see its header.
#
# ## This does not work yet, and here is precisely what is missing
#
# Both prerequisites are in the `cux_ship` repository, which is where
# `docs/design/authpass-on-the-train.md` §8 says the cost of step 1 actually
# lives. Neither is a change to this repository.
#
# 1. **`cux_ship` has never published `lib/provenance.dart`.** `cux_train`
#    imports it for the tag writing that every record depends on. It exists on
#    that repository's `main` and in none of its releases, up to and including
#    4.5.0-dev.8 — so a consumer resolves `cux_train` successfully and then
#    fails to compile it. Verified on 16 November 2026 by resolving
#    `cux_train` as a git dependency in a throwaway package: `dart pub get`
#    exits 0, `dart run` reports "Error when reading
#    '…/cux_ship-4.5.0-dev.8/lib/provenance.dart': No such file or directory".
#    That repository's "Resolve as a git dependency" check builds a consumer of
#    `cux_ship` only, which is why this is not already red there.
#
# 2. **`cux_train` requires `cux_ship ^4.5.0-dev.8`, and this repository pins
#    `^3.6.0`.** They cannot share a lockfile, and §8 wants one wrapper and one
#    pin rather than a second of each:
#
#        Because every version of cux_train from git depends on
#        cux_ship ^4.5.0-dev.8 and consumer_probe depends on cux_ship ^3.6.0,
#        cux_train from git is forbidden.
#
#    So adding `cux_train` to `authpass/_tools/cux_ship/pubspec.yaml` today
#    would move the tooling that ships this app to the stores from 3.6.0 to a
#    **prerelease** two majors up — and §8's own step 2 says that pinning a
#    prerelease in a repository whose CI ships to stores is the thing to
#    avoid. The wrapper is deliberately left alone until that is decided: were
#    the dependency added now, `dart pub get` there would fail and `ship.sh`
#    would stop working for every existing release task.
#
# Until both are settled, the table can still be read with a `cux_train`
# checked out beside this repository:
#
#   dart --packages=<cux_ship>/.dart_tool/package_config.json \
#        package:cux_train/cli.dart status --build N --release X.Y.Z
#
# which is how `.cux-train.yaml` was checked against the real nineteen
# destinations.

set -euo pipefail

DEPS=${DEPS:-~/deps}

dart="${DEPS}/flutter/bin/dart"
if [ ! -x "$dart" ]; then
  dart=dart
fi

# The repository root: the train reads the table and the refs from one place,
# and this script is the thing that guarantees they are the same place however
# it was invoked.
root=$(cd "${0%/*}/.." && pwd)

# The same wrapper `cux_ship` and `cux_buildnumber` resolve from — one
# directory, one lockfile, one pin. §8: once `cux_train` imports `cux_ship`,
# and it does, a single lockfile is what *forces* the two to agree about the
# tag namespaces the finish rule and the evidence model are both built on.
wrapper="$root/authpass/_tools/cux_ship"

cd "$wrapper"

if [ ! -f .dart_tool/package_config.json ]; then
  "$dart" pub get >&2
fi

# **The space after the colon is not optional.** `package_config.json` is
# written pretty-printed, so the first version of this grep — `"name":"…"` with
# no space — never matched and the guard refused even once the dependency was
# there. A check that cannot pass is worse than no check: it says the thing it
# names is broken when it is not.
if ! grep -q '"name": *"cux_train"' .dart_tool/package_config.json 2>/dev/null
then
  cat >&2 <<EOF
train: cux_train is not resolvable from $wrapper.

It is declared in that directory's pubspec.yaml as a git dependency. If this
is a fresh checkout, resolve it:

  (cd $wrapper && dart pub upgrade)

If that fails, the pin and the dependency have come apart — cux_train needs a
cux_ship with lib/provenance.dart in it, which is 4.5.0-dev.9 or later, and
both are resolved by this one lockfile.
EOF
  exit 1
fi

# From the repository root, not from the wrapper: `--table` defaults to a
# sibling of the working directory, and the refs are read from it too.
cd "$root"
exec "$dart" --packages="$wrapper/.dart_tool/package_config.json" \
  package:cux_train/cli.dart "$@"
