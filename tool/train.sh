#!/usr/bin/env bash
# Orders the steps of a release.
#
#   tool/train.sh status --build 2196 --release 1.9.13
#   tool/train.sh internal --build 2196 --release 1.9.13 --dry-run
#   tool/train.sh production --build 2196 --release 1.9.13 --dry-run
#   tool/train.sh production --build 2196 --release 1.9.13
#
# `--build` is required and never guessed. The number for the commit about to
# be released comes from the allocator CI uses, which is idempotent per commit:
#
#   authpass/_tools/ship.sh buildnumber generate
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
# The Dart to use and the directory to resolve from are settled as
# `authpass/_tools/ship.sh` settles them, for the same reasons; see its header.
# One difference: `ship.sh` goes through `dart run`, which re-resolves when the
# pubspec moved. This starts `package:cux_train/cli.dart` from the wrapper's
# `package_config.json` directly, so it checks for a stale one itself, below.
#
# ## What it runs, and what a run writes
#
# `cux_train` is not on pub.dev. It is a git dependency of the wrapper in
# `authpass/_tools/cux_ship`, pinned to a commit, beside `cux_ship` itself —
# one directory, one lockfile. It imports `package:cux_ship/provenance.dart`,
# which first shipped in cux_ship 4.5.0-dev.9, so the two move together.
#
# **The train still uploads, promotes and publishes nothing at a
# destination.** Every destination step in `.cux-train.yaml` is `manual`,
# `wait` or `none`: a person acts, or CI does and the train reads until the
# build turns up.
#
# One step is neither, and it is the one to know about. The table's `dispatch`
# is `git push origin HEAD:stable`, which `internal` spawns — so that verb sets
# every CI build going, and reaches users at the snap's `edge` channel, the web
# app and packagecloud. It asks first and names them; `--yes` skips the asking.
#
# Before either, `internal` runs the table's `gates` — four checks in
# `tool/train-gate.sh` that read this repository and spend nothing, which is
# why `--dry-run` runs them as well. The first one to exit non-zero stops the
# run before the question and before the push. One of them refuses today on
# purpose: F-Droid has no changelog file for the pubspec's versionCode, and
# `.cux-train.yaml` argues there why that is the answer rather than something
# to work around.
#
# Otherwise what a run without `--dry-run` writes is git tags, pushed to origin
# — a `promoted/<destination>/<stage>/v…+N` record for each step a person
# confirms (`refused/…` for one they turn down) — and, once every destination
# is recorded, the table's `finish` step, which tags and pushes `vX.Y.Z`.
# Nothing the `internal` wait sees is recorded: a read says the destination
# holds the build, where a tag would say somebody claims to have put it there.

set -euo pipefail

DEPS=${DEPS:-~/deps}

dart="${DEPS}/flutter/bin/dart"
if [ ! -x "$dart" ]; then
  dart=dart
fi

# The repository root: the train reads the table and the refs from one place,
# and this script is the thing that guarantees they are the same place however
# it was invoked. `dirname` rather than `${0%/*}`, which is the script's own
# name when there is no slash in it (`cd tool && bash train.sh`); CDPATH
# emptied so `cd` neither searches it nor prints where it went.
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)

# The same wrapper `cux_ship` and `cux_buildnumber` resolve from — one
# directory, one lockfile, one pin. §8: once `cux_train` imports `cux_ship`,
# and it does, a single lockfile is what *forces* the two to agree about the
# tag namespaces the finish rule and the evidence model are both built on.
wrapper="$root/authpass/_tools/cux_ship"

cd "$wrapper"

# Resolved when there is no package_config.json, and again when the pubspec or
# the lockfile is newer than it. The second half is what a moved pin needs:
# after a pull that changes `cux_train`'s ref the old package_config.json still
# names the old commit, and nothing below would notice — the release would be
# walked by the code the pin was moved away from. `pub get` always rewrites
# package_config.json, so this runs once per change rather than every time.
config=.dart_tool/package_config.json
if [ ! -f "$config" ] || [ pubspec.yaml -nt "$config" ] \
   || [ pubspec.lock -nt "$config" ]; then
  "$dart" pub get >&2
fi

# **The space after the colon is not optional.** `package_config.json` is
# written pretty-printed, so the first version of this grep — `"name":"…"` with
# no space — never matched and the guard refused even once the dependency was
# there. A check that cannot pass is worse than no check: it says the thing it
# names is broken when it is not.
if ! grep -q '"name": *"cux_train"' "$config" 2>/dev/null
then
  cat >&2 <<MSG
train: cux_train is not resolvable from $wrapper.

It is declared in that directory's pubspec.yaml as a git dependency, and
\`dart pub get\` there has just run or was not needed, so the pin and the
dependency have come apart — cux_train needs a cux_ship with
lib/provenance.dart in it, which is 4.5.0-dev.9 or later, and both are
resolved by that one lockfile. To see what pub says:

  (cd "$wrapper" && dart pub get)
MSG
  exit 1
fi

# From the repository root, not from the wrapper: `--table` defaults to
# `.cux-train.yaml` in the working directory, and the refs are read from it
# too.
cd "$root"
exec "$dart" --packages="$wrapper/$config" \
  package:cux_train/cli.dart "$@"
