#!/bin/bash
cd "$(dirname "${0}")"

./dedup.sh usr/

DOCKER_BUILDKIT=1 docker build -f Dockerfile . --tag kazimuth2/tensorflow-swift
