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
            openssl-devel libarchive zstd rsync openssl-devel-engine --skip-unavailable

    elif command -v apt &> /dev/null; then
        echo -e "[INFO]: Ubuntu/Debian-based system detected, using apt...\n"
        sudo apt update && sudo apt install -y git device-tree-compiler lz4 xz-utils zlib1g-dev openjdk-17-jdk gcc g++ python3 python-is-python3 p7zip-full android-sdk-libsparse-utils erofs-utils \
            default-jdk git gnupg flex bison gperf build-essential zip curl libc6-dev libncurses-dev libx11-dev libreadline-dev libgl1 libgl1-mesa-dev \
            python3 make sudo gcc g++ bc grep tofrodos python3-markdown libxml2-utils xsltproc zlib1g-dev python-is-python3 libc6-dev libtinfo6 \
            make repo cpio kmod openssl libelf-dev pahole libssl-dev libarchive-tools zstd rsync --fix-missing && wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb && sudo dpkg -i libtinfo5_6.3-2ubuntu0.1_amd64.deb

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
mkdir -p "${KERNEL_ROOT}/out" "${KERNEL_ROOT}/build" "${HOME}/toolchains"

# init clang-r416183b
if [ ! -d "${HOME}/toolchains/clang-r416183b" ]; then
    echo -e "\n[INFO] Cloning Clang-r416183b...\n"
    mkdir -p "${HOME}/toolchains/clang-r416183b" && cd "${HOME}/toolchains/clang-r416183b"
    curl -LO "https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r416183b.tar.gz"
    tar -xf clang-r416183b.tar.gz && rm clang-r416183b.tar.gz
    cd "${KERNEL_ROOT}"
fi

#init arm gnu toolchain
if [ ! -d "${HOME}/toolchains/gcc" ]; then
    echo -e "\n[INFO] Cloning ARM GNU Toolchain\n"
    mkdir -p "${HOME}/toolchains/gcc" && cd "${HOME}/toolchains/gcc"
    curl -LO "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz"
    tar -xf arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz
    cd "${KERNEL_ROOT}"
fi

# Export toolchain paths
export PATH="${HOME}/toolchains/clang-r416183b/bin:${PATH}"
export LD_LIBRARY_PATH="${HOME}/toolchains/clang-r416183b/lib64:${LD_LIBRARY_PATH}"

# Set cross-compile environment variables
export BUILD_CROSS_COMPILE="${HOME}/toolchains/gcc/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-"
export BUILD_CC="${HOME}/toolchains/clang-r416183b/bin/clang"

# Build options for the kernel
export BUILD_OPTIONS=(
    -C "${KERNEL_ROOT}"
    O="${KERNEL_ROOT}/out"
    -j"$(nproc)"
    ARCH=arm64
    LLVM=1
    LLVM_IAS=1
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
