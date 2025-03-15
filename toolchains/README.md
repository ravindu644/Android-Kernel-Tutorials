# Toolchains I've Used to Compile Kernels for Various Devices

#### 1. **Linux 4.9:** [proton-12](https://github.com/ravindu644/proton-12.git), [linaro-aarch64-7.5](https://kali.download/nethunter-images/toolchains/linaro-aarch64-7.5.tar.xz)

- Tested on Linux 4.9.227 - 4.9.309
- Usage: [here](https://github.com/ravindu644/kernel_samsung_a01/blob/0239d1e7970a506f0e57e2e6bd416a666ab46d9d/build.sh#L11)

#### 2. **Linux 4.14:**

- **One UI with Knox:** [clang-4639204-cfp-jopp](https://github.com/ravindu644/samsung_exynos9820_stock/tree/stable/toolchain/clang/host/linux-x86/clang-4639204-cfp-jopp), [gcc-cfp-jopp-only/aarch64-linux-android-4.9](https://github.com/ravindu644/samsung_exynos9820_stock/tree/stable/toolchain/gcc-cfp/gcc-cfp-jopp-only/aarch64-linux-android-4.9)
  - Tested on Linux 4.14.113
  - Usage: [here](https://github.com/ravindu644/samsung_exynos9820_stock/blob/b5e453e4ae7bd58ad5a92d2077dee7a15d72134c/build.sh#L60)

- **Common 4.14:** to-do

- **AOSP Based Kernels (lineage):** [neutron-clang](https://github.com/Neutron-Toolchains/antman), [arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu](https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)
  - Tested on Linux 4.14.355
  - Usage: [here](https://github.com/ravindu644/android_kernel_aosp_exynos9820/blob/36bb690483a22463d2d77e0431a1f19663c5a53e/build.sh#L46)

#### 3. **Linux 4.19:**

1. Tested on Linux 4.19.191: [arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu](https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz), [clang-r383902](https://android.googlesource.com/platform//prebuilts/clang/host/linux-x86/+archive/3857008389202edac32d57008bb8c99d2c957f9d/clang-r383902.tar.gz)
   - Usage: [here](https://github.com/ravindu644/A346E_5G_Kernel/blob/1b05453c4d2d2b03634cd64e7c81eb5aa2b7512f/build_kernel.sh#L17)

2. Tested on Linux 4.19.198: [clang-r353983c](https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/emu-29.0-release/clang-r353983c.tar.gz), [aarch64-linux-android-4.9](https://github.com/ravindu644/android_kernel_a047f_eur/tree/sus/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9)
   - Usage: [here](https://github.com/ravindu644/android_kernel_a047f_eur/blob/45ba5ede76bb5ba920445e410ba62344b1e9d878/build.sh#L17)

#### 4. **Linux 5.10:** [clang-r416183b](https://android.googlesource.com/platform//prebuilts/clang/host/linux-x86/+archive/b669748458572622ed716407611633c5415da25c/clang-r416183b.tar.gz), [arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu](https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)

- Tested on Linux 5.10.198
- Usage: [here](https://github.com/ravindu644/android_kernel_s23fe/blob/6413302587aa865a16bc04a9a835479ce3a4beee/build_kernel.sh#L15)

#### 5. **Linux 5.15 & any other GKI Kernel:** [neutron-clang](https://github.com/Neutron-Toolchains/antman), [arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu](https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)

- Tested on Linux 5.15.123 - 5.15.149
- Usage: [here](https://github.com/ravindu644/android_kernel_m145f_common/blob/c3a3a4ab9df28005200fa516f1a8ed9913bf50d6/build.sh#L27)

#### **Additional Notes:** 

- In MediaTek Kernels, you must use *arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu* toolchain alongside a proper Clang compiler to make the kernel boot :)