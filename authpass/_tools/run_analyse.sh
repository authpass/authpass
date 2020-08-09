#!/bin/bash

set -xeu

root="${0%/*}/.."

pushd $root

_tools/flutter_run.sh pub global activate string_literal_finder
_tools/flutter_run.sh pub global run \
  string_literal_finder \
  --path lib \
  --exclude-path l10n/ \
  --metrics-output-file metrics.json || true

curl --request POST \
    --url https://data.authpass.app/data/artifact.push \
    --fail \
    --form token=$( cat _tools/secrets/artifact_token.txt ) \
    --form metrics="$( cat metrics.json )"

