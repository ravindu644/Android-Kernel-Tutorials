#!/bin/bash

RED="\e[31m"
RESET="\e[0m"
GREEN="\e[32m"
YELLOW="\e[33m"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed! Please install Docker first.${RESET}"
    exit 1
fi

# Check if --reinstall flag is provided
if [[ "$1" == "--reinstall" ]]; then
    echo -e "${YELLOW}Removing previous kernel-builder container and volume...${RESET}"
    
    # Remove any containers using the kernel-builder image with its volumes
    docker ps -a -q --filter ancestor=kernel-builder | xargs -r docker rm -f
    docker volume rm kernel-builder-data 2>/dev/null
    rm -f .installed
    
    # Reinstall
    echo -e "${GREEN}Reinstalling kernel-builder...${RESET}"
    xz -d -c kernel-builder.tar.xz | docker load && touch ".installed"
else
    # Normal flow: check if installed, install if needed
    if [ -f ".installed" ]; then
        echo -e "${GREEN}kernel-builder is already installed${RESET}"
    else
        # First time installation
        echo -e "${GREEN}Installing kernel-builder...${RESET}"
        xz -d -c kernel-builder.tar.xz | docker load && touch ".installed"
    fi
fi

# Run the container
echo -e "${GREEN}Launching kernel-builder container...${RESET}"
docker run -it --privileged \
    -v kernel-builder-data:/home/kernel-builder \
    -v "$HOME:/home/kernel-builder/$USER" \
    kernel-builder
