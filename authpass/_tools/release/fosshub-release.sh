#!/usr/bin/env bash

set -xeu

dir="${0%/*}"
cd $dir/../..

# Run under `cux_ship secrets exec`, which is where the token comes from:
#
#   _tools/ship.sh secrets exec --keystore upload --api-key upload -- \
#     _tools/release/fosshub-release.sh
token="${FOSSHUB_TOKEN:?run this under 'cux_ship secrets exec'}"
project_id='5f15fc217b2287584bc1e019'

tmpfile=$(mktemp)
curl https://data.authpass.app/data/artifact.download/.fosshub  | jq -c '. + {"publish": true, "isOldRelease": false}' >"$tmpfile"

jq < "$tmpfile"

curl -H "Content-Type: application/json" \
     -H "X-Auth-Key:${token}" \
     -d @"${tmpfile}" \
     --fail \
     -X POST https://api.fosshub.com/rest/projects/${project_id}/releases/

echo

rm "${tmpfile}"

echo
echo "All done. 👍️"
