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
elif test "$target_platform" == "ios" || test "$target_platform" == "macos" ; then
    # The remedy names the whole invocation, flag included. Before cux_ship
    # 3.0.0 this credential arrived by default and "run it under a wrapper"
    # would have been enough; under the empty default that advice gets you a
    # keychain, clears this check, and fails further down instead.
    github_key="${GITHUB_DEPLOY_KEY_PATH:?run under 'cux_ship keychain exec --only ssh_keys.github_deploy'}"
else
    # Every other platform runs without a keychain wrapper and pushes build
    # numbers over the checkout's own https credentials — the web workflow has
    # done so since before the deploy key existed here, and requiring the key
    # unconditionally is what broke it on the first stable push after the
    # split.
    github_key="${GITHUB_DEPLOY_KEY_PATH:-}"
fi
ssh-keygen -F github.com > /dev/null || (mkdir -p ~/.ssh && echo "github.com,192.30.253.113 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts)
ssh-keygen -F gitlab.com > /dev/null || (mkdir -p ~/.ssh && echo "|1|SM9ao9YoaAXLKTeh0tbzHwhhLcY=|0uw956+KbChkLUB6mmO8gq//Nsk= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9" >> ~/.ssh/known_hosts)

# Flutter was installed by `install_flutter.sh` in `ci-install-deps.sh`.
export PATH=${DEPS}/flutter/bin:$PATH

# Nothing is dropped here any more, because nothing arrives that has to be.
#
# There used to be a ten-line `unset` denylist at this point, and the reason it
# existed is still worth knowing: an xcode script build phase writes its whole
# environment into the build log — `export GCC_WARN_...`, and every other
# variable with it — and a public repository's action logs are public. The play
# service account was exported as a *value*, so what leaked was the private key
# itself, in every ios and macos release from the day this script moved under
# `secrets exec`.
#
# A denylist is fail-open, which is the deeper problem: every credential added
# to the secrets file reached xcodebuild until somebody remembered a line here.
# cux_ship 3.0.0 inverts it. `keychain exec` gives its child the keychain and
# nothing else, so the build step names what it needs — `--only
# ssh_keys.github_deploy` in .github/workflows/ios.yaml — and a credential
# nobody asked for is simply absent rather than subtracted.
#
# The general rule survives the block that taught it, for whatever is added
# next: a secret passed as a value can escape through anything that echoes its
# environment, and a secret passed as a path cannot.

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

if test -n "$github_key" ; then
    GIT_SSH_COMMAND="ssh -i \"$github_key\"" \
        GIT_PUSH_REMOTE='git@github.com:authpass/authpass.git' \
        ./_tools/release.sh "$target_variant"
else
    # No key, no ssh: git-buildnumber pushes to `origin`, whose persisted
    # checkout token already proves itself on every android run.
    ./_tools/release.sh "$target_variant"
fi
