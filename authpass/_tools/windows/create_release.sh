#!/bin/bash

set -xeu

VS_REDIST_BASE_WIN="C:\Program Files (x86)\Microsoft Visual Studio\2019"
VS_REDIST_BASE=$(cygpath "$VS_REDIST_BASE_WIN")
# find "${VS_REDIST_BASE}"


VS_REDIST_BASE_WIN="C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Redist\MSVC"
VS_REDIST_BASE=$(cygpath "$VS_REDIST_BASE_WIN")

if ! test -d "${VS_REDIST_BASE}" ; then
	echo "Not available in ${VS_REDIST_BASE} trying Community."
	VS_REDIST_BASE_WIN="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Redist\MSVC"
	VS_REDIST_BASE=$(cygpath "$VS_REDIST_BASE_WIN")
fi

#VS_REDIST_WIN="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Redist\MSVC\14.26.28720\x64\Microsoft.VC142.CRT"
#VS_REDIST=$(cygpath "$VS_REDIST_WIN")

VS_REDIST_FILES=(
	vcruntime140_1.dll
	msvcp140.dll
	vcruntime140.dll
)

# echo "REDIST"
# find "${VS_REDIST_BASE}"

# echo
echo

VS_REDIST=`find "${VS_REDIST_BASE}" -path '**[0-9]/x64/M**' -iname "${VS_REDIST_FILES[0]}" | grep -v onecore | head -n 1`

if test -z "${VS_REDIST}" ; then
  echo "UNABLE TO FIND VS REDIST (${VS_REDIST_FILES[0]})"
  find "${VS_REDIST_BASE}"
  exit 1
fi

VS_REDIST=`dirname "${VS_REDIST}"`

echo "USING $VS_REDIST"

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

