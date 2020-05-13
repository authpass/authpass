#!/usr/bin/env bash

set -xeu

dir="${0%/*}"
cd $dir/..

flavor="$1"

FLT=${FLT:-flutter}

DEPS=${DEPS:-~/deps}
if test -d ${DEPS}/flutter/bin ; then
    echo "Adding ${DEPS}/flutter/bin to PATH"
    export PATH=${DEPS}/flutter/bin:$PATH
fi

if test -e ../flutter/bin/flutter ; then
    FLT=../flutter/bin/flutter
fi

echo PATH:$PATH

ls ${DEPS}/flutter || echo "Flutter not found"

$FLT --version

if ! test -e ./git-buildnumber.sh ; then
    curl -s -O https://raw.githubusercontent.com/hpoul/git-buildnumber/stable/git-buildnumber.sh
    chmod +x git-buildnumber.sh
fi

buildnumber=${FORCE_BUILDNUMBER:-}
if test -z "$buildnumber" ; then
    git --version
    echo "=========="
    git status
    echo "=========="
    # cleanup uninteresting changes.
    git checkout -- ../.blackbox
    echo "DEBUG"
    git diff-index HEAD
    echo "diff-index: $?"
    buildnumber=`./git-buildnumber.sh generate`
else
	echo "WARNING: forcing buildnumber $buildnumber"
fi

echo "::set-output name=appbuildnumber::$buildnumber"

$FLT pub get
case "${flavor}" in
    ios)
        mkdir -p ~/.fastlane/spaceship
        $FLT build ios -t lib/env/production.dart --release --build-number $buildnumber --no-codesign
        cd ios
#        sudo fastlane run update_fastlane
        bundle exec fastlane beta
    ;;
    macos)
        # on mac os there is right now no --build-number argument :-(
        #flutter build macos -t lib/env/production.dart --release --build-number $buildnumber
#        sed -i .bak 's/^\(version: [0-9\\.]*\).*$/\1+'$buildnumber'/' pubspec.yaml
#        cat pubspec.yaml | grep version | grep "+$buildnumber$"  || (
#            echo "Buildnumber replacement was not successful." && exit 1
#        )
#        version=$(cat pubspec.yaml | grep version | sed "s/version: *//" | cut -d'+' -f 1)
#        sed -i .bak "s/_DEFAULT_VERSION = '.*'/_DEFAULT_VERSION = '$version'/" lib/env/_base.dart
#        sed -i .bak "s/_DEFAULT_BUILD_NUMBER = [0-9]*/_DEFAULT_BUILD_NUMBER = $buildnumber/" lib/env/_base.dart
#        $FLT pub get
        $FLT build macos -v -t lib/env/production.dart --release --build-number $buildnumber
        echo
        echo
        echo 'Now opening workspace in xcode. Click Build -> Archive'
        echo
        open macos/Runner.xcworkspace
    ;;
    samsungapps | huawei | sideload)
        $FLT build -v apk -t lib/env/production.dart --release --build-number $buildnumber --flavor ${flavor}
        apkpath="build/app/outputs/apk/${flavor}/release"
        apk="${apkpath}/app-${flavor}-release.apk"
        outputfilename="authpass-${flavor}-${buildnumber}.apk"
        outputpath="${apkpath}/${outputfilename}"
        echo "Copying to output apk ${apk}"
        cp ${apk} ${outputpath}
        echo "::set-output name=outputfilename::${outputfilename}"
        echo "::set-output name=outputpath::${outputpath}"
    ;;
    playstoredev)
        $FLT build -v appbundle -t lib/env/production.dart --release --build-number $buildnumber --flavor playstoredev
        cd android
        fastlane dev
    ;;
    android)
        $FLT build -v appbundle -t lib/env/production.dart --release --build-number $buildnumber --flavor playstore
        cd android
        fastlane beta
    ;;
    *)
        echo "Unsupported command ${flavor}"
    ;;
esac

