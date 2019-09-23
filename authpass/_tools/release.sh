#!/usr/bin/env bash

set -xeu

dir="${0%/*}"
cd $dir/..

if test -d flutter/bin ; then
  echo "Adding flutter/bin to PATH"
  export PATH=$PATH:flutter/bin
fi
DEPS=${DEPS:-~/deps}
if test -d ${DEPS}/flutter/bin ; then
    echo "Adding ${DEPS}/flutter/bin to PATH"
    export PATH=${DEPS}/flutter/bin:$PATH
fi

echo PATH:$PATH

ls ${DEPS}/flutter || echo "Flutter not found"

flutter --version

if ! test -e ./git-buildnumber.sh ; then
    curl -s -O https://raw.githubusercontent.com/hpoul/git-buildnumber/v1.0/git-buildnumber.sh
    chmod +x git-buildnumber.sh
fi

buildnumber=${FORCE_BUILDNUMBER:-}
if test -z "$buildnumber" ; then
    git status
	buildnumber=`./git-buildnumber.sh generate`
else
	echo "WARNING: forcing buildnumber $buildnumber"
fi

case "$1" in
    ios)
        flutter build ios -t lib/env/production.dart --release --build-number $buildnumber --no-codesign
        cd ios
        sudo fastlane run update_fastlane
        fastlane beta
    ;;
    macos)
        # on mac os there is right now no --build-number argument :-(
        #flutter build macos -t lib/env/production.dart --release --build-number $buildnumber
        sed -i .bak 's/^\(version: [0-9\\.]*\).*$/\1+'$buildnumber'/' pubspec.yaml
        cat pubspec.yaml | grep version | grep "+$buildnumber$"  || (
            echo "Buildnumber replacement was not successful." && exit 1
        )
        flutter pub get
        flutter build macos -v -t lib/env/production.dart --release
    ;;
    samsungapps)
        export GRADLE_USER_HOME=$(pwd)/_tools/secrets/gradle_home
        flutter build -v apk -t lib/env/production.dart --release --build-number $buildnumber --flavor samsungapps
    ;;
    android)
        export GRADLE_USER_HOME=$(pwd)/_tools/secrets/gradle_home
        flutter build -v appbundle -t lib/env/production.dart --release --build-number $buildnumber --flavor playstore
        cd android
        fastlane beta
    ;;
    *)
        echo "Unsupported command $1"
    ;;
esac




