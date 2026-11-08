#!/bin/bash

set -xeu

root="${0%/*}/.."

pushd $root

pushd ..
reporoot="$(pwd)"
popd

# string_literal_finder is not a dev dependency — 2.x wants analyzer ^14 and
# analytics_event_gen pins it below 11, so the two cannot share a resolution.
# See the comment in pubspec.yaml. Activating it keeps the CLI on its own
# resolution, and the analyzer resolves the IDE plugin from the `plugins:` entry
# in analysis_options.yaml independently of both.
#
# Pinned deliberately: an unpinned activate would move the gate under the build.
STRING_LITERAL_FINDER_VERSION=2.0.0-dev.2
_tools/flutter_run.sh pub global activate \
  string_literal_finder "${STRING_LITERAL_FINDER_VERSION}"

# Exits 1 when it finds more literals than --max-literals allows, which is how
# this gates. Zero is also the default, but say it, because the number is the
# point of the check and a silent default is a poor place to keep it.
#
# Not `|| true` any more: the count reached zero on 2026-09-15, so a new literal
# is now a build failure rather than a line in a report nobody reads. If that
# becomes unworkable, --baseline records the current set and fails only on
# additions; do that rather than restoring `|| true`.
#
# The exit code is deferred to the `fail` array at the bottom so that the
# annotations and metrics below are still written and pushed on a failure —
# those are what the GitHub check annotations are built from.
string_literals=0
_tools/flutter_run.sh pub global run \
  string_literal_finder \
  --path lib \
  --exclude-path l10n/ \
  --max-literals=0 \
  --cache-dir .dart_tool/string_literal_finder \
  --annotations-output-file "${reporoot}/annotations.json" --annotations-path-root "${reporoot}" \
  --metrics-output-file metrics.json || string_literals=$?

cat "${reporoot}/annotations.json" | jq -c '.[:50]' >"${reporoot}/annotations_first_50.json"
cat "${reporoot}/annotations.json" | jq -c '[.[] | {message, annotation_level: .level, start_line: .line.start, end_line: .line.end, start_column: .column.start, end_column: .column.end, path} | if .start_line == .end_line then . else del(.start_column) | del(.end_column) end]' >"${reporoot}/annotations_github.json"

total_annotations=$(cat "${reporoot}/annotations.json" | jq -c '. | length')

echo "::set-output name=total_annotations::${total_annotations}"

# From the environment, via `cux_ship secrets exec`. Absent on a fork's pull
# request, where there is no key to decrypt it — so this stays optional rather
# than failing a build that has nothing to push with.
# `:+set` rather than `:-`, and xtrace off before the value is used: this runs
# under `set -x`, which prints commands after expansion.
if test -n "${ARTIFACT_TOKEN:+set}"; then
  set +x
  curl --request POST \
    --url https://data.authpass.app/data/artifact.push \
    --fail \
    --form token="${ARTIFACT_TOKEN}" \
    --form metrics="$(cat metrics.json)"
fi

fail=()

# 1 is "literals found", and anything else (2 bad arguments, 70 analysis error)
# is a broken check rather than a dirty tree — both have to fail the build, but
# they are worth telling apart in the log.
if [ "${string_literals}" -eq 1 ]; then
  fail+=('string_literals')
elif [ "${string_literals}" -ne 0 ]; then
  fail+=("string_literal_finder (exit ${string_literals})")
fi

_tools/flutter_run.sh pub get

_tools/flutter_run.sh analyze || fail+=('analyze')

# `.claude/*` is excluded because agent worktrees live under `.claude/worktrees`
# — a whole second checkout, submodules and all, inside this one. CI never has
# one, but `dart format` rewrites the files it is handed rather than only
# reporting on them, so running this locally reformatted eighty files belonging
# to unrelated in-flight branches.
_tools/flutter_run.sh dart format --set-exit-if-changed $(find . -name "*.dart"  \! -name "secrets.dart" \! -name "generated_plugin_registrant.dart" \! -path "./.dart_tool*" \! -path "./.claude/*" \! -path "./lib/l10n-generated/*" | xargs) || fail+=('format')

if [ ${#fail[@]} -ne 0 ]; then
  echo "Errors: ${fail[*]}"
  exit 1
fi

