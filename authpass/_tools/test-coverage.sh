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

# test/web/ holds what cannot be answered on the VM: dart:io compiles for the
# web and throws at *runtime*, so a stray `Platform.isIOS` is invisible to
# `flutter analyze` and to every test above this line, and only shows up once a
# real browser reaches it. That is how opening a database on the web broke
# (#432).
#
# Scoped to the directory, not a tag: --tags selects tests, but the runner
# still loads every file to find them, and test/cloud_storage/*_test.dart does
# not compile for the browser. Those files are what the chrome run would die
# on, long before reaching anything under test/web/.
#
# A second run rather than a flag, because --coverage and --platform chrome
# cannot be combined. Nothing is collected here, so the lcov upload below still
# reports the VM run alone.
_tools/flutter_run.sh test --platform chrome test/web || fail=true
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
