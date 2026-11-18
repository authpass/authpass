#!/usr/bin/env bash
# What has to be true before a stage spends anything, for `.cux-train.yaml`'s
# `gates:` keys.
#
#   tool/train-gate.sh build-number 2196
#   tool/train-gate.sh release-version 1.9.13
#   tool/train-gate.sh changelog-section 1.9.13
#   tool/train-gate.sh fdroid-changelog
#
# **A gate's contract is the opposite of a read's**, and they live in sibling
# files for that reason rather than in one. `tool/train-read.sh` answers "not
# there yet" by printing nothing and "I could not tell" with a non-zero exit,
# and the train keeps waiting on both. A gate has one bit: exit zero and the
# stage proceeds, anything else and the run refuses having spent nothing. So
# "could not tell" has to fail here. A release held back by a gate that could
# not reach the network costs one re-run; a release let through by one costs a
# published mistake.
#
# **A gate must spend nothing**, which is what lets `--dry-run` run the gates
# — and that is the whole value of a dry run before a release: it answers
# whether this release is ready, not just what the table says. Every check
# below reads a file in this repository or asks the build-number allocator a
# question that claims nothing.
#
# **Two build numbers, and only one of them is `{build}`.** The train's
# `{build}` is git-buildnumber's, which names every artifact and every store
# upload and is what `tool/train-read.sh` compares. `authpass/pubspec.yaml`
# carries a second one in its `+N` — the Android versionCode, and the number
# the web app reports — bumped by hand and currently three figures where the
# other is four. The F-Droid changelog file is named by versionCode, so the
# check for it reads the pubspec and never `{build}`. Mixing the two is the
# mistake this comment exists to prevent; `.cux-train.yaml` says the same
# thing where the `web` row explains why it cannot be waited on.

set -euo pipefail

mode="${1:-}"
shift || true

# The repository root, resolved from this script rather than from the working
# directory. The train already runs gates with the root as their working
# directory, so this changes nothing when the train is the caller — it is for
# the person running the same check by hand to see what the train saw.
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)

die() {
  echo "train-gate: $*" >&2
  exit 1
}

# `1.9.13+167` out of `version: 1.9.13+167`, which is the only line in that
# file starting with `version:`.
_pubspec_version() {
  local line
  line=$(grep -m 1 '^version:' "${root}/authpass/pubspec.yaml") \
    || die 'authpass/pubspec.yaml declares no version'
  line=${line#version:}
  # No `xargs`, no subshell: the value is one token and the only whitespace
  # around it is the space after the colon.
  printf '%s' "${line// /}"
}

case "${mode}" in
  build-number)
    # **The number the train was told has to be the number the commit owns.**
    # Everything downstream is named after `{build}` — the artifacts the reads
    # look for, the `uploaded/` tag a promotion is recorded against — so a
    # stale `--build` does not fail, it succeeds against the previous
    # release's files. That is the one error in this list that would go
    # unnoticed, which is why it is checked first.
    expected="${1:?usage: train-gate.sh build-number <build>}"
    case "${expected}" in
      '' | *[!0-9]*) die "\`${expected}\` is not a build number" ;;
    esac

    # `get` asks without claiming, where `generate` would allocate one; a gate
    # that allocated would be spending. Its progress trace goes to stderr, so
    # stdout is the number alone.
    allocated=$("${root}/authpass/_tools/ship.sh" buildnumber get 2>/dev/null) \
      || die 'the build-number allocator could not answer. It fetches from
origin, so this is usually the network. Nothing was checked.'

    if [ -z "${allocated}" ]; then
      die "no build number is allocated for this commit yet. Claim the one CI
