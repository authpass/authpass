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

# Which half of a release this run does. `all` — the default, and what every
# platform but ios and macos ever uses — is the behaviour this script has always
# had. The Apple path splits it into two CI steps, for two reasons:
#
#   - a failed upload is retried without rebuilding, which is the split
#     `build.sh`/`upload.sh` already have one level down; and
#   - the build step then never needs to decrypt anything, so the sops identity
#     can be kept out of the environment `keychain exec` hands to xcodebuild.
#     That second one is what made cux_ship 3.0.0 adoptable here: it strips
#     SOPS_AGE_KEY from that child unconditionally, and before the split the
#     upload ran *inside* that child and would have lost the ability to
#     decrypt. The two now run as siblings, which is what 3.0.0 asks for.
RELEASE_PHASE=${RELEASE_PHASE:-all}
case "${RELEASE_PHASE}" in
    all|build|upload) ;;
    *) echo "RELEASE_PHASE is '${RELEASE_PHASE}' — expected all, build or upload" >&2 ; exit 1 ;;
esac
does_phase() { test "${RELEASE_PHASE}" = all -o "${RELEASE_PHASE}" = "$1" ; }

# The two steps must publish the *same* build number, and only the first one
# allocates. `ship.sh buildnumber generate` pushes a ref to claim it, so calling
# it twice would claim two and upload an artifact whose CFBundleVersion is not
# the one Apple was told about.
#
# Carried through the workspace rather than a step output: GitHub disabled
# `::set-output` in 2023, so the line below that still uses it has been doing
# nothing for a while.
buildnumber_record=build/release-buildnumber.txt

buildnumber=${FORCE_BUILDNUMBER:-}
if test -z "$buildnumber" && test "${RELEASE_PHASE}" = upload ; then
    # The upload phase never allocates. If the record is missing the build step
    # did not get far enough to write one, and falling through to `generate`
    # below would claim a *second* number — shipping an artifact whose
    # CFBundleVersion is not the one Apple was told about. That is the failure
    # this record exists to prevent, so refuse rather than paper over it.
    #
    # Refusing here also keeps the error legible: ci-release.sh leaves
    # GITHUB_DEPLOY_KEY_PATH unset for this phase, precisely because nothing
    # here pushes, so reaching `generate` would fail inside git with an empty
    # `ssh -i` rather than saying what is actually wrong.
    if ! test -f "${buildnumber_record}" ; then
        echo "no ${buildnumber_record} — run RELEASE_PHASE=build first, or set FORCE_BUILDNUMBER" >&2
        exit 1
    fi
    buildnumber=$(cat "${buildnumber_record}")
    echo "reusing build number ${buildnumber} from the build step"
fi
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
    # The Dart port of git-buildnumber, resolved by _tools/cux_ship's lockfile
    # like the rest of the release tooling. Replaces a shell script this used
    # to curl from a mutable branch and execute — unpinned, on a runner
    # holding push credentials, and one GitHub 429 away from executing an
    # error page (see the git history of this block). Same command surface:
    # the number on stdout, logs on stderr, GIT_PUSH_REMOTE and
    # GIT_SSH_COMMAND honored from the environment.
    buildnumber=$(./_tools/ship.sh buildnumber generate)
else
	echo "WARNING: forcing buildnumber $buildnumber"
fi

echo "::set-output name=appbuildnumber::$buildnumber"
mkdir -p "$(dirname "${buildnumber_record}")"
echo "${buildnumber}" > "${buildnumber_record}"

$FLT pub get
case "${flavor}" in
    ios)
        # The split is the point, and it is now a split of *steps* rather than
        # of commands within one. The build runs under `keychain exec`, which
        # places no App Store Connect credential — so the archive cannot hold a
        # key that could create or revoke signing material, rather than merely
        # not using one. The upload is its own step and asks for a key itself,
        # with an individual key scoped to this app.
        #
        # It used to ask by nesting `secrets exec` inside the `keychain exec`
        # child. That worked, and cost the guarantee its own comment claims:
        # a child able to decrypt the file holds the means to mint the very key
        # the archive is meant not to have. As siblings, the build step never
        # decrypts. See docs/apple-signing.md.
        if does_phase build ; then
            ./_tools/build-ios.sh -t lib/env/production.dart -b $buildnumber
        fi
        if does_phase upload ; then
            ./_tools/ship.sh secrets exec --keystore upload --api-key upload \
                -- authpass/_tools/upload-ios.sh
        fi
    ;;
    macos)
        # As for ios: the archive holds no key, the upload is a separate step
        # and asks for one.
        if does_phase build ; then
            ./_tools/build-macos.sh -t lib/env/production.dart -b $buildnumber
        fi
        if does_phase upload ; then
            ./_tools/ship.sh secrets exec --keystore upload --api-key upload \
                -- authpass/_tools/upload-macos.sh
        fi
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

