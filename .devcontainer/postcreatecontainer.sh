#!/bin/sh

# Init arm gnu toolchain
mkdir -p "/home/kernel-builder/toolchains/gcc" && \
    cd "/home/kernel-builder/toolchains/gcc" && \
    curl -LO "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz" && \
    tar -xf arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz && \
    rm arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz

# Init neutron-clang
mkdir -p "/home/kernel-builder/toolchains/neutron-clang" && \
    cd "/home/kernel-builder/toolchains/neutron-clang" && \
    curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman" && chmod +x antman && \
    bash antman -S && bash antman --patch=glibc

# Init android-partition-tools
git clone https://github.com/ravindu644/android-partition-tools.git /home/builder/android-partition-tools --depth=1
echo PATH=$PATH:/home/kernel-builder/android-partition-tools > /home/builder/.bashrc

# sKETCHY way to initialize boot image editor :3
(cd "/home/kernel-builder" && \
    curl -LO "https://github.com/cfig/Android_boot_image_editor/releases/download/v15_r1/boot_editor_v15_r1.zip" && \
    unzip boot_editor_v15_r1.zip && rm -rf boot_editor_v15_r1.zip && \
    cd boot_editor_v15_r1 && \
    curl -LO "https://github.com/ravindu644/android_kernel_m145f_common/raw/refs/heads/M145FXXU4CXG4/prebuilts/Android_boot_image_editor/boot.img" && \
    curl -LO "https://github.com/ravindu644/android_kernel_m145f_common/raw/refs/heads/M145FXXU4CXG4/prebuilts/Android_boot_image_editor/vbmeta.img" && \
    bash gradlew unpack && \
    bash gradlew clear && \
    rm -f boot.img vbmeta.img)
