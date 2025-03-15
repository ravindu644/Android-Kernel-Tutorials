### Toolchains I've used to compile kernels for Various devices

<hr>

01. **Linux 4.9:** [proton-12](https://github.com/ravindu644/proton-12.git), [linaro-aarch64-7.5](https://kali.download/nethunter-images/toolchains/linaro-aarch64-7.5.tar.xz)

    - Usage: [here](https://github.com/ravindu644/kernel_samsung_a01/blob/0239d1e7970a506f0e57e2e6bd416a666ab46d9d/build.sh#L11)

02. **Linux 4.14:**

    - **One UI with Knox (S10/N10 series):** [clang-4639204-cfp-jopp](https://github.com/ravindu644/samsung_exynos9820_stock/tree/stable/toolchain/clang/host/linux-x86/clang-4639204-cfp-jopp), [gcc-cfp-jopp-only/aarch64-linux-android-4.9](https://github.com/ravindu644/samsung_exynos9820_stock/tree/stable/toolchain/gcc-cfp/gcc-cfp-jopp-only/aarch64-linux-android-4.9)

        - Usage: [here](https://github.com/ravindu644/samsung_exynos9820_stock/blob/b5e453e4ae7bd58ad5a92d2077dee7a15d72134c/build.sh#L60)

    - **Common 4.14:** to-do

    - **AOSP Based Kernels (lineage):** [neutron-clang](https://github.com/Neutron-Toolchains/antman), [arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu](https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)

        - Usage: [here](https://github.com/ravindu644/android_kernel_aosp_exynos9820/blob/36bb690483a22463d2d77e0431a1f19663c5a53e/build.sh#L46)