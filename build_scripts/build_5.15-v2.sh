#!/bin/bash

echo -e "\n[INFO]: BUILD STARTED..!\n"

#init submodules
git submodule init && git submodule update

export KERNEL_ROOT="$(pwd)"
export ARCH=arm64
export KBUILD_BUILD_USER="@ravindu644"

# Install the requirements for building the kernel when running the script for the first time
if [ ! -f ".requirements" ]; then
    sudo apt update && sudo apt install -y git device-tree-compiler lz4 xz-utils zlib1g-dev openjdk-17-jdk gcc g++ python3 python-is-python3 p7zip-full android-sdk-libsparse-utils erofs-utils \
        default-jdk git gnupg flex bison gperf build-essential zip curl libc6-dev libncurses-dev libx11-dev libreadline-dev libgl1 libgl1-mesa-dev \
        python3 make sudo gcc g++ bc grep tofrodos python3-markdown libxml2-utils xsltproc zlib1g-dev python-is-python3 libc6-dev libtinfo6 \
        make repo cpio kmod openssl libelf-dev pahole libssl-dev libarchive-tools zstd --fix-missing && wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb && sudo dpkg -i libtinfo5_6.3-2ubuntu0.1_amd64.deb && touch .requirements
fi

# Create necessary directories
mkdir -p "${KERNEL_ROOT}/out" "${KERNEL_ROOT}/build" "${HOME}/toolchains"

#init neutron-clang
if [ ! -d "${HOME}/toolchains/neutron-clang" ]; then
    echo -e "\n[INFO] Cloning Neutron-Clang Toolchain\n"
    mkdir -p "${HOME}/toolchains/neutron-clang" && cd "${HOME}/toolchains/neutron-clang"
    curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman" && chmod +x antman
    bash antman -S && bash antman --patch=glibc
    cd "${KERNEL_ROOT}"
fi

# Export toolchain paths
export PATH="${PATH}:${HOME}/toolchains/neutron-clang/bin"
export NEUTRON_PATH="${HOME}/toolchains/neutron-clang/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/toolchains/neutron-clang/lib"

# Set cross-compile environment variables
export BUILD_CC="${HOME}/toolchains/neutron-clang/bin/clang"

# Build options for the kernel
export BUILD_OPTIONS="
-C ${KERNEL_ROOT} \
O=${KERNEL_ROOT}/out \
-j$(nproc) \
ARCH=arm64 \
CC=${BUILD_CC} \
CROSS_COMPILE=aarch64-linux-gnu- \
CLANG_TRIPLE=aarch64-linux-gnu- \
LLVM=1 \
LLVM_IAS=1 \
AR=${NEUTRON_PATH}/llvm-ar \
NM=${NEUTRON_PATH}/llvm-nm \
LD=${NEUTRON_PATH}/ld.lld \
STRIP=${NEUTRON_PATH}/llvm-strip \
OBJCOPY=${NEUTRON_PATH}/llvm-objcopy \
OBJDUMP=${NEUTRON_PATH}/llvm-objdump \
READELF=${NEUTRON_PATH}/llvm-readelf \
HOSTCC=${NEUTRON_PATH}/clang \
HOSTCXX=${NEUTRON_PATH}/clang++ \
"

build_kernel(){
    # Make default configuration.
    make ${BUILD_OPTIONS} gki_defconfig

    # Configure the kernel (GUI)
    make ${BUILD_OPTIONS} menuconfig

    # Build the kernel
    make ${BUILD_OPTIONS} Image || exit 1

    # Copy the built kernel to the build directory
    cp "${KERNEL_ROOT}/out/arch/arm64/boot/Image" "${KERNEL_ROOT}/build"

    echo -e "\n[INFO]: BUILD FINISHED..!"
}
build_kernel
