# Toolchains I've Used to Compile Kernels for Various Devices

### How to unpack ?:
 - Unpack a tar.xz file: `tar -xvf filename.tar.xz`
 - Unpack a tar.gz file: `tar -xvf filename.tar.gz`

#### 1. **Linux 4.9:** 

1. Tested on 4.9.227-309: [proton-12](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/proton-12.tar.gz), [linaro-aarch64-7.5](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/linaro-aarch64-7.5.tar.xz)

    - Usage: [here](https://github.com/ravindu644/kernel_samsung_a01/blob/0239d1e7970a506f0e57e2e6bd416a666ab46d9d/build.sh#L11)

2. Tested on 4.9.227: [clang-r416183b](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r416183b.tar.gz)

    - Additinal notes:

      ```bash
      CROSS_COMPILE=/path/to/clang/host/linux-x86/clang-r416183b/bin/aarch64-linux-gnu- # check the location of toolchain

      CC=/path/to/clang/host/linux-x86/clang-r416183b/bin/clang # check the location of toolchain
      ```

#### 2. **Linux 4.14:**

1. Tested on 4.14.113 [One UI with Knox]: [clang-4639204-cfp-jopp](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-4639204-cfp-jopp.tar.gz), [gcc-cfp-jopp-only/aarch64-linux-android-4.9](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/gcc-cfp-jopp-only.tar.gz)

    - Tested on Linux 4.14.113
    - Usage: [here](https://github.com/ravindu644/samsung_exynos9820_stock/blob/b5e453e4ae7bd58ad5a92d2077dee7a15d72134c/build.sh#L60)

2. **Common 4.14:** [clang-4639204](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-4639204.tar.gz), [aarch64-linux-android-4.9](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/aarch64-linux-android-4.9.tar.gz)

    - Tested on Linux 4.14.113

3. **AOSP Based Kernels (lineage):** [neutron-clang](https://github.com/Neutron-Toolchains/antman), [arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)

    - Tested on Linux 4.14.355
    - Usage: [here](https://github.com/ravindu644/android_kernel_aosp_exynos9820/blob/36bb690483a22463d2d77e0431a1f19663c5a53e/build.sh#L46)

#### 3. **Linux 4.19:**

1. Tested on Linux 4.19.191: [arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz), [clang-r383902](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r383902.tar.gz)
   - Usage: [here](https://github.com/ravindu644/A346E_5G_Kernel/blob/1b05453c4d2d2b03634cd64e7c81eb5aa2b7512f/build_kernel.sh#L17)

2. Tested on Linux 4.19.198: [clang-r353983c](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r353983c.tar.gz), [aarch64-linux-android-4.9](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/aarch64-linux-android-4.9.tar.gz)
   - Usage: [here](https://github.com/ravindu644/android_kernel_a047f_eur/blob/45ba5ede76bb5ba920445e410ba62344b1e9d878/build.sh#L17)

#### 4. Linux 5.4 qGKI: [llvm-arm-toolchain-ship-10.0.9](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/llvm-arm-toolchain-ship-10.0.9.tar.gz), [aarch64-linux-android-4.9-Linux-5.4](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/aarch64-linux-android-4.9-Linux-5.4.tar.gz)

- Tested on Linux 5.4.249

#### 5. Linux 5.10: [clang-r416183b](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r416183b.tar.gz), [arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)

- Tested on Linux 5.10.198
- Usage: [here](https://github.com/ravindu644/android_kernel_s23fe/blob/6413302587aa865a16bc04a9a835479ce3a4beee/build_kernel.sh#L15)

#### 6. **Other GKI 2.0 Kernels (Linux 5.15, Linux 6.1 or higher):** [neutron-clang](https://github.com/Neutron-Toolchains/antman), [arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)

- Tested on Linux 5.15.123 - 5.15.149
- Usage: [here](https://github.com/ravindu644/android_kernel_m145f_common/blob/c3a3a4ab9df28005200fa516f1a8ed9913bf50d6/build.sh#L27)

#### **Additional Notes:** 

- In MediaTek Kernels, you must use [arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz) toolchain alongside a proper Clang compiler to make the kernel boot :)

    - Reference: [here](https://github.com/ravindu644/android_kernel_a042f/blob/a04e/build_kernel.sh)