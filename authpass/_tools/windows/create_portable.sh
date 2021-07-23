#!/bin/bash

set -xeu

# input arguments
version=${version:?}
buildnumber=${buildnumber:?}

reldir="build/_authpass/windows/release/authpass"
portdir="build/_authpass/windows/release/portable"
#portableappsdir="build/_authpass/windows/release/portableapps"
zipfilename="AuthPass-portable-${version}_${buildnumber}.zip"
zipfile="build/_authpass/windows/release/${zipfilename}"

mkdir -p "${portdir}/App"
cp -r "${reldir}" "${portdir}/App/AuthPass"

echo "App\\AuthPass\\AuthPass.exe" > "${portdir}/AuthPass.bat"
echo "${version}_${buildnumber}" > "${portdir}/version.txt"

pushd ${portdir}
#portdirabs="$(pwd)"
7z a "../${zipfilename}" -r ./*
popd

outputfilename="${zipfilename}"
outputpath="${zipfile}"
#echo "${version}+${buildnumber}" > build/${flavor}/release/version.txt
#echo "${version}+${buildnumber}" > build/${flavor}/release/bundle/version.txt
#tar czvf ${outputpath} --transform "s/^build.*bundle/authpass/" build/${flavor}/release/bundle
echo "::set-output name=appversion::${version}"
echo "::set-output name=outputfilename::${outputfilename}"
echo "::set-output name=outputpath::${outputpath}"

## now create portableapps.com distribution
#
#zipfilename="AuthPassPortableApps-${version}_${buildnumber}.zip"
#
#pushd ${portableappsdir}
#wget -O apptemplate.zip https://data.authpass.app/data/PortableApps.com_Application_Template_3.5.2.zip
#7z x apptemplate.zip
#mv AppNamePortable AuthPassPortable
#cp -r "${portdirabs}"/* AuthPassPortable/
#7z a "../${zipfilename}"