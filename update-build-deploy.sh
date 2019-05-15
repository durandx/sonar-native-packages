#!/bin/sh

# How to run :
# ./update-build-deploy.sh my-jenkins-server

JENKINS_BASE_URL=$1 

# get latest sonar version
DOWNLOAD_URI=$(curl -s "http://$JENKINS_BASE_URL/api/system/upgrades" | jq -r '[.upgrades[] | select(.plugins.incompatible == [])] | max_by(.version) | .downloadUrl')
VERSION=$(curl -s "http://$JENKINS_BASE_URL/api/system/upgrades" | jq -r '[.upgrades[] | select(.plugins.incompatible == [])] | max_by(.version) | .version')

mkdir -p ~/sonar-native-packages/downloads && cd ~/sonar-native-packages/downloads
curl -L -O $DOWNLOAD_URI
cd ..

./build.sh $VERSION

yum --nogpgcheck localinstall repo/rpm/noarch/sonar-$VERSION.noarch.rpm

