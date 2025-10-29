#!/bin/sh

set -e

# Init neutron-clang
mkdir -p "$HOME/toolchains/neutron-clang" && \
    cd "$HOME/toolchains/neutron-clang" && \
    curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman" && chmod +x antman && \
    bash antman -S && bash antman --patch=glibc