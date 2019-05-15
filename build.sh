#!/bin/sh

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

./build-rpm.sh $1
#EDIT: Disabling debian package
#./build-deb.sh $1
