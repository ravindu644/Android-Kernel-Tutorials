# 🧰 Toolchains I've used to compile kernels for various devices

[← Back to the main guide](../README.md)

Everything here is from my own builds. "Tested on" means I actually booted it.

> [!TIP]
> **You don't need to download any of these by hand.** The
> [build scripts](../build_scripts/) fetch the right one into `~/toolchains` on
> the first run. This page is for people building without a script, or who want
> to know what their script is pulling.

To unpack one manually:

```bash
tar -xvf filename.tar.xz   # or filename.tar.gz
```

## Do I need a GCC cross compiler too?

This is the thing that confuses people the most, so, short answer:

| Kernel version | What you need |
| --- | --- |
| 4.9 up to 5.4 | Clang **and** a GCC cross compiler |
| 5.10 and newer | Clang only, with `LLVM=1` |

On the older kernels the build system still calls GCC tools like
`aarch64-linux-gnu-ld` to assemble and link, even though Clang compiles the C
code. From 5.10 onward `LLVM=1` points every tool at the LLVM equivalent, so no
GCC cross compiler is downloaded or used at all.

## 1. Linux 4.9

**What `build_4.9.sh` uses:**
[proton-12](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/proton-12.tar.gz)
and [linaro-aarch64-7.5](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/linaro-aarch64-7.5.tar.xz)

- Tested on 4.9.227-309.
- Usage: [build.sh from kernel_samsung_a01](https://github.com/ravindu644/kernel_samsung_a01/blob/0239d1e7970a506f0e57e2e6bd416a666ab46d9d/build.sh#L11)

**Also works:**
[clang-r416183b](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r416183b.tar.gz)

- Tested on 4.9.227.
- This one ships its own `aarch64-linux-gnu-` binaries, so point both variables
  inside it:

  ```bash
  CROSS_COMPILE=/path/to/clang-r416183b/bin/aarch64-linux-gnu-
  CC=/path/to/clang-r416183b/bin/clang
  ```

## 2. Linux 4.14

**What `build_4.14.sh` uses (common 4.14, for devices like realme):**
[clang-r383902b](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r383902b.tar.gz)
and [arm-gnu-toolchain-14.2.rel1](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)

**What `build_4.14_aosp.sh` uses (AOSP and LineageOS sources):**
[neutron-clang](https://github.com/Neutron-Toolchains/antman)

- Tested on Linux 4.14.355.
- Clang only. These trees carry the newer LLVM support, so no GCC is needed.
- Usage: [build.sh from android_kernel_aosp_exynos9820](https://github.com/ravindu644/android_kernel_aosp_exynos9820/blob/36bb690483a22463d2d77e0431a1f19663c5a53e/build.sh#L46)

**Samsung with Knox:**
[clang-4639204-cfp-jopp](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-4639204-cfp-jopp.tar.gz)
and [gcc-cfp-jopp-only](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/gcc-cfp-jopp-only.tar.gz)

- Tested on Linux 4.14.113 (Galaxy S10x).
- Usage: [build.sh from samsung_exynos9820_stock](https://github.com/ravindu644/samsung_exynos9820_stock/blob/b5e453e4ae7bd58ad5a92d2077dee7a15d72134c/build.sh#L60)

**Samsung without Knox:**
[clang-4639204](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-4639204.tar.gz)
and [aarch64-linux-android-4.9](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/aarch64-linux-android-4.9.tar.gz)

- Tested on Linux 4.14.113 (Galaxy M21).

## 3. Linux 4.19

**What `build_4.19.sh` uses:**
[clang-r353983c](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r353983c.tar.gz)
and [arm-gnu-toolchain-14.2.rel1](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)

- Tested on Linux 4.19.198, originally with
  [aarch64-linux-android-4.9](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/aarch64-linux-android-4.9.tar.gz)
  as the cross compiler.
- Usage: [build.sh from android_kernel_a047f_eur](https://github.com/ravindu644/android_kernel_a047f_eur/blob/45ba5ede76bb5ba920445e410ba62344b1e9d878/build.sh#L17)

**Also works:**
[clang-r383902](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r383902.tar.gz)
and the same ARM GNU toolchain

- Tested on Linux 4.19.191.
- Usage: [build_kernel.sh from A346E_5G_Kernel](https://github.com/ravindu644/A346E_5G_Kernel/blob/1b05453c4d2d2b03634cd64e7c81eb5aa2b7512f/build_kernel.sh#L17)

## 4. Linux 5.4 (qGKI)

**What `build_5.4.sh` and `build_qGKI.sh` use:**
[llvm-arm-toolchain-ship-10.0.9](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/llvm-arm-toolchain-ship-10.0.9.tar.gz)
and [arm-gnu-toolchain-14.2.rel1](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)

- Tested on Linux 5.4.249, originally with
  [aarch64-linux-android-4.9-Linux-5.4](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/aarch64-linux-android-4.9-Linux-5.4.tar.gz)
  as the cross compiler.

> [!NOTE]
> This Snapdragon toolchain is the one that needs `libtinfo.so.5`, which no
> current distro ships. The build scripts work around it for you.

## 5. Linux 5.10

**What `build_5.10.sh` uses:**
[clang-r416183b](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r416183b.tar.gz)

- Tested on Linux 5.10.198.
- Clang only. The script still passes `CROSS_COMPILE=aarch64-linux-gnu-`, but
  that is only a target triple for Clang, not a path to any GCC.
- Usage: [build_kernel.sh from android_kernel_s23fe](https://github.com/ravindu644/android_kernel_s23fe/blob/6413302587aa865a16bc04a9a835479ce3a4beee/build_kernel.sh#L15)

## 6. Linux 5.15

**What `build_5.15.sh` uses:**
[clang-r450784e](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/clang-r450784e.tar.gz)

- Tested on Linux 5.15.123 to 5.15.149.
- Clang only, no `CROSS_COMPILE` at all. 5.15 works out its own target.

## 7. Linux 6.1 and newer (other GKI 2.0 kernels)

**What `build_6.1.sh` uses:**
[neutron-clang](https://github.com/Neutron-Toolchains/antman)

- Clang only.
- Usage: [build.sh from android_kernel_m145f_common](https://github.com/ravindu644/android_kernel_m145f_common/blob/c3a3a4ab9df28005200fa516f1a8ed9913bf50d6/build.sh#L27)

## Additional notes

- On MediaTek kernels from the 4.9 to 5.4 era, use the
  [ARM GNU toolchain](https://github.com/ravindu644/Android-Kernel-Tutorials/releases/download/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz)
  alongside a proper Clang to make the kernel boot :)

- The other MediaTek gotcha, on any version, is that they usually cannot boot a
  raw `Image`. Build `Image.gz` instead. In the build scripts that is
  `KERNEL_IMAGE="Image.gz"`.

- Since March 21, 2025 the scripts for 4.9 up to 5.4 use the ARM GNU toolchain as
  their `CROSS_COMPILE`.
  Reference: [build_kernel.sh from android_kernel_a042f](https://github.com/ravindu644/android_kernel_a042f/blob/a04e/build_kernel.sh)

---

[← Back to the main guide](../README.md)
