#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "\e[31mInstall docker first..!\e[0m"
    exit 1
fi

# Check if .installed file exists
if [ -f ".installed" ]; then
    echo -e "\e[32mkernel-builder is already installed\e[0m"
else
    echo -e "\e[32mInstalling kernel-builder...\e[0m"
    ( xz -d -c kernel-builder.tar.xz | docker load ) && touch ".installed"
fi

# Run the Docker container
docker run -it -v kernel-builder-data:/home/kernel-builder -v "$HOME:/home/kernel-builder/$USER" kernel-builder
