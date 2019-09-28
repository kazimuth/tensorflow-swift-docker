#!/bin/bash
set -eo pipefail
cd "$(dirname "${0}")"

BUILD=https://storage.googleapis.com/swift-tensorflow-artifacts/releases/v0.5/rc1/swift-tensorflow-RELEASE-0.5-cuda10.0-cudnn7-ubuntu18.04.tar.gz
echo "~~ fetching $BUILD ~~"
echo "   (modify download.sh to update)"
rm -rf ./usr ./build.tar.gz
wget -O build.tar.gz $BUILD
tar xvf build.tar.gz

