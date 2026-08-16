# ⚡ Build scripts

[← Back to the main guide](../README.md)

One script per kernel version. Drop the right one into your kernel root, edit the
`SETTINGS` block at the top, and run it.

## Which one do I need?

Run `make kernelversion` inside your kernel root, then pick the matching script:

| Your kernel version | Script |
| --- | --- |
| 4.9 | `build_4.9.sh` |
| 4.14 (OEM or stock source) | `build_4.14.sh` |
| 4.14 (AOSP or LineageOS source) | `build_4.14_aosp.sh` |
| 4.19 | `build_4.19.sh` |
| 5.4 (Qualcomm, aka qGKI) | `build_5.4.sh` or `build_qGKI.sh` |
| 5.10 | `build_5.10.sh` |
| 5.15 | `build_5.15.sh` |
| 6.1 and newer | `build_6.1.sh` |

`build_5.4.sh` and `build_qGKI.sh` are the same script under two names, because
qGKI kernels are 5.4 kernels.

## What a script does when you run it

1. Checks which build packages you are missing, and installs only those. It does
   this on every run, so it is quick after the first time.
2. Downloads the toolchain it needs into `~/toolchains`, but only if it isn't
   already there.
3. Builds your `.config` from the `DEFCONFIG` you set, plus anything you listed
   in `EXTRA_CONFIGS`.
4. Opens `menuconfig`, unless you set `MENUCONFIG=0`.
5. Compiles, and copies the finished kernel into `build/` in your kernel root.

> [!TIP]
> If a toolchain download fails or you interrupt it, just run the script again. A
> failed download cleans up after itself, so you do not need to delete
> `~/toolchains` by hand.

## Read next

- **How to use one, step by step:** [Method 2 in the main guide](../README.md#-05-preparing-for-the-compilation)
- **What every setting does:** the same section, under "Edit the SETTINGS block"
- **Which toolchain each script uses, and why:** [step 04 in the main guide](../README.md#-04-choosing-the-right-compiler)
- **Every toolchain with download links:** [toolchains/](../toolchains/)

---

[← Back to the main guide](../README.md)
