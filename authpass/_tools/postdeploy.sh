#!/usr/bin/env bash

set -eu

BLACKBOX_SECRET=${BLACKBOX_SECRET:-}

if test -z "${BLACKBOX_SECRET}" ; then
    echo "Require setting of BLACKBOX_SECRET"
    exit 1
fi

tmpdir=$(mktemp -d)
blackbox='blackbox.go.linux.amd64'

curl -L -o ${tmpdir}/${blackbox} https://github.com/hpoul/blackbox/releases/download/golang-v0.1-cipostdeploy/blackbox.go.linux.amd64

chmod +x ${tmpdir}/${blackbox}

echo "${BLACKBOX_SECRET}" | ${tmpdir}/${blackbox} cipostdeploy -

rm -rf ${tmpdir}
