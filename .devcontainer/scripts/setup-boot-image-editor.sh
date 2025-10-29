#!/bin/sh

set -e

# sKETCHY way to initialize boot image editor :3
cd "$HOME"
curl -LO "https://github.com/cfig/Android_boot_image_editor/releases/download/v15_r1/boot_editor_v15_r1.zip"
unzip boot_editor_v15_r1.zip && rm -rf boot_editor_v15_r1.zip
cd boot_editor_v15_r1
curl -LO "https://github.com/ravindu644/android_kernel_m145f_common/raw/refs/heads/M145FXXU4CXG4/prebuilts/Android_boot_image_editor/boot.img" &
curl -LO "https://github.com/ravindu644/android_kernel_m145f_common/raw/refs/heads/M145FXXU4CXG4/prebuilts/Android_boot_image_editor/vbmeta.img" &
wait
bash gradlew unpack
bash gradlew clear
rm -f boot.img vbmeta.img