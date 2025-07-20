HOW TO INSTALL CUSTOM KERNEL MODULES
====================================

This guide explains how to "install" your newly compiled kernel modules (.ko files) into a stock boot image, like vendor_boot.img or vendor_dlkm.img.

The method is simple: you replace the original module directory with your new one.


WHAT YOU NEED
-------------

1.  An unpacked stock image (the contents of your vendor_boot.img).
2.  The prepared `lib/modules` folder created by our `lkm_installer` script.


THE STEPS
---------

1.  **UNPACK:** Unpack the stock `vendor_boot.img`. This will give you a directory with the original files.

2.  **NUKE:** Go into the unpacked directory and completely delete the original `lib/modules` folder.

3.  **REPLACE:** Copy the new `lib/modules` folder (the one created by our script) into the unpacked directory where the old one used to be.

4.  **REPACK:** Use your tool to repack the modified directory back into a flashable `.img` file.

That's it. The new image now contains all of your custom-built kernel modules.

- Tool to unpack the vendor_boot.img: https://github.com/cfig/Android_boot_image_editor

Example Usage of the script:

```
gitpod /workspace/gitpod/hi (main) $ ./do.sh

Enter the full path to the STOCK modules.dep file: /workspace/gitpod/android_kernel_a166p/custom_defconfigs/modules.dep

Enter the full path to the STOCK modules.load file (for the final step): /workspace/gitpod/android_kernel_a166p/custom_defconfigs/vendor_boot.modules.load


Enter the full path to the CUSTOM compiled module directory (.../staging/lib/modules/kernel_version folder): /workspace/gitpod/android_kernel_a166p/out/target/product/a16xm/obj/KERNEL_OBJ/staging/lib/modules/5.15.167-android13-8-ravindu644-dev

Enter the full path to the System.map file: /workspace/gitpod/android_kernel_a166p/out/target/product/a16xm/obj/KERNEL_OBJ/dist/System.map

Enter the full path to the llvm-strip tool: /workspace/gitpod/android_kernel_a166p/kernel/prebuilts/clang/host/linux-x86/clang-r450784e/bin/llvm-strip


Enter the full path for the FINAL output directory: /workspace/gitpod/hi/vendor_boot

```