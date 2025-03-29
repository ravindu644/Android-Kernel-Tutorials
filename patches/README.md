### Common Errors When Compiling Older Kernels (4.4, 4.9, 4.14)

#### Feel free to contribute to this documentation by explaining the issue and linking the commit that helped you fix it.

> [!NOTE]  
> How to apply a patch file?  
>  
> `patch -p1 < filename.patch`  
>  
> However, **I recommend opening the patch file in a code editor and manually editing your files for better understanding.**
>
> - Not all patch files can be applied using the command above.


<br>

---
- **If the errors you are facing are related to `-Werror`, aka treating warnings as errors,** [you can use this patch](../patches/009.fix-Werror.patch) to disable treating warnings as errors, **even though it's not a good practice :)**

---
<br>

1. Fix: `../scripts/gcc-version.sh: line 25: aarch64-linux-gnu-gcc: command not found`

    - [Patch](../patches/002.fix_aarch64-linux-gnu-gcc-command-not-found.patch), [Commit](https://github.com/ravindu644/kernel_samsung_a01/commit/c489c13c60b258dfdb4bb49711e691002cfcc8e3)

2. Fix: `-fstack-protector-strong not supported by compiler`

    - This happens when the compiler is not compatible with your source code. It is recommended to try changing the compiler instead of using this patch.

    - Be warned that using this patch may make your device vulnerable.

    - [Patch](../patches/003.fix_fstack-protector-strong-not-supported-by-compiler.patch), [Commit](https://github.com/ravindu644/kernel_samsung_a01/commit/8bb6d7bde85a90ef18b7605c55b2c1f6e0b7cdcb)

3. Fix: `multiple definition of 'yylloc'`

    - **Note:** If you are unable to find the `scripts/dtc/dtc-lexer.lex.c_shipped` file, that's fine.

    - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/32ace01940d8fb26f809171c6bc9846fb6810181), [Patch](./018.yylloc.patch)

4. Fix: `#error New address family defined, please update secclass_map.`

    - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/571d9d222935054158ade009dc6ef9237634eebf), [Patch](./019.secclass.patch)

5. Fix: `sec_debug_test.c:773:(.text+0x1044): relocation truncated to fit: R_AARCH64_LDST64_ABS_LO12_NC against...`

    - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/9737a7740f98a1dc90a02556d878f81a975d56c1), [Patch](./020.sec_debug_test.patch)

6. Fix: `fatal error: 'linux/state_notifier.h' file not found`

    - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/75a7c07c13868f051ee1501347fb220c9aa0ef95)
    
7. Fix: `./include/linux/ologk.h:5:10: fatal error: 'olog.pb.h' file not found`

    - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/abbbbfe0b0e85853ac59e8661de1da57cbf2466a), [Patch](./021.ologk.patch)

8. Fix: `drivers/misc/tzdev/tz_deploy_tzar: fix startup.tzar inclusion`

    - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/429bce31c68e9a8d779c0c8a8303799fc11df1d6)

9. Fix: `ioctl_cfg80211.c: error: too many arguments to function call, expected 3, have 8`

    - [Commit](https://github.com/ravindu644/kernel_samsung_a01/commit/a787bb1da52a27a61225acbc037c0dba65110a43)

10. Fix: `drivers/input/touchscreen/gt1151q_1695/gt1x_test.c: multiple definition of 'is_space'`

    - [Commit](https://github.com/ravindu644/kernel_samsung_a01/commit/896574bace78ed509d9b7270c55a7c06c6f1e975)

11. Fix: ```yamltree.c:(.text+0xa41): undefined reference to `yaml_emitter_initialize'```

    - [Commit](https://github.com/rsuntkOrgs/kernel_samsung_a03/commit/6addccd5a82d4dc1c31faee50175358cb3f347f5)

12. Fix: `as: unrecognized option '-EL'`

    - [Commit](https://github.com/kdrag0n/proton_zf6/commit/6e87fec9a3df5)

13. Fix: `undefined reference to 'stpcpy'`

    - [Commit](https://github.com/kdrag0n/proton_zf6/commit/cec73f0775526)

14. Fix: `../kernel/gen_kheaders.sh: 71: ../tools/build/cpio: not found`

    - [Patch](./015.fix_gen_kheaders.sh_cpio_not_found.patch), [Commit](https://github.com/ravindu644/android_kernel_a166p/commit/ce3c8ebf03124ce6a35038f8404a6a61a9cbc296)
    - You must export the Kernel root like this if you are not using my build scripts:
    
        ```bash
        export KERNEL_ROOT="(pwd)"
        ```