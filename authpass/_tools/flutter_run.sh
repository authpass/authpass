#!/bin/bash

set -xeu

root="${0%/*}/.."

packages="$root/.packages"

if ! test -f "$packages" ; then
	echo "Unable to find $packages"
	exit 1
fi

flutter=`cat "$packages" | grep "^flutter:" | sed "s/^flutter:file:\/\///" | sed "s/\/packages.*//"`

if ! test -e "$flutter/bin/flutter" ; then
	echo "Unable to find flutter in $flutter"
	exit 1
fi

echo flutter: $flutter

"$flutter/bin/flutter" $@

