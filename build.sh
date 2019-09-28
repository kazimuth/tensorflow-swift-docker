#!/bin/bash
set -eo pipefail
cd "$(dirname "${0}")"

echo '~~ building tensorflow-swift ~~'

./dedup.sh usr/

echo '~~ removing unneccesary python link ~~'
rm usr/lib/python3.7 2>/dev/null >/dev/null || true

echo '~~ docker build ~~'
DOCKER_BUILDKIT=1 docker build -f Dockerfile . --tag kazimuth2/tensorflow-swift
