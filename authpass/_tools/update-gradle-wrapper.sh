#!/usr/bin/env bash

# run from inside authpass/android to update gradle wrapper to latest version.

set -xeu

json=$(curl -sf https://services.gradle.org/versions/current) v=$(echo $json | jq -r '.version')
sha=$(curl -sfL $(echo $json | jq -r '.checksumUrl' | sed 's/bin/all/'))
./gradlew wrapper --distribution-type all --gradle-distribution-sha256-sum "$sha" --gradle-version "$v"


# or one liner:
# json=$(curl -sf https://services.gradle.org/versions/current) && v=$(echo $json | jq -r '.version') && sha=$(curl -sfL $(echo $json | jq -r '.checksumUrl' | sed 's/bin/all/')) && ./gradlew wrapper --distribution-type all --gradle-distribution-sha256-sum "$sha" --gradle-version "$v"

