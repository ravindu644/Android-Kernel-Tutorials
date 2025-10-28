#!/bin/sh

set -e

# Init arm gnu toolchain
mkdir -p "$HOME/toolchains/gcc" && \
    cd "$HOME/toolchains/gcc" && \
    curl -LO "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz" && \
    tar -xf arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz && \
    rm arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz

# comment export below if you have compiler that does not conflicts with this one
echo PATH="\$PATH:\$HOME/toolchains/gcc/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-" >> $HOME/.bashrc

# Init neutron-clang
mkdir -p "$HOME/toolchains/neutron-clang" && \
    cd "$HOME/toolchains/neutron-clang" && \
    curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman" && chmod +x antman && \
    bash antman -S && bash antman --patch=glibc

# Init android-partition-tools
git clone https://github.com/ravindu644/android-partition-tools.git $HOME/android-partition-tools --depth=1
echo PATH="\$PATH:\$HOME/android-partition-tools" >> $HOME/.bashrc


# sKETCHY way to initialize boot image editor :3
(cd "$HOME" && \
    curl -LO "https://github.com/cfig/Android_boot_image_editor/releases/download/v15_r1/boot_editor_v15_r1.zip" && \
    unzip boot_editor_v15_r1.zip && rm -rf boot_editor_v15_r1.zip && \
    cd boot_editor_v15_r1 && \
    curl -LO "https://github.com/ravindu644/android_kernel_m145f_common/raw/refs/heads/M145FXXU4CXG4/prebuilts/Android_boot_image_editor/boot.img" && \
    curl -LO "https://github.com/ravindu644/android_kernel_m145f_common/raw/refs/heads/M145FXXU4CXG4/prebuilts/Android_boot_image_editor/vbmeta.img" && \
    bash gradlew unpack && \
    bash gradlew clear && \
    rm -f boot.img vbmeta.img)