### Common Errors When Compiling Older Kernels (4.4, 4.9, 4.14)

- Feel free to contribute to this documentation by explaining the issue and linking the commit that helped you fix it.

    1. Fix: `../scripts/gcc-version.sh: line 25: aarch64-linux-gnu-gcc: command not found`

        - [Patch](../patches/002.fix_aarch64-linux-gnu-gcc-command-not-found.patch), [Commit](https://github.com/ravindu644/kernel_samsung_a01/commit/c489c13c60b258dfdb4bb49711e691002cfcc8e3)

    2. Fix: `-fstack-protector-strong not supported by compiler`

        - This happens when the compiler is not compatible with your source code. It is recommended to try changing the compiler instead of using this patch.

        - Be warned that using this patch may make your device vulnerable.

        - [Patch](../patches/003.fix_fstack-protector-strong-not-supported-by-compiler.patch), [Commit](https://github.com/ravindu644/kernel_samsung_a01/commit/8bb6d7bde85a90ef18b7605c55b2c1f6e0b7cdcb)

    3. Fix: `multiple definition of 'yylloc'`

        - **Note:** If you are unable to find the `scripts/dtc/dtc-lexer.lex.c_shipped` file, that's fine.

        - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/32ace01940d8fb26f809171c6bc9846fb6810181)    

    4. Fix: `#error New address family defined, please update secclass_map.`

        - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/571d9d222935054158ade009dc6ef9237634eebf)

    5. Fix: `sec_debug_test.c:773:(.text+0x1044): relocation truncated to fit: R_AARCH64_LDST64_ABS_LO12_NC against...`

        - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/9737a7740f98a1dc90a02556d878f81a975d56c1)

    6. Fix: `fatal error: 'linux/state_notifier.h' file not found`

        - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/75a7c07c13868f051ee1501347fb220c9aa0ef95)
        
    7. Fix: `./include/linux/ologk.h:5:10: fatal error: 'olog.pb.h' file not found`

        - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/abbbbfe0b0e85853ac59e8661de1da57cbf2466a)

    8. Fix: `drivers/misc/tzdev/tz_deploy_tzar: fix startup.tzar inclusion`

        - [Commit](https://github.com/ravindu644/samsung_exynos9820_stock/commit/429bce31c68e9a8d779c0c8a8303799fc11df1d6)
