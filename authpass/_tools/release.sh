#!/usr/bin/env bash

set -xeu

dir="${0%/*}"
cd $dir/..

flavor="$1"

FLT=${FLT:-}

if test -z "$FLT" && test -d .dart_tool ; then
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

buildnumber=${FORCE_BUILDNUMBER:-}
if test -z "$buildnumber" ; then
    git --version
    echo "=========="
    git status
    echo "=========="
    # cleanup uninteresting changes.
    git checkout -- lib/l10n-generated
    echo "DEBUG"
    git diff-index HEAD
    echo "diff-index: $?"
    # workaround if for some reason pubspec.lock changes on windows
    # https://github.com/dart-lang/pub/issues/3012
    case "${flavor}" in
    windows | msix | windowsportable)
      git diff
      git checkout -- pubspec.lock
      ;;
    esac
    # The Dart port, resolved by _tools/cux_ship's lockfile like the rest of
    # the release tooling. Replaces a git-buildnumber.sh this script curled
    # from a mutable branch and executed — unpinned, on a runner holding push
    # credentials. GIT_PUSH_REMOTE and GIT_SSH_COMMAND pass through from the
    # environment exactly as they did to the shell script.
    buildnumber=$(./_tools/ship.sh buildnumber generate)
else
	echo "WARNING: forcing buildnumber $buildnumber"
fi

echo "::set-output name=appbuildnumber::$buildnumber"

$FLT pub get
case "${flavor}" in
    ios)
        # Build only. This whole script runs under `keychain exec` (see
        # .github/workflows/ios.yaml), which since cux_ship 3.0.0 strips the
        # sops identity from its child — so a nested `secrets exec` in here
        # can decrypt nothing, and that is the design: the archive cannot hold
        # a key that could create or revoke signing material, and the build
        # environment cannot mint one either. The upload is the workflow step
        # after this one, holding the one credential it needs and nothing
        # signing-related. See docs/apple-signing.md.
        ./_tools/build-ios.sh -t lib/env/production.dart -b $buildnumber
    ;;
    macos)
        # As for ios: build only, the upload is its own workflow step.
        ./_tools/build-macos.sh -t lib/env/production.dart -b $buildnumber
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
        echo "Check if we are in a beta branch ${GITHUB_REF}"
        track=internal
        if [[ "${GITHUB_REF:-}" == *"beta"* || "${GITHUB_REF:-}" == *"stable"* ]] ; then
          track=beta
        fi
        echo "Pushing to ${track}"
        # Deliberately not fatal: re-running a release for a buildnumber Play
        # already holds fails, and that is a no-op rather than a broken build.
        exitCode=success
        ./_tools/upload-android.sh -f playstoredev -t "${track}" -b $buildnumber || exitCode=$?

        if [[ "${exitCode}" != "success" ]] ; then
          echo "upload failed. maybe this buildnumber was uploaded before? exitCode:$exitCode"
        fi
    ;;
    android | playstore)
        $FLT build -v appbundle -t lib/env/production.dart --release --build-number $buildnumber --flavor playstore
        ./_tools/upload-android.sh -f playstore -t internal -b $buildnumber
    ;;
    linux)
        version=$(cat pubspec.yaml | grep version | cut -d' ' -f2 | cut -d'+' -f1)
        $FLT build -v ${flavor} -t lib/env/production.dart --release --dart-define=AUTHPASS_VERSION=$version --dart-define=AUTHPASS_BUILD_NUMBER=$buildnumber --dart-define=AUTHPASS_PACKAGE_NAME=design.codeux.authpass.${flavor}
        arch=x64

        outputfilename="authpass-${flavor}-${version}_${buildnumber}.tar.gz"
        outputpath="build/${flavor}/${arch}/release/${outputfilename}"
        echo "${version}+${buildnumber}" > build/${flavor}/${arch}/release/version.txt
        echo "${version}+${buildnumber}" > build/${flavor}/${arch}/release/bundle/version.txt
        tar czvf ${outputpath} --transform "s/^build.*bundle/authpass/" build/${flavor}/x64/release/bundle
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
    windowsportable)
        version=$(cat pubspec.yaml | grep version | cut -d' ' -f2 | cut -d'+' -f1)
        $FLT build -v windows -t lib/env/production.dart --release \
          --dart-define=AUTHPASS_VERSION=$version \
          --dart-define=AUTHPASS_BUILD_NUMBER=$buildnumber \
          --dart-define=AUTHPASS_PACKAGE_NAME=design.codeux.authpass.${flavor} \
          --dart-define=AUTHPASS_PORTABLE=true \
          --dart-define=AUTHPASS_WIN_AUTOUPDATE=false

        _tools/windows/create_release.sh

        version="${version}" buildnumber="${buildnumber}" \
          _tools/windows/create_portable.sh
    ;;
    msix)
        version=$(cat pubspec.yaml | grep version | cut -d' ' -f2 | cut -d'+' -f1)
        $FLT build -v windows -t lib/env/production.dart --release \
            --dart-define=AUTHPASS_VERSION=$version \
            --dart-define=AUTHPASS_BUILD_NUMBER=$buildnumber \
            --dart-define=AUTHPASS_PACKAGE_NAME=design.codeux.authpass.${flavor} \
            --dart-define=AUTHPASS_WIN_AUTOUPDATE=false
        git checkout -- pubspec.lock
        $FLT pub run msix:create --version "${version}.0"

        outputdir="build/windows/x64/runner/Release"

        outputfilename="authpass-${version}_${buildnumber}.msix"
        outputpath="${outputdir}/${outputfilename}"
        cp "${outputdir}/authpass.msix" "${outputpath}"

        #echo "${version}+${buildnumber}" > build/${flavor}/release/version.txt
        #echo "${version}+${buildnumber}" > build/${flavor}/release/bundle/version.txt
        #tar czvf ${outputpath} --transform "s/^build.*bundle/authpass/" build/${flavor}/release/bundle
        echo "::set-output name=appversion::${version}"
        echo "::set-output name=outputfilename::${outputfilename}"
        echo "::set-output name=outputpath::${outputpath}"
    ;;
    web)
        version=$(cat pubspec.yaml | grep version | cut -d' ' -f2 | cut -d'+' -f1)
        $FLT build web -t lib/env/web.dart --release \
            --dart-define=AUTHPASS_VERSION=$version \
            --dart-define=AUTHPASS_BUILD_NUMBER=$buildnumber \
            --dart-define=AUTHPASS_PACKAGE_NAME=design.codeux.authpass.${flavor}
        echo "::set-output name=appversion::${version}"
    ;;
    *)
        echo "Unsupported command ${flavor}"
    ;;
esac

