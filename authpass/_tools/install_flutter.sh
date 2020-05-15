#!/usr/bin/env bash

set -e
# debug log
set -xeu

DEPS=${DEPS} # must be defined by environment.

FLUTTER_CHANNEL='stable'
#FLUTTER_VERSION=v1.2.1-stable
#FLUTTER_VERSION='v1.7.8+hotfix.4-stable'
FLUTTER_CHANNEL='stable'
#FLUTTER_VERSION='v1.9.5-dev'
#FLUTTER_VERSION='v1.9.7-dev'
#FLUTTER_VERSION='v1.10.0-dev'
FLUTTER_VERSION='v1.12.13+hotfix.5-stable'

FLUTTER_CHANNEL='stable'
#FLUTTER_VERSION='v1.15.17-beta'
#FLUTTER_VERSION='1.17.0-dev.3.1-beta'
#FLUTTER_VERSION='1.17.0-3.2.pre-beta'
FLUTTER_VERSION='1.17.1-stable'

#FLUTTER_MAC_CHANNEL='dev'
#FLUTTER_MAC_VERSION='v1.13.6-dev'
FLUTTER_MAC_CHANNEL="${FLUTTER_CHANNEL}"
FLUTTER_MAC_VERSION="${FLUTTER_VERSION}"

FLUTTER_PLATFORM=macos
FLUTTER_EXT=zip

platform="$(uname -s)"
case "${platform}" in
    Linux*)     FLUTTER_PLATFORM=linux ; FLUTTER_EXT=tar.xz ;;
    Darwin*)    FLUTTER_PLATFORM=macos ; FLUTTER_VERSION=${FLUTTER_MAC_VERSION} ; FLUTTER_CHANNEL=${FLUTTER_MAC_CHANNEL} ;;
    *)          echo "Unknown platform ${platform}" ; exit 1 ;;
esac

pushd ${DEPS}
echo "Downloading ${FLUTTER_PLATFORM}/flutter_${FLUTTER_PLATFORM}_${FLUTTER_VERSION}.${FLUTTER_EXT}"
curl -o flutter.${FLUTTER_EXT} https://storage.googleapis.com/flutter_infra/releases/${FLUTTER_CHANNEL}/${FLUTTER_PLATFORM}/flutter_${FLUTTER_PLATFORM}_${FLUTTER_VERSION}.${FLUTTER_EXT}

if test "${FLUTTER_EXT}" = "zip" ; then
    unzip flutter.zip | tail
else
    tar xf flutter.${FLUTTER_EXT}
fi

popd

export PATH=${DEPS}/flutter/bin:$PATH

