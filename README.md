## A Beginner-Friendly Guide to Compiling Your First Android Kernel..!  

**What You'll Learn:**  

- Downloading the kernel source for your device (Samsung only)
- Understanding the kernel root & choosing the right compilers for compilation
- Customizing the kernel
- Remove Samsung's anti-root protections.  
- Implementing KernelSU (to-do)
- Creating a signed boot image from the compiled kernel

**What You'll Need:** 
- A working 🧠
- Ubuntu/Debian based PC/Server
- Knowledge of basic commands in Linux, and Bash/Shell script knowledge
- Understanding of English.
- Patience

#### Additional Notes:

- You can also use [Gitpod](https://gitpod.io/workspaces) if you don't want to install a Linux distro.  
  - Keep in mind, though, that it might be more challenging for beginners who are not familiar with the command-line interface.  
  - Access the terminal from Gitpod and its GUI using [ravindu644/LinuxRDP](https://github.com/ravindu644/LinuxRDP).
	
### Dependencies for compiling kernels : (Paste this in terminal.)
 ```
sudo apt update && sudo apt install -y git device-tree-compiler lz4 xz-utils zlib1g-dev openjdk-17-jdk gcc g++ python3 python-is-python3 p7zip-full android-sdk-libsparse-utils erofs-utils \
default-jdk git gnupg flex bison gperf build-essential zip curl libc6-dev libncurses-dev libx11-dev libreadline-dev libgl1 libgl1-mesa-dev \
python3 make sudo gcc g++ bc grep tofrodos python3-markdown libxml2-utils xsltproc zlib1g-dev python-is-python3 libc6-dev libtinfo6 \
make repo cpio kmod openssl libelf-dev pahole libssl-dev libarchive-tools zstd --fix-missing && wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb && sudo dpkg -i libtinfo5_6.3-2ubuntu0.1_amd64.deb
```
<br>❗The video Guide for this tutorial can be found here : Open in <a href="https://t.me/SamsungTweaks/137">Telegram</a> </h3>
<br>

### Quick Links :
01. ✅ [Downloading Part (Only for samsung)](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#--downloading-part-only-for-samsung)
02. ✅ [Understanding the Kernel root](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#-understanding-the-kernel-root)
03. ✅ [Understanding non-GKI, qGKI & GKI kernels](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#-understanding-non-gki-qgki--gki-kernels)
04. ✅ [Compiling Part (Universal for any device).](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#--compiling-part-universal-for-any-device)

<hr>
<h2> ✅ Downloading Part. (Only for samsung)</h2>

### 01. Download the kernel source from the [Samsung Opensource]( https://opensource.samsung.com/main).
<img src="./screenshots/1.png">

### 02. Extract the ```Kernel.tar.gz``` from the source zip, unarchive it using this command.
```
tar -xvf Kernel.tar.gz && rm Kernel.tar.gz
```

<img src="./screenshots/2.png">

**Note:** It's a good idea to give the entire kernel directory 755 permissions to remove those 🔒 from the files and folders, preventing any issues when editing files and upstreaming the kernel.

**Do it this way:**

```
chmod +755 -R /path/to/extracted/kernel/
```

**Before:**
<img src="./screenshots/3.png">

**After:**
<img src="./screenshots/4.png">

**The following video demonstrates all the steps mentioned above:** 

[🎥 Extracting Samsung's Kernel.tar.gz & granting required permissions](https://www.youtube.com/watch?v=QLymPkTpC2Y)

<hr>

- **⚠️ For other devices,** You can find them by your OEM's sites or from your OEM's **official** GitHub repos.

## ✅ Understanding `non-GKI`, `qGKI` & `GKI kernels`
```
+--------------------------------------------------------------+
|                 Android LTS Kernel Versions                  |
+--------------------------------------------------------------+
|       non-GKI       |      qGKI      |  GKI 1.0  |  GKI 2.0  |
+---------------------+----------------+-----------+-----------+
|         3.10        |      5.4       |   5.10    |   5.15    |
|         3.18        |                |   4.19    |   6.1     |
|         4.4         |                |           |           |
|         4.9         |                |           |           |
|         4.14        |                |           |           |
|         4.19        |                |           |           |
+---------------------+----------------+-----------+-----------+
```
#### Explanation:

1. **non-GKI**:
   - Includes older and heavily customized kernels used in Android devices before the GKI initiative.
   - Versions like **3.10**, **3.18**, **4.4**, **4.9**, **4.14**, and **4.19** are the most common (LTS Kernels).
   - These kernels are **device-specific** and often modified by OEMs (eg: Samsung).

2. **qGKI (Qualcomm GKI)**:
   - Qualcomm's implementation of GKI, starting with kernel version **5.4**.
   - Used in Qualcomm-based devices that adopt GKI but with Qualcomm-specific modifications.

3. **GKI 1.0**:
   - Google's first iteration of the Generic Kernel Image, starting with kernel version **5.10**.
   - **Note:** In some devices, **4.19** is also considered a **GKI 1.0** kernel, as it was used as a transitional kernel in early GKI implementations.

4. **GKI 2.0**:
   - Google's second iteration of the Generic Kernel Image, starting with kernel version **5.15**.
   - Includes newer LTS kernels like **6.1**.

---

### Notes:
- **LTS = Long-Term Support**: These kernels are stable, well-maintained, and receive long-term updates.
- **GKI = Generic Kernel Image**: A unified kernel framework introduced by Google to standardize the kernel across Android devices.
- **4.19** is primarily a **non-GKI** kernel but is also used in some **GKI 1.0** implementations as a transitional kernel.

## ✅ Understanding the ```Kernel root```

<img src="./screenshots/6.png">

- As you can see in the above screenshot, it's the Linux kernel source code.
- It must have those folders, **highlighted in blue in the terminal.**
- **In GKI kernels,** the kernel root is located in a folder named "common".

- If you have a **GKI Samsung kernel**, you should use the "common" kernel instead of "msm-kernel" for building your kernel, and the build steps are the same as for a non-GKI kernel. [Refer to this repo for an idea](https://github.com/ravindu644/android_kernel_m145f_common).

<h2> ✅ Compiling Part (Universal for any device).</h2>

### 01. After downloading or cloning the Kernel Source, we must have a build script to compile our kernel.

- Before creating a build script, we must determine the compatible compilers we will use to build our kernel.

- Run ```make kernelversion``` inside the kernel root to check your kernel version.

<img src="./screenshots/5.png">

- In my case, the kernel version is **5.4,** which is [qGKI](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#-understanding-non-gki-qgki--gki-kernels).

- You can find full information about **choosing the correct compiler for your kernel version** [here](./toolchains/) (based on my experience, btw).

  - **❗Mediatek users,** read [this](https://github.com/ravindu644/Android-Kernel-Tutorials/tree/main/toolchains#additional-notes).

- Next, go to [build_scripts](./build_scripts/), choose the appropriate script, download it, and place it inside your kernel's root directory.

<img src="./screenshots/7.png">

- Keep in mind that **you don't need to manually download any of these** since my build scripts handle everything for you :)

- **❗If your device is Samsung Exynos, it doesn't support compiling the kernel in a separated 'out' directory. So, [edit your build script like this](./patches/001.nuke_out.patch)**

<hr>

### Notes :
- Replace `your_defconfig` to your current defconfig which is located in `arch/arm64/configs` In GKI kernels, it's normally `gki_defconfig`

- But just in case, make sure to check `arch/arm64/configs` or `arch/arm64/configs/vendor`

- If your defconfig is located in the `arch/arm64/configs` directory, just replace `your_defconfig` with the name of your defconfig.

- If your defconfig is located in the `arch/arm64/configs/vendor` directory, replace `your_defconfig` like this:
  
  - `vendor/name_of_the_defconfig`
  - Example patch: [here](./patches/005.edit-defconfig.patch)


### 02. Edit the Makefile.

- If you find these variables: ```REAL_CC``` or ```CFP_CC``` in your "Makefile", remove them from the "Makefile", then Search for "wrapper" in your Makefile. If there's a line related to a Python file, remove that entire line/function as well.

    - Example patch of removing the wrapper: [click here](./patches/004.remove_gcc%20wrapper.patch)

- Search ```CONFIG_CC_STACKPROTECTOR_STRONG``` and replace it with ```CONFIG_CC_STACKPROTECTOR_NONE```

    - Example patch of fix -fstack-protector-strong not supported by compiler: [click here](./patches/003.fix_fstack-protector-strong-not-supported-by-compiler.patch)

<hr>

### 03. Now, grant the executable permissions to ```build_xxxx.sh``` using this command.
  ```
  chmod +x build_xxxx.sh
  ```
### 04. Finally, run the build script using this command :
  ```
./build_xxxx.sh
```

<img src="./screenshots/8.png">

- When you run the script for the first time, it will begin to install all the necessary dependencies and start downloading the required toolchains, depending on your kernel version.

- Make sure not to interrupt the first run. If it gets interrupted somehow, delete the `toolchains` folder from "~/" and try again: ```rm -rf ~/toolchains```

<img src="./screenshots/9.png">

## After the initial run is completed, the kernel should start building, and the "menuconfig" should appear.

<img src="./screenshots/10.png">

- Additional notes : Press space bar to enable/disable or enable as a module <M>.
<hr>

## 👇👇👇 outdated guide from here \ 2025.03.17 

## ✅ (❗ Samsung Specific) How to disable kernel securities from the menuconfig..?

Outdated, don't read. [Moved to here](./samsung-rkp/README.md)

## ✅ Compilation Process.
<hr>

### 07. Exit and Save the config.
- When you see "```configuration written```", stop the compilation process with ```Ctrl+C``` and replace the content of ".config" with your desired defconfig.
### 08. Compile using ```./build.sh``` --> Skip the menuconfig and wait until the compilation finishes..!
- ℹ️ **The compiled kernel** will be located at out/arch/arm64/boot.
<hr>

#### Notes:

- If you encounter errors during the compilation process, it's advisable to search for these errors on GitHub and find a solution.
  
---

## ✅ (FINAL) How to put the compiled kernel, inside our boot.img..?
<hr>

### 01. Extract the boot.img from the stock ROM/ROM ZIP.  If you are a Samsung user, I prefer https://github.com/ravindu644/Scamsung to do this online.
	- Use exact build number to download the firmware.
### 02. Unpack the boot.img using AIK-Linux which can be found in here : https://github.com/ravindu644/AIK-Linux
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/d5fee81a-6768-4848-a4a6-37fec6cb355f" width="70%"><hr>
## How to check "Which kernel format should I use"..?
- Kernel without GZIP compression : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/cb1d0ff3-32cb-4d98-9892-5a00d1922680" width="70%">
- Kernel <b>with</b> GZIP compression : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/30ee541e-211c-4a84-971b-f67299ee8793" width="70%"><br><br>
# Notes :
- If your split_img has a boot.img-dtb + Uncompressed Kernel => Use "Image".
- If your split_img has a boot.img-dtb + GZIP compressed Kernel => Use "Image.gz".
- If your split_img don't has a boot.img-dtb + uncompressed Kernel => Use "Image-dtb". (if your out/arm64/boot folder don't have such a file, use Image instead)
- If your split_img don't has a boot.img-dtb + GZIP compressed Kernel => Use "Image.gz-dtb".
<hr>

### 03. Choose the required kernel as I mentioned above > Rename it to "```boot.img-kernel```" and copy and replace it with the ```boot.img-kernel```, which is in the split_img folder.
### 04. Repack --> rename "image-new.img" to "boot.img" and make a tar file using this command :
```
tar cvf "DEVICE NAME (APatch Support).tar" boot.img
```
### 05. Flash it using Fastboot/ODIN..!
### 06. DONE..!
- Proof : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/f0dd204d-e398-4ce1-9897-96e6a51b5673" width="75%">
<hr>

## Written by [@Ravindu_Deshan](https://t.me/Ravindu_Deshan) for [@SamsungTweaks](https://t.me/SamsungTweaks)
