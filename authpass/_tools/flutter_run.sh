#!/bin/bash

set -xeu

root="${0%/*}/.."

packages="$root/.dart_tool/package_config.json"

if ! test -f "$packages" ; then
	echo "Unable to find $packages"
	exit 1
fi

flutter=`cat "$packages" | grep "^flutter:" | sed "s/^flutter://" | sed "s/^file:\/\///" | sed "s/\/packages.*//" | sed "s/\/C:\//\/c\//"`
flutter=`cat $packages | jq -r '.packages[] | select(.name == "flutter").rootUri' | sed "s/^file:\/\///" | sed "s/\/packages.*//" | sed "s/\/C:\//\/c\//"`

if ! [[ $flutter == "/"* ]] ; then
	flutter="${root}/$flutter"
fi

if ! test -e "$flutter/bin/flutter" ; then
	echo "Unable to find flutter in $flutter"
	exit 1
fi

echo flutter: $flutter

if test "$1" == "dart" ; then
  shift
  "$flutter/bin/dart" "$@"
else

  "$flutter/bin/flutter" $@
fi

