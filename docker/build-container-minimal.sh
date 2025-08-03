#!/bin/bash

set -x

if [ -z "$DOCKER_CONTAINER_VERSION" ]; then
    export DOCKER_CONTAINER_VERSION="dev"
fi

cd minimal

# build the container
docker build -t kernel-builder .

# export it as a tar file
docker save -o kernel-builder.tar kernel-builder

# xz compressing
xz -z -T0 -9 kernel-builder.tar

mkdir -p "kernel-builder-${DOCKER_CONTAINER_VERSION}-minimal" && mv kernel-builder.tar.xz ../kernel-builder.sh "kernel-builder-${DOCKER_CONTAINER_VERSION}-minimal"

# zipping stuffs
zip -0 -r "kernel-builder-${DOCKER_CONTAINER_VERSION}-minimal.zip" "kernel-builder-${DOCKER_CONTAINER_VERSION}-minimal"
mv *.zip ../
