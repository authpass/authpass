#!/usr/bin/env bash

# Wrapper script of release.sh for running on a CI.

set -xeu

DEPS=${DEPS:-~/deps}

root=`git rev-parse --show-toplevel`

cd ${root}


${DEPS}/blackbox/bin/blackbox_postdeploy

chmod 400 _tools/deploy-key/github-deploy-key
ssh-keygen -F github.com > /dev/null || (mkdir -p ~/.ssh && echo "github.com,192.30.253.113 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts)
ssh-keygen -F gitlab.com > /dev/null || (mkdir -p ~/.ssh && echo "|1|SM9ao9YoaAXLKTeh0tbzHwhhLcY=|0uw956+KbChkLUB6mmO8gq//Nsk= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9" >> ~/.ssh/known_hosts)

if test "$1" == "ios" ; then
    eval $(ssh-agent -s)
    cat _tools/secrets/fastlane_match_certificates_id_rsa | ssh-add -
    set +x
    # defines MATCH_PASSWORD and FASTLANE_PASSWORD
    source _tools/secrets/fastlane_match_password
    set -x

    cd ios && fastlane match appstore --readonly && cd ..

    # make sure cocoapods is up to date.
    pod repo update
fi

cd ${root}


# Flutter was installed by `install_flutter.sh` in `ci-install-deps.sh`.
export PATH=${DEPS}/flutter/bin:$PATH

GIT_SSH_COMMAND='ssh -i _tools/deploy-key/github-deploy-key' \
    GIT_PUSH_REMOTE='git@github.com:hpoul/finalyzer-game.git' \
    ./release.sh "$@"
