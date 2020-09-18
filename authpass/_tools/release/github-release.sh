#!/usr/bin/env bash

set -xeuE
set +x # disable command output.

dir="${0%/*}"
cd $dir/../..

#tmpdir=$(mktemp -d)
tmpdir="/var/tmp/authpass-github"

mkdir -p "${tmpdir}"

pushd "${tmpdir}"

repo="authpass/authpass"
github_api_token=$(cat ~/.authpass_github_api_token)

curl https://data.authpass.app/data/artifact.download/.fosshub > files.json

IFS='+' read -r version build <<< "$(jq -r '.version' < files.json)"
jq -r '.files[] | .fileUrl + " " + .fileName' < files.json > files.txt



# Define variables.
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/${repo}"
GH_TAGS="$GH_REPO/releases/tags/v${version}"
GH_RELEASES="$GH_REPO/releases"
AUTH="Authorization: token $github_api_token"
#CURL_ARGS="-LJO#"

# Validate token.
curl -o /dev/null -sH "$AUTH" $GH_REPO || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

# Find release id
curl -sH "$AUTH" "$GH_RELEASES" > releases.json

IFS=' ' read -r gh_id gh_tag <<< "$(jq -r '[.[] | select(.draft) | ((.id|tostring) + " " + .tag_name)] | .[0]' < releases.json)"

gh_tag_expected="v${version}"
if test "${gh_tag_expected}" != "${gh_tag}" ; then
  echo "Unable to find release draaft."
  echo "expected ${gh_tag_expected} but got ${gh_tag}"
  exit
fi

## Get ID of the asset based on given filename.
#echo "$response" | jq -r '[.[] | select(.draft) | ((.id|tostring) + " " + .tag_name)] | .[0]'
#eval $(echo "$response" | grep -m 1 "id.:" | grep -w id | tr : = | tr -cd '[[:alnum:]]=')
## shellcheck disable=SC2154
id="$gh_id"
[ "$id" ] || { echo "Error: Failed to get release id for tag: $tag"; echo "$response" | awk 'length($0)<100' >&2; exit 1; }


echo "release ${version} with build ${build}"

while IFS= read -r file ; do
    IFS=' ' read -r url name <<< "${file}"
    echo "file: $file --- url: ${url} name: ${name} xxx"
    curl -q -C - -o "${name}" "${url}"

    GH_ASSET="https://uploads.github.com/repos/${repo}/releases/$id/assets?name=${name}"

    echo "Uploading ${name} ..."
    curl --fail -H "$AUTH" --progress-bar --data-binary @"${name}" -H "Content-Type: application/octet-stream" "${GH_ASSET}"

done < files.txt

popd

rm -r "$tmpdir"
