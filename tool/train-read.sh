#!/usr/bin/env bash
# What a destination currently holds, for `.cux-train.yaml`'s `read:` keys.
#
#   tool/train-read.sh artifact 2196 authpass-sideload-1.9.13_2196.apk
#   tool/train-read.sh snap edge amd64
#
# **The contract is three answers, and the whole reason this file exists is to
# map HTTP onto them.** `cux_train` reads one build number from stdout; empty
# stdout means no build there yet, and a non-zero exit means the read could not
# answer — which is a reason to keep looking rather than a verdict on the
# destination. Those are three outcomes, and `curl --fail` collapses the last
# two into one: a 404 (there is no such artifact yet, the normal state for most
# of a wait) would exit non-zero exactly like a DNS failure. So the status code
# is read and dispatched on, and nothing here uses `--fail`.
#
# **One script and a mode argument, not one per destination.** The nine rows
# that use it are two shapes — "does this URL exist" and "a field in this JSON"
# — and the contract above is the part that is easy to get subtly wrong, so it
# is written once. If a third shape turns up, that is the moment to ask whether
# the train should carry a declarative read instead of every consumer carrying
# a script like this one.
#
# **Nothing here is a credential.** Both endpoints are public, which is what
# makes these the reads that could be wired first: the artifact server's
# download path is the same one the download page hands to users, and
# api.snapcraft.io answers anybody. The reads that need a key — Play's internal
# track, TestFlight — are not here; see `.cux-train.yaml`.

set -euo pipefail

mode="${1:-}"
shift || true

# The host the uploads go to (`_tools/upload-artifact.sh`) and that the
# download page is generated from, so a name that is on the download page is
# answerable here.
artifacts="https://data.authpass.app/data/artifacts"

die() {
  echo "train-read: $*" >&2
  exit 1
}

case "${mode}" in
  artifact)
    # `{build}` is passed in rather than parsed out of the name: the answer is
    # "this destination holds that build", and the artifact's presence under a
    # name carrying the number is the evidence for it. A read that recovered
    # the number from the filename it was just given would only be able to
    # agree with itself.
    build="${1:?usage: train-read.sh artifact <build> <filename>}"
    name="${2:?usage: train-read.sh artifact <build> <filename>}"

    # `--location`, so a redirect is followed and the status that gets
    # dispatched on is the one at the end of it. Without it a server-side move
    # would read as "could not answer" for the whole timeout.
    code=$(curl --silent --show-error --location --head --max-time 20 \
      --output /dev/null --write-out '%{http_code}' \
      "${artifacts}/${name}") \
      || die "HEAD ${name} did not complete"

    case "${code}" in
      200) printf '%s\n' "${build}" ;;
      # Nothing yet. The expected answer for most of a wait, and the one that
      # must not look like a failure.
      404) ;;
      *) die "HEAD ${name} answered ${code}" ;;
    esac
    ;;

  snap)
    # The channel is the destination here, not the file: the snap is on the
    # artifact server as well, and that only says CI built it. `edge` is what
    # the `stable` push publishes (§3's "already on edge"), so that is
    # `internal`'s read; `stable` is the production one, for when `status`
    # reads too.
    channel="${1:?usage: train-read.sh snap <channel> <arch>}"
    arch="${2:?usage: train-read.sh snap <channel> <arch>}"

    command -v jq >/dev/null || die 'jq is not installed'

    # `Snap-Device-Series` is required; without it the API answers an error
    # document with a 200, which is why this one uses --fail as well.
    #
    # **`version` has to be asked for by name, even though it is read out of
    # the channel map.** `fields=channel-map` alone returns each entry with its
    # `channel` object and nothing else, so the `jq` below found no version and
    # this read answered *empty* — which the contract spells "no build there
    # yet". The first run of it said the snap `edge` channel was empty while
    # `edge` held the candidate: a silent false negative that costs a whole
    # timeout and reports `pending`. Found by reading a channel whose answer
    # was known beforehand, which is the only way this one shows up.
    body=$(curl --silent --show-error --fail --max-time 25 \
      --header 'Snap-Device-Series: 16' \
      "https://api.snapcraft.io/v2/snaps/info/authpass?fields=channel-map,version") \
      || die 'api.snapcraft.io did not answer'

    # One architecture, because the channel map has a row per architecture and
    # they diverge: i386 and ppc64el sat three releases behind amd64 when this
    # was written. A read that took the first row would answer about whichever
    # architecture the API happened to list first.
    version=$(printf '%s' "${body}" | jq -r \
      --arg c "${channel}" --arg a "${arch}" \
      '[.["channel-map"][]
        | select(.channel.name == $c and .channel.architecture == $a)
        | .version] | first // empty')

    if [ -z "${version}" ]; then
      # No release on that channel for that architecture: nothing there yet.
      exit 0
    fi

    # `1.9.13+2196` — the build number is what the train compares, and a
    # version without one is a shape this cannot read rather than an absence.
    case "${version}" in
      *+*) printf '%s\n' "${version#*+}" ;;
      *) die "${channel}/${arch} is \`${version}\`, which carries no +build" ;;
    esac
    ;;

  *)
    die "unknown mode \`${mode}\` — expected \`artifact\` or \`snap\`"
    ;;
esac
