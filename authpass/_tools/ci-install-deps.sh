#!/usr/bin/env bash

set -exu

DEPS=${DEPS:-~/deps}

root="${0%/*}/.."
pwd

echo "Installing blackbox into $DEPS" 
mkdir -p ${DEPS}
pushd ${DEPS}

if test "${1:-}" == "ios" ; then
    curl -L -o blackbox.go.macos https://github.com/hpoul/blackbox/releases/download/golang-v0.1-cipostdeploy/blackbox.go.macos
    chmod +x blackbox.go.macos
    popd
    pushd "${root}"
    if ! test -z "${BLACKBOX_SECRET:-}" ; then
        echo "$BLACKBOX_SECRET" | ${DEPS}/blackbox.go.macos cipostdeploy
    fi
elif test "${1:-}" == "windows" ; then
    curl -L -o blackbox.go.windows.amd64.exe https://github.com/hpoul/blackbox/releases/download/golang-v0.1-cipostdeploy/blackbox.go.windows.amd64.exe
    #chmod +x blackbox.go.macos
    popd
    pushd "${root}"
    if ! test -z "${BLACKBOX_SECRET:-}" ; then
        echo "$BLACKBOX_SECRET" | ${DEPS}/blackbox.go.windows.amd64.exe cipostdeploy
    fi
#    popd

#    pushd ${DEPS}
#    git clone https://github.com/flutter/flutter.git
#    cd flutter/bin
#    ./flutter upgrade
#    ./flutter config --enable-windows-desktop
#    cd "${DEPS}/flutter/dev/tools"
#    "${DEPS}/flutter/bin/flutter" pub get
#
#    exit 0
else
    if ! test -z "${BLACKBOX_SECRET:-}" ; then
        blackbox='blackbox.go.linux.amd64'
        curl -L -o ${blackbox} https://github.com/hpoul/blackbox/releases/download/golang-v0.1-cipostdeploy/blackbox.go.linux.amd64

        chmod +x ${blackbox}

        popd
        pushd "${root}"

        echo "${BLACKBOX_SECRET}" | ${DEPS}/${blackbox} cipostdeploy -

    fi
fi

popd

echo "Installing flutter into $DEPS"

cd ${root}

DEPS=${DEPS} _tools/install_flutter.sh