will agree on with \`authpass/_tools/ship.sh buildnumber generate\`, and pass
that as --build."
    fi

    if [ "${allocated}" != "${expected}" ]; then
      die "--build is ${expected}, but this commit owns ${allocated}. The
allocator is idempotent per commit, so ${allocated} is what CI will build and
what every artifact will be named after."
    fi
    ;;

  release-version)
    # The version CI stamps into the builds comes from the pubspec, not from
    # the train's `--release`, so the two disagreeing means the train is
    # tracking one release while CI builds another. The gates after this one
    # read the pubspec, and this is what earns them the right to.
    want="${1:?usage: train-gate.sh release-version <version>}"
    declared=$(_pubspec_version)

    if [ "${declared%%+*}" != "${want}" ]; then
      die "--release is ${want}, but authpass/pubspec.yaml says
\`${declared}\`. CI stamps the pubspec's version into every build, so this run
would track ${want} while the artifacts said ${declared%%+*}."
    fi
    ;;

  changelog-section)
    # `cux_ship verify` checks this too, and cannot be the gate that does:
    # today it reports 23 problems, all but two of them in sections from 1.2.0
    # to 1.9.10 that will never be published again, so as a gate it would
    # refuse every release for history. The check worth having at release time
    # is only about the release at hand, and it is four lines.
    want="${1:?usage: train-gate.sh changelog-section <version>}"

    # The root CHANGELOG.md is a symlink to authpass/CHANGELOG.md; this is the
    # path cux_ship names, so an error here matches what that reports.
    changelog="${root}/CHANGELOG.md"
    test -f "${changelog}" || die 'CHANGELOG.md is not readable'

    # `## 1.9.13 - 2026-11-09`, or the same with no date. Compared rather than
    # matched as a pattern, so `## 1.9.1` cannot answer for `## 1.9.13`.
    # `-1` for a section that is not there at all, which is a different thing
    # to say than a section with nothing in it.
    entries=$(awk -v want="${want}" '
      $0 == "## " want || index($0, "## " want " ") == 1 {
        seen = 1
        inside = 1
        next
      }
      /^## / {
        inside = 0
      }
      inside && /^[*-] / {
        found++
      }
      END {
        print seen ? found + 0 : -1
      }
    ' "${changelog}") || die 'CHANGELOG.md could not be read'

    if [ "${entries}" = '-1' ]; then
      die "CHANGELOG.md has no \`## ${want}\` section. Its sections are the
release notes every store gets, so there is nothing to publish for this
release."
    fi

    if [ "${entries}" = '0' ]; then
      die "CHANGELOG.md's \`## ${want}\` section has no entries, so every
store would be handed empty release notes."
    fi
    ;;

  fdroid-changelog)
    # **The gap this gate exists for.** F-Droid takes its release notes from a
    # file named after the versionCode, and the newest one in the tree is
    # 160.txt — written for 1.9.5 in June 2022, while the pubspec has since
    # reached 167. Nothing read those files, so nothing said so, and F-Droid
    # users have had no notes for seven releases.
    #
    # At `internal` rather than at `production`, because the `fdroid` row's
    # own note says the changelog is copied into metadata/android *before the
    # stable push* — and the stable push is this stage's dispatch. By
    # `production` the tag F-Droid builds from would already exist.
    declared=$(_pubspec_version)
    case "${declared}" in
      *+*) ;;
      *) die "authpass/pubspec.yaml says \`${declared}\`, which carries no
+versionCode, so there is no F-Droid changelog name to look for." ;;
    esac
    code=${declared#*+}

    changelogs="metadata/android/en-US/changelogs"
    file="${changelogs}/${code}.txt"
    if [ ! -s "${root}/${file}" ]; then
      # A glob rather than `ls`, so a name nobody expected cannot be split; it
      # only ever reaches an error message, so an unmatched glob is harmless.
      newest=$(printf '%s\n' "${root}/${changelogs}"/*.txt \
        | sed -e 's|.*/||' -e 's|\.txt$||' | sort -n | tail -1)
      die "${file} is missing or empty. F-Droid names its release notes after
the versionCode, which is the pubspec's +${code} and not the train's build
number. Write that file — the newest one in the tree is ${newest}."
    fi
    ;;

  *)
    die "unknown gate \`${mode}\` — expected \`build-number\`,
\`release-version\`, \`changelog-section\` or \`fdroid-changelog\`"
    ;;
esac
