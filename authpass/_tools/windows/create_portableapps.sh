#!/bin/bash

set -xeu

# Create a portableapps.com release

#prevdir="${pwd}"

relative_dir="${0%/*}"

pushd "${relative_dir}"
dir="$(pwd)"
popd

basedir="${dir}/../../"

url="https://authpass-data.codeux.design/data/artifacts"
template_url="https://data.authpass.app/data/PortableApps.com_Application_Template_3.5.2.zip"

tmpdir=$(mktemp -d)
cd "${tmpdir}"

fullversion="$(curl "${url}/AuthPass-portable-latest.zip.txt")"
version="$(echo "$fullversion" | cut -d'_' -f1)"
buildnumber="$(echo "$fullversion" | cut -d'_' -f2)"

echo "Building for ${fullversion} (version: ${version} buildnumber: ${buildnumber}"


curl -o template.zip "${template_url}"
curl -o AuthPass-portable.zip "${url}/AuthPass-portable-${fullversion}.zip"

unzip template.zip

mv AppNamePortable AuthPassPortable

cd AuthPassPortable
unzip ../AuthPass-portable.zip

rm ../AuthPass-portable.zip
mv AppNamePortable.exe AuthPassPortable.exe
rm -r App/AppName
rm -r App/DefaultData
cp -r "${dir}/portableapps"/* .

sed -i '' "s/PackageVersion=.*/PackageVersion=${version}.${buildnumber}/" App/AppInfo/appinfo.ini
sed -i '' "s/DisplayVersion=.*/DisplayVersion=${version}/" App/AppInfo/appinfo.ini

cd ..

zipfile="AuthPassPortable-${fullversion}.zip"
zip -r "${zipfile}" AuthPassPortable

mkdir -p "${basedir}/build/windows"
cp "${zipfile}" "${basedir}/build/windows"

rm -rf "${tmpdir}"
