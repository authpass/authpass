#!/bin/bash

set -xeu

root="${0%/*}/.."

pushd $root

pushd ..
reporoot="$(pwd)"
popd

#_tools/flutter_run.sh pub global activate string_literal_finder
_tools/flutter_run.sh pub run \
  string_literal_finder \
  --path lib \
  --exclude-path l10n/ \
  --annotations-output-file "${reporoot}/annotations.json" --annotations-path-root "${reporoot}" \
  --metrics-output-file metrics.json || true

cat "${reporoot}/annotations.json" | jq -c '.[:50]' >"${reporoot}/annotations_first_50.json"
cat "${reporoot}/annotations.json" | jq -c '[.[] | {message, annotation_level: .level, start_line: .line.start, end_line: .line.end, start_column: .column.start, end_column: .column.end, path} | if .start_line == .end_line then . else del(.start_column) | del(.end_column) end]' >"${reporoot}/annotations_github.json"

total_annotations=$(cat "${reporoot}/annotations.json" | jq -c '. | length')

echo "::set-output name=total_annotations::${total_annotations}"

tokenfile="_tools/secrets/artifact_token.txt"

if test -f "${tokenfile}"; then
  curl --request POST \
    --url https://data.authpass.app/data/artifact.push \
    --fail \
    --form token=$(cat "${tokenfile}") \
    --form metrics="$(cat metrics.json)"
fi

fail=()

_tools/flutter_run.sh analyze || fail+=('analyze')

_tools/flutter_run.sh format --set-exit-if-changed $(find . -name "*.dart" \! -name "generated_plugin_registrant.dart" \! -path "./.dart_tool*" | xargs) || fail+=('format')

if [ ${#fail[@]} -ne 0 ]; then
  echo "Errors: ${fail[*]}"
  exit 1
fi

