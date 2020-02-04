#!/usr/bin/env bash

set -eu

BLACKBOX_SECRET=${BLACKBOX_SECRET:-}

if test -z "${BLACKBOX_SECRET}" ; then
    echo "Require setting of BLACKBOX_SECRET"
fi

secret=.tmp/BLACKBOX_SECRET
mkdir .tmp

echo "${BLACKBOX_SECRET}" > .tmp/BLACKBOX_SECRET

if ! test -e "$secret" ; then
    echo "Require $secret file to contain blackbox private key."
    exit 1
fi

authpass/_tools/blackbox.go.linux cipostdeploy "$secret"

rm "$secret"

