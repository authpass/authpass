#!/usr/bin/env bash

set -xeu

dir="${0%/*}"
cd $dir/..

flavor="$1"

FLT=${FLT:-}
AUTHPASS_SKIP_FASTLANE=${AUTHPASS_SKIP_FASTLANE:-}

if test -z "$FLT" && test -f .packages ; then
    FLT=_tools/flutter_run.sh
else
    FLT=flutter
fi

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
    samsungapps | huawei | sideload | amazon)
        version=$(cat pubspec.yaml | grep version | cut -d' ' -f2 | cut -d'+' -f1)
        $FLT build -v apk -t lib/env/production.dart --release --build-number $buildnumber --flavor ${flavor}
        apkpath="build/app/outputs/apk/${flavor}/release"
        apk="${apkpath}/app-${flavor}-release.apk"
        outputfilename="authpass-${flavor}-${version}_${buildnumber}.apk"
        outputpath="${apkpath}/${outputfilename}"
        echo "Copying to output apk ${apk}"
        cp ${apk} ${outputpath}
        echo "::set-output name=outputfilename::${outputfilename}"
        echo "::set-output name=outputpath::${outputpath}"
    ;;
    playstoredev)
        $FLT build -v appbundle -t lib/env/production.dart --release --build-number $buildnumber --flavor playstoredev
        cd android
        bundle install
        echo "Check if we are in a beta branch ${GITHUB_REF}"
        exitCode=success
        if [[ "${GITHUB_REF:-}" == *"beta"* ]] ; then
          echo "Pushing to beta."
          bundle exec fastlane devbeta || exitCode=$?
        else
          echo "Pushing to dev"
          bundle exec fastlane dev || exitCode=$?
        fi

        if [[ "${exitCode}" != "success" ]] ; then
          echo "fastlane failed. maybe this buildnumber was uploaded before? exitCode:$exitCode"
        fi
    ;;
    android)
        $FLT build -v appbundle -t lib/env/production.dart --release --build-number $buildnumber --flavor playstore
        cd android
        bundle install
        bundle exec fastlane beta
    ;;
    linux)
        version=$(cat pubspec.yaml | grep version | cut -d' ' -f2 | cut -d'+' -f1)
        $FLT build -v ${flavor} -t lib/env/production.dart --release --dart-define=AUTHPASS_VERSION=$version --dart-define=AUTHPASS_BUILD_NUMBER=$buildnumber --dart-define=AUTHPASS_PACKAGE_NAME=design.codeux.authpass.${flavor}

        outputfilename="authpass-${flavor}-${version}_${buildnumber}.tar.gz"
        outputpath="build/${flavor}/release/${outputfilename}"
        echo "${version}+${buildnumber}" > build/${flavor}/release/version.txt
        echo "${version}+${buildnumber}" > build/${flavor}/release/bundle/version.txt
        tar czvf ${outputpath} --transform "s/^build.*bundle/authpass/" build/${flavor}/release/bundle
        echo "::set-output name=appversion::${version}"
        echo "::set-output name=outputfilename::${outputfilename}"
        echo "::set-output name=outputpath::${outputpath}"
    ;;
    windows)
        version=$(cat pubspec.yaml | grep version | cut -d' ' -f2 | cut -d'+' -f1)
        $FLT build -v ${flavor} -t lib/env/production.dart --release --dart-define=AUTHPASS_VERSION=$version --dart-define=AUTHPASS_BUILD_NUMBER=$buildnumber --dart-define=AUTHPASS_PACKAGE_NAME=design.codeux.authpass.${flavor}

        _tools/windows/create_release.sh

        "/c/Program Files (x86)/Inno Setup 6/ISCC.exe" -DMyAppVersion=${version}_${buildnumber} _tools/windows/AuthPassSetup.iss

        outputfilename="AuthPass-setup-${version}_${buildnumber}.exe"
        outputpath="build/_authpass/windows/setup/${outputfilename}"
        #echo "${version}+${buildnumber}" > build/${flavor}/release/version.txt
        #echo "${version}+${buildnumber}" > build/${flavor}/release/bundle/version.txt
        #tar czvf ${outputpath} --transform "s/^build.*bundle/authpass/" build/${flavor}/release/bundle
        echo "::set-output name=appversion::${version}"
        echo "::set-output name=outputfilename::${outputfilename}"
        echo "::set-output name=outputpath::${outputpath}"
    ;;
    *)
        echo "Unsupported command ${flavor}"
    ;;
esac

