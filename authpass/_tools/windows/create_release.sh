#!/bin/bash

set -xeu

TARGET=build/_authpass/windows/release/authpass
SOURCE=build/windows/x64/runner/Release


dir="${0%/*}"
basedir="${dir}/../.."

VCLIBS="${basedir}/_tools/windows/assets/VCLibs/x64"

cd "$basedir"

pwd

echo "$VCLIBS"
ls "$VCLIBS"


rm -rf $TARGET
mkdir -p $TARGET

cp -ra $SOURCE/* $TARGET/

cp -v "${VCLIBS}"/* "${TARGET}/"

echo "Done."

