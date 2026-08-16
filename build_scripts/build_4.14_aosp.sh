#!/bin/bash
# Copyright (c) 2026 ravindu644 <droidcasts@protonmail.com>
# SPDX-License-Identifier: GPL-2.0-or-later
#
# Linux 4.14 AOSP/LineageOS arm64 kernel build script.
# Toolchain: Neutron Clang (LLVM only -- no GCC cross compiler needed)
#
# Put this in your kernel root, edit the settings below, then run:
#   chmod +x build_4.14_aosp.sh && ./build_4.14_aosp.sh

set -euo pipefail

# ---------------------------------------------------------------------------
#  SETTINGS -- the only part you normally need to touch
# ---------------------------------------------------------------------------
DEFCONFIG="your_defconfig"     # name from arch/arm64/configs (also: vendor/foo_defconfig)
EXTRA_CONFIGS=()               # fragments merged on top, e.g. (custom.config)
KERNEL_IMAGE="Image"           # Image | Image.gz | Image.gz-dtb  (MediaTek needs Image.gz)
USE_OUT_DIR=1                  # 0 = build in-tree; most Samsung Exynos trees need 0
MENUCONFIG=1                   # 0 = skip the menuconfig GUI
export KBUILD_BUILD_USER="@ravindu644"

# Some OEM trees need extra variables -- check README_Kernel.txt or build_kernel.sh:
# export TARGET_SOC=s5e9925 PLATFORM_VERSION=12 ANDROID_MAJOR_VERSION=s
# ---------------------------------------------------------------------------

KERNEL_ROOT="$(dirname "$(readlink -f "$0")")"
CLANG="${HOME}/toolchains/neutron-clang"
cd "${KERNEL_ROOT}"

info(){ echo -e "\n[INFO]: $*\n"; }
die(){ echo -e "\n[ERROR]: $*\n" >&2; exit 1; }

install_neutron(){
    [ -d "${CLANG}" ] && return 0
    info "Setting up Neutron Clang..."
    mkdir -p "${CLANG}" && cd "${CLANG}"
    { curl -LfO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman" \
        && bash antman -S && bash antman --patch=glibc ; } \
        || { cd "${KERNEL_ROOT}"; rm -rf "${CLANG}"; die "Failed to set up Neutron Clang"; }
    cd "${KERNEL_ROOT}"
}

RPM_PKGS=(make gcc gcc-c++ bc bison flex pkgconf git curl tar xz zip unzip cpio rsync kmod
          perl python3 openssl openssl-devel openssl-devel-engine elfutils-libelf-devel dwarves
          ncurses-devel zlib-devel libyaml-devel lz4 zstd dtc)
DEB_PKGS=(build-essential bc bison flex pkg-config git curl tar xz-utils zip unzip cpio rsync
          kmod perl python3 python-is-python3 libssl-dev libelf-dev pahole libncurses-dev
          zlib1g-dev libyaml-dev lz4 zstd device-tree-compiler)

install_deps(){
    local missing=() available=() p
    if command -v rpm &>/dev/null; then
        # --whatprovides, not -q: some names are virtual now (zlib-devel -> zlib-ng-compat-devel)
        for p in "${RPM_PKGS[@]}"; do
            rpm -q --whatprovides "$p" &>/dev/null || missing+=("$p")
        done
        [ "${#missing[@]}" = 0 ] && return 0
        info "Installing: ${missing[*]}"
        sudo dnf install -y --skip-unavailable "${missing[@]}" || die "dnf failed"
    elif command -v dpkg &>/dev/null; then
        for p in "${DEB_PKGS[@]}"; do
            [ "$(dpkg-query -W -f='${db:Status-Status}' "$p" 2>/dev/null)" = installed ] || missing+=("$p")
        done
        [ "${#missing[@]}" = 0 ] && return 0
        # drop whatever this release no longer ships (e.g. libtinfo5 on Ubuntu 24.04+)
        for p in "${missing[@]}"; do apt-cache show "$p" &>/dev/null && available+=("$p"); done
        [ "${#available[@]}" = 0 ] && return 0
        info "Installing: ${available[*]}"
        sudo apt update && sudo apt install -y "${available[@]}" || die "apt failed"
    else
        info "Unknown package manager -- install the kernel build dependencies yourself."
    fi
}

[ -f Makefile ] && [ -d arch/arm64 ] || die "Run this from the kernel source root."
install_deps
[ -f .gitmodules ] && git submodule update --init --recursive

install_neutron
export PATH="${CLANG}/bin:${PATH}"
export LD_LIBRARY_PATH="${CLANG}/lib:${CLANG}/lib64:${LD_LIBRARY_PATH:-}"

BUILD_OPTIONS=(
    -j"$(nproc)"
    ARCH=arm64
    LLVM=1
    LLVM_IAS=1
    # not a GCC path -- it only tells clang which --target to use on older trees
    CROSS_COMPILE=aarch64-linux-gnu-
    HOSTCC=gcc
    HOSTCXX=g++
)

if [ "${USE_OUT_DIR}" = 1 ]; then
    BUILD_OPTIONS+=(O="${KERNEL_ROOT}/out")
    BOOT_DIR="${KERNEL_ROOT}/out/arch/arm64/boot"
else
    BOOT_DIR="${KERNEL_ROOT}/arch/arm64/boot"
fi

build_kernel(){
    info "Kernel $(make kernelversion) | defconfig: ${DEFCONFIG}"

    make "${BUILD_OPTIONS[@]}" "${DEFCONFIG}" "${EXTRA_CONFIGS[@]}" || die "Failed to write .config"

    if [ "${MENUCONFIG}" = 1 ]; then
        make "${BUILD_OPTIONS[@]}" menuconfig
    fi

    make "${BUILD_OPTIONS[@]}" "${KERNEL_IMAGE}" || die "Build failed"

    mkdir -p "${KERNEL_ROOT}/build"
    cp "${BOOT_DIR}/${KERNEL_IMAGE}" "${KERNEL_ROOT}/build/"
    info "Done -> build/${KERNEL_IMAGE}"
}

build_kernel
