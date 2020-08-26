#!/usr/bin/env bash

set -xeu

upload_file=$1

curl --request POST \
    --url https://data.authpass.app/data/artifact.push \
    --fail \
    --form token="$( cat authpass/_tools/secrets/artifact_token.txt )" \
    --form upload="@${upload_file}" \
    --form filename="$( basename "${upload_file}" )"

