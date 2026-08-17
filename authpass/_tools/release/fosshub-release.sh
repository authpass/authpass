#!/usr/bin/env bash

set -xeu

dir="${0%/*}"
cd $dir/../..

# Run under `cux_ship secrets exec`, which is where the token comes from:
#
#   _tools/ship.sh secrets exec --keystore upload --api-key upload -- \
#     _tools/release/fosshub-release.sh
# Under `set -x` bash prints a command after expansion, so assigning or testing
# this with the value in the line prints the token. Checked expansion-free, and
# the curl below runs with xtrace off.
if [ -z "${FOSSHUB_TOKEN:+set}" ]; then
  echo "FOSSHUB_TOKEN is not set — run this under 'cux_ship secrets exec'" >&2
  exit 1
fi
set +x
token="${FOSSHUB_TOKEN}"
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
