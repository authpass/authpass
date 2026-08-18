#!/usr/bin/env bash

set -xeu

function _trap_exit {
    rc=$1
    lineno=$2
    command=$3
    if (( $rc )) ; then
        echo "Exiting with error ($rc) at line $lineno: $command"
    fi
    exit $rc
}

trap '_trap_exit $? $LINENO "$BASH_COMMAND"' EXIT

root="${0%/*}/.."

upload_file="$1"
# The name it is published under, when that is not the name on disk. snapcraft
# writes a file whose name says nothing about the version, and the download
# page is generated from these names.
remote_name="${2:-$( basename "${upload_file}" )}"

test -f "$upload_file"

set +x
set -v

# Checked *after* `set +x`, and without expanding the value. Under xtrace bash
# prints a command after expansion, so `: "${ARTIFACT_TOKEN:?...}"` above this
# line printed the token itself into the log — and these logs are public. That
# is how the token rotated this morning was public again by lunchtime. `:+set`
# expands to the word "set" or to nothing, never to the secret.
if [ -z "${ARTIFACT_TOKEN:+set}" ]; then
  echo "ARTIFACT_TOKEN is not set — run this under 'cux_ship secrets exec'" >&2
  exit 1
fi

token="${ARTIFACT_TOKEN}"

curl --request POST \
    --url https://data.authpass.app/data/artifact.push \
    --fail \
    --progress-bar \
    --form token="${token}" \
    --form upload="@${upload_file}" \
    --form filename="${remote_name}" | cat

