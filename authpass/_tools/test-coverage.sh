#!/bin/bash

# WARNING:
# Running coverage tests with kdbx 3 seems to be too slow right now, so we only run kdbx 4 tests
# (kdbx4 with argon2 runs on native code, so no code coverage is collected there, vs.
# kdbx3's AES KDF runs in dart).
#
# This is way too slow. Probably because of cryptography with coverage colleciton.
# https://github.com/dart-lang/coverage/issues/261
#
# This script requires `jq`, `curl`, `git`.

set -xeu

cd "${0%/*}"/..

_tools/flutter_run.sh pub get
_tools/flutter_run.sh pub global activate coverage

fail=false
_tools/flutter_run.sh test --coverage --exclude-tags=webdav || fail=true
echo "fail=$fail"

bash <(curl -s https://codecov.io/bash) -f coverage/lcov.info


test "$fail" == "true" && exit 1

echo "Success 🎉️"

exit 0

#pub get
#pub global activate test_coverage
#
#fail=false
#pub global run test_coverage || fail=true
#echo "fail=$fail"
#bash <(curl -s https://codecov.io/bash) -f coverage/lcov.info
#
#test "$fail" == "true" && exit 1
#
#echo "Success 🎉️"
#
#exit 0
