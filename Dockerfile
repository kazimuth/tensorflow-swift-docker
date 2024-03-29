# syntax = docker/dockerfile:experimental
FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

COPY ./dedup.sh /usr/bin/dedup.sh

RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y clang libblocksruntime-dev git cmake ninja-build clang python uuid-dev \
                       libicu-dev icu-devtools libedit-dev libxml2-dev libsqlite3-dev swig \
                       libpython-dev libncurses5-dev pkg-config libcurl4-openssl-dev systemtap-sdt-dev tzdata rsync libpython3.6-dev sudo \
                       python3-pip && \
    dedup.sh /usr/ 
ADD ./usr /usr
RUN --mount=type=cache,target=/tmp/sourcekit-lsp/ \
    cd /tmp/sourcekit-lsp && \
    ls -alt && \
    if [ ! -d .git ]; then git init && git remote add origin https://github.com/apple/sourcekit-lsp; fi && \
    git fetch origin --tags && \
    git checkout swift-DEVELOPMENT-SNAPSHOT-2019-09-26-a && \
    git submodule update --init --recursive && \
    swift package update && \
    swift build -c release -Xcxx -I/usr/lib/swift -Xcxx -I/usr/lib/swift/Block && \
    cp .build/release/sourcekit-lsp /usr/bin/sourcekit-lsp

RUN useradd -ms /bin/bash ubuntu
RUN usermod -aG sudo ubuntu
RUN passwd -d ubuntu
USER ubuntu
WORKDIR /home/ubuntu

CMD /bin/bash
