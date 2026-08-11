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

: "${ARTIFACT_TOKEN:?run this under 'cux_ship secrets exec'}"
test -f "$upload_file"

set +x
set -v

token="${ARTIFACT_TOKEN}"

curl --request POST \
    --url https://data.authpass.app/data/artifact.push \
    --fail \
    --progress-bar \
    --form token="${token}" \
    --form upload="@${upload_file}" \
    --form filename="$( basename "${upload_file}" )" | cat

