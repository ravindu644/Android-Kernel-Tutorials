#!/bin/bash

echo -e "\n[INFO]: BUILD STARTED..!\n"

#init submodules
git submodule init && git submodule update

export KERNEL_ROOT="$(pwd)"
export ARCH=arm64
export KBUILD_BUILD_USER="@ravindu644"

# Function to detect OS and install dependencies
install_dependencies() {
    echo -e "\n[INFO]: Detecting OS and installing dependencies...\n"

    if command -v dnf &> /dev/null; then
        echo -e "[INFO]: Fedora/RHEL-based system detected, using dnf...\n"
        sudo dnf group install "c-development" "development-tools" && \
        sudo dnf install -y dtc lz4 xz zlib-devel java-latest-openjdk-devel python3 \
            p7zip p7zip-plugins android-tools erofs-utils \
            ncurses-devel libX11-devel readline-devel mesa-libGL-devel python3-markdown \
            libxml2 libxslt dos2unix kmod openssl elfutils-libelf-devel dwarves \
            openssl-devel rsync openssl-devel-engine --skip-unavailable

    elif command -v apt &> /dev/null; then
        echo -e "[INFO]: Ubuntu/Debian-based system detected, using apt...\n"
        sudo apt update && sudo apt install -y git device-tree-compiler lz4 xz-utils zlib1g-dev openjdk-17-jdk gcc g++ python3 python-is-python3 p7zip-full android-sdk-libsparse-utils erofs-utils \
            default-jdk git gnupg flex bison gperf build-essential zip curl libc6-dev libncurses-dev libx11-dev libreadline-dev libgl1 libgl1-mesa-dev \
            python3 make sudo gcc g++ bc grep tofrodos python3-markdown libxml2-utils xsltproc zlib1g-dev python-is-python3 libc6-dev libtinfo6 \
            make repo cpio kmod openssl libelf-dev pahole libssl-dev --fix-missing && wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb && sudo dpkg -i libtinfo5_6.3-2ubuntu0.1_amd64.deb

    else
        echo -e "[ERROR]: Neither dnf nor apt package manager found. Please install dependencies manually.\n"
        exit 1
    fi

    touch .requirements
}


# Install the requirements for building the kernel when running the script for the first time
if [ ! -f ".requirements" ]; then
    install_dependencies
fi

# Create necessary directories
mkdir -p "${KERNEL_ROOT}/out" "${KERNEL_ROOT}/build" "${HOME}/toolchains"

# Clone proton clang 12 if not already done
if [ ! -d "${HOME}/toolchains/proton-12" ]; then
    git clone --depth=1 https://github.com/ravindu644/proton-12.git "${HOME}/toolchains/proton-12" 
fi

# Download and extract Linaro 7.5 if not already done
if [ ! -d "${HOME}/toolchains/aarch64-linaro-7.5" ]; then
    cd "${HOME}/toolchains" && wget https://kali.download/nethunter-images/toolchains/linaro-aarch64-7.5.tar.xz
    tar -xvf linaro-aarch64-7.5.tar.xz && rm linaro-aarch64-7.5.tar.xz
    cd "${KERNEL_ROOT}"
fi

# Export toolchain paths
export PATH="${HOME}/toolchains/proton-12/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/toolchains/proton-12/lib:${LD_LIBRARY_PATH}"

# Set cross-compile environment variables
export BUILD_CROSS_COMPILE="${HOME}/toolchains/aarch64-linaro-7.5/bin/aarch64-linux-gnu-"
export BUILD_CC="${HOME}/toolchains/proton-12/bin/clang"

# Build options for the kernel
export BUILD_OPTIONS=(
    -j"$(nproc)"
    -C "${KERNEL_ROOT}"
    O="${KERNEL_ROOT}/out"
    ARCH=arm64
    DTC_EXT="${KERNEL_ROOT}/tools/dtc"
    CROSS_COMPILE="${BUILD_CROSS_COMPILE}"
    CC="${BUILD_CC}"
    CLANG_TRIPLE=aarch64-linux-gnu-
)

build_kernel(){
    # Make default configuration.
    # Replace 'your_defconfig' with the name of your kernel's defconfig
    make "${BUILD_OPTIONS[@]}" your_defconfig

    # Configure the kernel (GUI)
    make "${BUILD_OPTIONS[@]}" menuconfig

    # Build the kernel
    make "${BUILD_OPTIONS[@]}" Image || exit 1

    # Copy the built kernel to the build directory
    cp "${KERNEL_ROOT}/out/arch/arm64/boot/Image" "${KERNEL_ROOT}/build"

    echo -e "\n[INFO]: BUILD FINISHED..!"
}
build_kernel
