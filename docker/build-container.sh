#!/bin/bash

if [ -z "$DOCKER_CONTAINER_VERSION" ]; then
    export DOCKER_CONTAINER_VERSION="dev"
fi

# build the container
docker build -t kernel-builder .

# export it as a tar file
docker save -o kernel-builder.tar kernel-builder

# xz compressing
xz -z -T0 -9 kernel-builder.tar

# zipping stuffs
zip -0 -R "kernel-builder-${DOCKER_CONTAINER_VERSION}.zip" kernel-builder.tar.xz kernel-builder.sh
