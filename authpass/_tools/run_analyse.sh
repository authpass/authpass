#!/bin/bash

set -xeu

root="${0%/*}/.."

pushd $root

pushd ..
reporoot="$(pwd)"
popd

_tools/flutter_run.sh pub global activate string_literal_finder
_tools/flutter_run.sh pub global run \
  string_literal_finder \
  --path lib \
  --exclude-path l10n/ \
  --annotations-output-file "${reporoot}/annotations.json" --annotations-path-root "${reporoot}" \
  --metrics-output-file metrics.json || true

cat "${reporoot}/annotations.json" | jq -c '.[:50]' > "${reporoot}/annotations_first_50.json"
total_annotations=$(cat "${reporoot}/annotations.json" | jq -c '. | length')

echo "::set-output name=total_annotations::${total_annotations}"

curl --request POST \
    --url https://data.authpass.app/data/artifact.push \
    --fail \
    --form token=$( cat _tools/secrets/artifact_token.txt ) \
    --form metrics="$( cat metrics.json )"

