#!/usr/bin/env bash

set -exu

DEPS=${DEPS:-~/deps}

root="${0%/*}/.."
pwd

echo "Installing flutter into $DEPS"

cd ${root}

DEPS=${DEPS} _tools/install_flutter.sh

# Flutter first, because everything below runs on the Dart inside it — see
# _tools/ship.sh. The runners have no Dart of their own.

# sops and age, pinned by hash and installed into .bin/ at the repository root.
#
# This replaced a per-platform download of a personally-maintained blackbox
# fork, fetched from a release tag at build time on three different operating
# systems. cux_ship pins what it installs and verifies it, and there is one code
# path rather than three.
#
# Nothing is decrypted here. Credentials arrive when a command is run under
# `cux_ship secrets exec`, which needs only SOPS_AGE_KEY in the environment —
# one secret, whatever the CI provider.
echo "==> installing sops and age"
DEPS=${DEPS} _tools/ship.sh deps install

# The source files the build and the analyzer read from fixed paths —
# lib/env/production.dart, lib/env/secrets.dart, test/_testSecrets.json. They
# cannot come from `secrets exec`, which removes what it writes: the compiler
# reads them long after any single command has ended.
#
# Skipped when there is no key, so a fork's pull request still builds what it
# can rather than failing here.
if [ -n "${SOPS_AGE_KEY:-}" ]; then
  echo "==> placing the source files that carry secrets"
  DEPS=${DEPS} _tools/ship.sh secrets place
else
  echo "==> no SOPS_AGE_KEY, skipping the source files that carry secrets"
fi
