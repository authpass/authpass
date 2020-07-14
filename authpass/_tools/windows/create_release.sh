#!/bin/bash

set -xeu


VS_REDIST_WIN="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Redist\MSVC\14.26.28720\x64\Microsoft.VC142.CRT"
VS_REDIST=$(cygpath "$VS_REDIST_WIN")

VS_REDIST_FILES=(
	msvcp140.dll
	vcruntime140.dll
	vcruntime140_1.dll
)

TARGET=build/_authpass/windows/release/authpass
SOURCE=build/windows/runner/Release

dir="${0%/*}"
basedir="${dir}/../../"

cd $basedir

pwd

echo $VS_REDIST

rm -rf $TARGET
mkdir -p $TARGET

cp -ra $SOURCE/* $TARGET/

for file in ${VS_REDIST_FILES[@]}; do
	echo Copy $file
	cp "${VS_REDIST}/$file" "$TARGET/"
done

echo "Done."

