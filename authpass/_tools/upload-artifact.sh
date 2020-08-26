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

token_file="${root}/_tools/secrets/artifact_token.txt"
upload_file="$1"

test -f "$token_file"
test -f "$upload_file"

set +x
set -v

token=$( cat "${token_file}" )

curl --request POST \
    --url https://data.authpass.app/data/artifact.push \
    --fail \
    --progress-bar \
    --form token="${token}" \
    --form upload="@${upload_file}" \
    --form filename="$( basename "${upload_file}" )" | cat

