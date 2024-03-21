<h1> How to Compile the Kernel for <s>APatch</s> for Unsupported Devices..? </h1>

```
Screw APatch..🤡 Learn something new from here..❤️
```

---

**What You'll Need:**
A Working 🧠, PC/RDP with any Linux GUI distro, Knowledge of basic commands in Linux, Understanding of English.

#### Additional Notes:

- If you're feeling a bit lazy to install a Linux distro, you can also use [Gitpod](https://gitpod.io/workspaces). Keep in mind, though, it might be more challenging.
- I'm not sure compiled kernels will work on MediaTek devices because their kernel sources are missing some drivers for MTK.
- Also, if you have a most recent Samsung device, building should be hard because of the new GKI kernels.
	
### Requirements for compiling kernels : (Paste this in terminal.)
 ```
sudo apt update -y ; sudo apt install default-jdk git-core gnupg flex bison gperf build-essential zip curl libc6-dev libncurses5-dev x11proto-core-dev libx11-dev libreadline6-dev libgl1-mesa-glx libgl1-mesa-dev python3 make sudo gcc g++ bc grep tofrodos python3-markdown libxml2-utils xsltproc zlib1g-dev libncurses5 python-is-python3 libc6-dev libtinfo5 ncurses-dev make python2 repo cpio kmod openssl libelf-dev pahole libssl-dev libelf-dev -y
```
<br>❗The video Guide for this tutorial can be found here : Open in YouTube </h3>
<br>
### Quick Links :
01. ✅ [Downloading Part. (Only for samsung)](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#--downloading-part-only-for-samsung)
02. ✅ [Compiling Part (Universal for any device).](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#--compiling-part-universal-for-any-device)
03. ✅ [(❗ Samsung Specific) How to disable kernel securities from the menuconfig..?](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#--samsung-specific-how-to-disable-kernel-securities-from-the-menuconfig)
04. ✅ [How to make your kernel supports with APatch..?](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#-how-to-make-your-kernel-supports-with-apatch)
05. ✅ [Compilation Process.](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#-compilation-process)
06. ✅ [(FINAL) How to put the compiled kernel, inside our boot.img..?](https://github.com/ravindu644/Android-Kernel-Tutorials?tab=readme-ov-file#-final-how-to-put-the-compiled-kernel-inside-our-bootimg)

<hr>
<h2> ✅ Downloading Part. (Only for samsung)</h2>
<hr>

### 01. Download the kernel source from the [Samsung Opensource]( https://opensource.samsung.com/main).
<img src="https://github.com/ravindu644/APatch/assets/126038496/aad04d45-e1b3-4baf-a8e0-2ef27d7dae55" width="45%">

### 02. Extract the ```Kernel.tar.gz``` from the source zip, unarchive it using this command.
```
tar -xvf Kernel.tar.gz; rm Kernel.tar.gz
```
#### Additional note : If your Kernel source's folders are locked like this, you can change the entire folder's permissions to read and write.
- Problem : <br><img src="https://github.com/ravindu644/APatch/assets/126038496/11565943-f329-4782-b7e9-0f0d0b8ee2fd" width="55%">
- Solution : <br><img src="https://github.com/ravindu644/APatch/assets/126038496/8d975f38-ea65-458c-b0f3-0544c3b4303b" width="45%">

<hr>

- **⚠️ For other devices,** You can find them by your OEM's sites or from your OEM's **official** GitHub repos.
<h2> ✅ Compiling Part (Universal for any device).</h2>
<hr>

### 01. After downloading or cloning the Kernel Source, We must make a Script to compile our kernel.

- Before making a build script, we must download compilers to build the kernel.
- if you own a **Snapdragon/Mediatek device**, I recommend you to use Google's Compilers.
- You can clone them using this command : **(❗only for every Snapdragon/Mediatek devices from any OEM)**
```
cd ~
git clone https://github.com/ravindu644/Toolchains_by_Google.git
```
- Or, If you prefer Qualcomm's own compilers rather than Google's, you can clone them using this command :
```
cd ~
git clone https://github.com/ravindu644/Toolchains_for_Snapdragon.git
```
- Or, If you prefer Proton clang to compile the kernel (Qualcomm and Mediatek), Jump to this Guide : [Click here](additional-guides/proton.md)
<hr>

**Notes : (Samsung exynos specific)** If your device is exynos, Open the **"README_Kernel.txt"** and download the toolchains by Googling the values for "```CC```" and "```CROSS_COMPILE```". You can find them easily from the Google Opensource or github.
- For an Example :
  <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/c06fdc3f-536b-47b8-927f-f3ce23b43890" width="75%">

- Now, Open the terminal from your Kernel source's folder and create a new file called ```build.sh``` using this command :
```
touch build.sh
```
- Open the newly created ```build.sh``` and make that file looks like this : **(⚠️ This code is only for Snapdragon and Mediatek devices and not for Exynos)**
- **The reason for that is**, Snapdragon and Mediatek kernel sources only supported to compile to a seperated directory called "out".
- Here's the code : ⬇️
```
#!/bin/bash
clear
export ARCH=arm64
export PLATFORM_VERSION=13
export ANDROID_MAJOR_VERSION=t
ln -s /usr/bin/python2.7 $HOME/python
export PATH=$HOME/:$PATH
mkdir out

ARGS='
CC=$HOME/Toolchains_by_Google/clang-10.0/bin/clang
CROSS_COMPILE=$HOME/Toolchains_by_Google/aarch64-4.9/bin/aarch64-linux-android-
CLANG_TRIPLE=aarch64-linux-gnu-
ARCH=arm64
'
make -C $(pwd) O=$(pwd)/out ${ARGS} clean && make -C $(pwd) O=$(pwd)/out ${ARGS} mrproper #to clean the source
make -C $(pwd) O=$(pwd)/out ${ARGS} YOUR_DEFCONFIG #making your current kernel config
make -C $(pwd) O=$(pwd)/out ${ARGS} menuconfig #editing the kernel config via gui
make -C $(pwd) O=$(pwd)/out ${ARGS} -j$(nproc) #to compile the kernel

#to copy all the kernel modules (.ko) to "modules" folder.
mkdir -p modules
find . -type f -name "*.ko" -exec cp -n {} modules \;
echo "Module files copied to the 'modules' folder."
```
- **❗If your Device is Samsung Exynos, It does't supports the compiling kernel in a separate directory. So, the code must be like this :**
```
#!/bin/bash
clear
export ARCH=arm64
export PLATFORM_VERSION=13
export ANDROID_MAJOR_VERSION=t
ln -s /usr/bin/python2.7 $HOME/python
export PATH=$HOME/:$PATH

ARGS='
CC=$HOME/path/to/clang/bin/clang
CROSS_COMPILE=$HOME/path/to/gcc/bin/aarch64-linux-android-
CLANG_TRIPLE=aarch64-linux-gnu-
ARCH=arm64
'

make ${ARGS} clean && make ${ARGS} mrproper #to clean the source
make ${ARGS} YOUR_DEFCONFIG #making your current kernel config
make ${ARGS} menuconfig #editing the kernel config via gui
make ${ARGS} -j$(nproc) #to compile the kernel

#to copy all the kernel modules (.ko) to "modules" folder.
mkdir -p modules
find . -type f -name "*.ko" -exec cp -n {} modules \;
echo "Module files copied to the 'modules' folder."
```
<hr>

### Notes :
- Edit the ```PLATFORM_VERSION``` value to your Android version.
- Edit the ```ANDROID_MAJOR_VERSION``` value to your Android version's codename.
- Edit ```CC``` value with the path to the clang's \[bin folder]/clang.
- Edit ```CROSS_COMPILE``` value with the path to the GCC's \[bin folder]/aarch64-linux-android-
- Replace ```YOUR_DEFCONFIG``` to your current defconfig which is located in arch/arm64/configs.
### 02. Edit the Makefile.
- if you found these variables : ```CROSS_COMPILE```, ```REAL_CC``` or ```CC```, ```CFP_CC``` in your "makefile" ; remove them from the "Makefile"
- search "wrapper" in your makefile. If there's a line related to a python file, remove that entire line/function too.
- Search ```CONFIG_CC_STACKPROTECTOR_STRONG``` and replace it with ```CONFIG_CC_STACKPROTECTOR_NONE```

<hr>


### Our build script must looks like this, after making the changes: (This is an example.)
  <img src="https://github.com/ravindu644/APatch/assets/126038496/c0533f93-867f-4d21-8782-8b33b904d68f" width="80%">
  
### 03.❗ Bug fixing in the Kernel Source.  (These are the universal errors for all the snapdragon kernel sources)
- To fix the "symbol versioning failure for gsi_write_channel_scratch" error : [Click here](https://github.com/ravindu644/android_kernel_samsung_sm_a525f/commit/0cc860c380b3b35a5cd4db039b8c3fd03db7c771)
- Also, you will faced an error called ```scripts/gcc-version.sh: line 25: aarch64-linux-gnu-gcc: command not found``` if you used the Google's compilers, You can fix them too using this commit : [Click here](https://android.googlesource.com/kernel/msm/+/9b3a54e388fae0fcc5ea64a4c612936baae44fce%5E%21/)
- To force load the vendor modules in some devices (Universal) ⚠️ (This fixes various hardware related issues after installing a custom kernel) - [Click here](https://github.com/rama982/kernel_common/commit/d5e8b83f0c5eee4e2f8c6d9888cc56d03f2615fb)

## Now we finished setting up the basic configurations for kernel compilation.

### 04. Now, grant the executable permissions to ```build.sh``` using this command.
  ```
  chmod +x build.sh
  ```
### 05. Finally, run the build script using this command :
  ```
./build.sh
```
## After a couple of seconds, the "menuconfig" should appear.
- Additional notes : Press space bar to enable/disable or enable as a module <M>.
<hr>

## ✅ (❗ Samsung Specific) How to disable kernel securities from the menuconfig..?
<hr>

### 01. ```→ Kernel Features``` => Disable "```Enable RKP (Realtime Kernel Protection) UH feature```", "```Enable LKM authentication by micro hypervisor```", "```Block LKM by micro hypervisor```", "```Enable micro hypervisor feature of Samsung```" respectively.
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/d821da9f-0b45-4701-b681-3996bec509be" width="75%">

### 02. ```→ Kernel Features → Control Flow Protection``` => Disable "```JOP Prevention```", "```ROP Prevention```" and "```JOPP and ROPP```" Respectively.
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/58e0680a-8052-4df8-aba1-cb282d6963ee" width="75%">

### Additional notes : 
- If you can't find them (01 and 02) in the "```→ Kernel Features```", they are located in the "```→ Boot options```".
<hr>

## ❗In Android 14 and some Android 13 sources, they are located in ```→ Hypervisor```. Disable them ALL!
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/eb67e7fd-46ff-4aa7-a424-73e22f1d29da" width="75%">
- As I mentioned at the beginning of this guide, your must use your brain..! 🧠

<hr>

### 03. ```→ Security options``` => Disable "```Integrity subsystem```" and "```Defex Support```".
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/ca396e53-26fc-4ee4-99ea-c8359926ea51" width="75%">
<hr>

## ✅ How to make your kernel supports with APatch..?
<hr>

### 01. Open ```→ General setup → Local version - append to kernel release``` => Choose any string you like.
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/448a24b9-454b-47b9-82a8-0b9c2804e693">
### 02. Open ```→ Kernel hacking``` => Turn on the ```Kernel debugging``` ❗.
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/54eaf94a-3d7e-44ca-81aa-093b76ed9893">
### 03. ```→ General setup → Configure standard kernel features (expert users)``` => Enable everything except "```sgetmask/ssetmask syscalls support``` and ```Sysctl syscall support```"
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/8927d898-d3ef-471a-8f68-bbe418068565" width="75%">
### 04. ```→ Enable loadable module support``` => Enable "```Forced module loading```", "```Module unloading```", "```Forced module unloading```", "```Module versioning support```" and disable others.
- Image : <br><br><img src="https://github.com/ravindu644/Android-Kernel-Tutorials/assets/126038496/865ddeca-88de-484d-8f99-922b439e0e7c" width="75%"><br><br>
**❗Additional Notes :** To force load the vendor/system modules in some devices, use this commit (⚠️ This fixes various hardware related issues after installing a custom kernel) - [Click here](https://github.com/rama982/kernel_common/commit/d5e8b83f0c5eee4e2f8c6d9888cc56d03f2615fb)

### 05. ```→ Boot options``` => enable "```Build a concatenated Image.gz/dtb by default```" and "```Kernel compression method (Build compressed kernel image)```"  ---> "```(X) Build compressed kernel image```"
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/3c7704a7-ea16-4bee-a0bf-6ecd0424f2b7" width="75%">
### 06. ```→ File systems``` => Enable "```<*> Overlay filesystem support```".
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/0cbff894-ba4c-4f51-a1bd-3ffa1963cd51" width="75%">
<hr>

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

## Written by [@Ravindu_Deshan](https://t.me/Ravindu_Deshan) for [@SamsungTweaks](https://t.me/SamsungTweaks) and [@APatchChannel](https://t.me/APatchChannel) | Sharing this without proper credit is not allowed..❗
