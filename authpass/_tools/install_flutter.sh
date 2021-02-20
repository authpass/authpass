#!/usr/bin/env bash

# Download the required flutter version and extracts it into $DEPS

# debug log
set -xeu

path="${0%/*}"

DEPS=${DEPS} # must be defined by environment.

# shellcheck source=./_flutter_version.sh
source "${path}/_flutter_version.sh"

#FLUTTER_MAC_CHANNEL='dev'
#FLUTTER_MAC_VERSION='v1.13.6-dev'
#FLUTTER_MAC_CHANNEL="${FLUTTER_CHANNEL}"
#FLUTTER_MAC_VERSION="${FLUTTER_VERSION}"

FLUTTER_PLATFORM=macos
FLUTTER_EXT=zip

platform="$(uname -s)"
case "${platform}" in
    Linux*)     FLUTTER_PLATFORM=linux
                FLUTTER_EXT=tar.xz
                FLUTTER_VERSION=${FLUTTER_LINUX_VERSION}
                FLUTTER_SHA256=${FLUTTER_LINUX_SHA256}
                FLUTTER_ARCHIVE=${FLUTTER_LINUX_ARCHIVE}
    ;;
    Darwin*)    FLUTTER_PLATFORM=macos
                FLUTTER_VERSION=${FLUTTER_MACOS_VERSION}
                FLUTTER_SHA256=${FLUTTER_MACOS_SHA256}
                FLUTTER_ARCHIVE=${FLUTTER_MACOS_ARCHIVE}
    ;;
    MINGW*)     FLUTTER_PLATFORM=windows
                FLUTTER_VERSION=${FLUTTER_WINDOWS_VERSION}
                FLUTTER_SHA256=${FLUTTER_WINDOWS_SHA256}
                FLUTTER_ARCHIVE=${FLUTTER_WINDOWS_ARCHIVE}
    ;;
    *)          echo "Unknown platform ${platform}" ; exit 1 ;;
esac

pushd "${DEPS}"
echo "Using flutter for ${FLUTTER_PLATFORM}: ${FLUTTER_VERSION}."
echo "Downloading ${FLUTTER_URL}${FLUTTER_ARCHIVE}"

f="flutter.${FLUTTER_EXT}"
curl -o ${f} "${FLUTTER_URL}${FLUTTER_ARCHIVE}"

if command -v shasum ; then
    checksum=$(shasum -a 256 ${f} | cut -f1 -d' ')
elif command -v sha256sum ; then
    checksum=$(sha256sum ${f} | cut -f1 -d' ')
else
    echo "Can't find command for sha256"
    exit 1
fi

if test "${checksum}" != "${FLUTTER_SHA256}" ; then
    echo "Invalid checksum. ${checksum} vs ${FLUTTER_SHA256}"
    exit 1
fi

if test "${FLUTTER_EXT}" = "zip" ; then
    unzip flutter.zip | tail
else
    tar xf flutter.${FLUTTER_EXT}
fi

# for some weird reason gen_l10n.dart fails if not manually running pub get in that directory.
# https://github.com/flutter/flutter/issues/65023
pushd flutter/dev/tools
"../../../flutter/bin/flutter" pub get

popd # flutter/dev/tools

popd # $DEPS

pushd "$path"/..

# install dependencies, subsequent commands can simply use _tools/flutter_run.sh
"${DEPS}/flutter/bin/flutter" pub get

export PATH=${DEPS}/flutter/bin:$PATH

