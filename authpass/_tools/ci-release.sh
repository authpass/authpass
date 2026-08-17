#!/usr/bin/env bash

# Wrapper script of release.sh for running on a CI.
#
# The Apple path runs this twice, as two CI steps: `RELEASE_PHASE=build` under
# `cux_ship keychain exec`, and `RELEASE_PHASE=upload` with no wrapper at all —
# the upload asks for its own key, one level down. Every other platform runs it
# once under `secrets exec`. See .github/workflows/ios.yaml.
#
# Nothing here decrypts anything, and nothing here holds a secret that outlives
# the run.

set -xeu

DEPS=${DEPS:-~/deps}

root="${0%/*}/.."
target_platform="$1"
target_variant="${2:-$target_platform}"

cd ${root}


# Which half of the release this is. The Apple path runs `build` and `upload`
# as separate steps so the build never has to decrypt anything; every other
# platform runs `all`, which is what this script has always done.
RELEASE_PHASE=${RELEASE_PHASE:-all}

# The deploy key arrives as a path, materialized by the wrapper into a temp
# directory it removes however this exits — so there is nothing to chmod and
# nothing left behind afterwards.
#
# Required only where it is used. `git-buildnumber.sh generate` pushes a ref to
# claim a number, and only the build half calls it: the upload half reads the
# number the build wrote. Demanding the key in a step that never pushes would
# make the upload need a credential to do nothing with, which is the shape this
# whole split exists to remove.
if test "${RELEASE_PHASE}" = upload ; then
    github_key="${GITHUB_DEPLOY_KEY_PATH:-}"
else
    github_key="${GITHUB_DEPLOY_KEY_PATH:?run this under a cux_ship wrapper that places ssh_keys.github_deploy}"
fi
ssh-keygen -F github.com > /dev/null || (mkdir -p ~/.ssh && echo "github.com,192.30.253.113 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts)
ssh-keygen -F gitlab.com > /dev/null || (mkdir -p ~/.ssh && echo "|1|SM9ao9YoaAXLKTeh0tbzHwhhLcY=|0uw956+KbChkLUB6mmO8gq//Nsk= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9" >> ~/.ssh/known_hosts)

# Flutter was installed by `install_flutter.sh` in `ci-install-deps.sh`.
export PATH=${DEPS}/flutter/bin:$PATH

# Anything an apple build cannot need is dropped before xcodebuild sees it.
#
# This is not tidiness. An xcode script build phase writes its whole environment
# into the build log — `export GCC_WARN_...`, and every other variable with it —
# and a public repository's action logs are public. Every other credential here
# is a *path*, so what leaks is a filename; the play service account is the one
# exported as a value, so what leaked was the private key itself. It has been in
# the logs of every ios and macos release since this script moved under
# `secrets exec`, which is a leak this line would have prevented.
#
# The general rule, for whatever is added next: a secret passed as a value can
# escape through anything that echoes its environment, and a secret passed as a
# path cannot.
if test "$target_platform" == "ios" || test "$target_platform" == "macos" ; then
    # Since cux_ship 2.0.0 this is a path rather than the key itself, so what
    # an echoed environment would leak is a filename in a directory that no
    # longer exists. Still unset, because an apple build has no business
    # holding it at all — but the leak it was written for cannot recur.
    unset GOOGLE_PLAY_SERVICE_ACCOUNT_JSON_PATH
    unset ANDROID_KEYSTORE_PATH ANDROID_KEYSTORE_PASSWORD
    unset ANDROID_KEY_ALIAS ANDROID_KEY_PASSWORD
    # Everything else this build cannot need, because the environment dump
    # prints *values*: the certificate passwords are consumed by `keychain
    # exec` before this runs and nothing downstream reads them, and the
    # artifact and fosshub tokens belong to the platforms that publish
    # downloads. Verified in build-ios.sh, build-macos.sh, upload-ios.sh,
    # upload-macos.sh and release.sh: none of them mentions these.
    unset APPLE_DISTRIBUTION_P12_PASSWORD APPLE_DISTRIBUTION_P12_PATH
    unset APPLE_DEVELOPER_ID_P12_PASSWORD APPLE_DEVELOPER_ID_P12_PATH
    unset APPLE_MAC_INSTALLER_P12_PASSWORD APPLE_MAC_INSTALLER_P12_PATH
    unset ARTIFACT_TOKEN FOSSHUB_TOKEN
    # This whole block is a denylist, and a denylist is fail-open: the next
    # credential family added to the secrets file reaches xcodebuild until
    # somebody remembers to add a line here. cux_ship 3.0.0 replaces it with one
    # allowlist token on the wrapper — `--only ssh_keys.github_deploy`, which is
    # all the build actually consumes — and every `unset` above can then go.
    # Waiting on that release; we are pinned to ^2.3.0 today.
fi

# Build-time only: the upload step neither compiles nor links, so refreshing
# the CocoaPods spec repo there is minutes of nothing.
if test "$target_platform" == "ios" && test "${RELEASE_PHASE}" != upload ; then
    # No ssh-agent, no certificate repository, no MATCH_PASSWORD, and no
    # fastlane. `cux_ship keychain exec` imports the signing identity into a
    # keychain that exists for this step and no longer — build-ios.sh only
    # passes `--keychain "$APPLE_KEYCHAIN"` to xcodebuild.
    #
    # CocoaPods is still here: seven plugins have not adopted Swift Package
    # Manager, and most of them are ours.
    pod repo update
fi
if test "$target_platform" == "macos" && test "${RELEASE_PHASE}" != upload ; then
    # As for ios: no cert repo, no MATCH_PASSWORD, no fastlane. Signing
    # material comes from the environment, put there by secrets exec.
    pod repo update
fi

pwd

GIT_SSH_COMMAND="ssh -i \"$github_key\"" \
    GIT_PUSH_REMOTE='git@github.com:authpass/authpass.git' \
    ./_tools/release.sh "$target_variant"
