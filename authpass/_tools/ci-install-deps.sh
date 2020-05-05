#!/usr/bin/env bash

set -exu

DEPS=${DEPS:-~/deps}

root="${0%/*}/.."
pwd

echo "Installing blackbox into $DEPS" 
mkdir -p ${DEPS}
pushd ${DEPS}

if test "${1}" == "ios" ; then
    curl -L -o blackbox.go.macos https://github.com/hpoul/blackbox/releases/download/golang-v0.1-cipostdeploy/blackbox.go.macos
    chmod +x blackbox.go.macos
    popd
    pushd "${root}"
    echo "$BLACKBOX_SECRET" | ${DEPS}/blackbox.go.macos cipostdeploy
else
#git clone https://github.com/mipmip/blackbox
    git clone https://github.com/StackExchange/blackbox
fi

popd

echo "Installing flutter into $DEPS"

cd ${root}

DEPS=${DEPS} _tools/install_flutter.sh

