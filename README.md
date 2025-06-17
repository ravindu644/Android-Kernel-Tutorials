> [!CAUTION]
> **By using this guide, you accept all risks -** including potential device bricking, failed boots, or other issues. **We take no responsibility for any damage.**
> 
> Questions will **only** be considered **if you've read the full documentation** and **done your own research first.**

## A Beginner-Friendly Guide to Compile Your First Android Kernel!

![Android](https://img.shields.io/badge/Android-3DDC84?logo=android&logoColor=white)

# Android Kernel Tutorial: GKI 2.0

**Readings:**  

First, you should read the official Android documentation for kernel building:  
- https://source.android.com/docs/setup/build/building-kernels  
- https://source.android.com/docs/core/architecture/kernel/gki-release-builds

Extras:  
- https://kernelsu.org/guide/how-to-build.html
- https://source.android.com/docs/setup/build/building-pixel-kernels

**What You Need To Know:**  

**Generic Kernel Image (GKI):**
- A Generic Kernel Image (GKI) for Android is a standardized Linux kernel created by Google to reduce device differences and make updates easier. It separates hardware-specific code into loadable modules, letting one kernel work across various devices.

**Android Kernel Evolution: Pre-GKI, GKI 1.0, GKI 2.0:**
- Pre-GKI: Custom kernels forked from the Android Common Kernel, tailored by vendors and OEMs, caused fragmentation and slow updates.
- GKI 1.0: Launched with Android 11 (kernel 5.4), introduced a standardized kernel with vendor modules to reduce fragmentation, but vendor modifications limited success.
- GKI 2.0: Introduced with Android 12 (kernel 5.10+), enforces a stable Kernel Module Interface, separates hardware code, and enables independent updates.

**Kernel version vs Android version:**

Please note: Kernel version and Android version aren't necessarily the same!

If you find that your kernel version is 5.10.101-android12, but your Android system version is Android 13 or other, don't be surprised, because the version number of the Android system isn't necessarily the same as the version number of the Linux kernel. The version number of the Linux kernel is generally correspondent to the version of the Android system that comes with the device when it is shipped. If the Android system is upgraded later, the kernel version will generally not change. Always check kernel version before building!

This tutorial covers GKI 2.0 kernels, the current standard for Android devices.

**Git:**
- Git is a free and open source distributed version control system. Android uses Git for local operations such as branching, commits, diffs, and edits. For help learning Git, refer to the Git documentation.

**Repo:**
- Repo is a Python wrapper around Git that simplifies performing complex operations across multiple Git repositories. Repo doesn't replace Git for all version control operations, it only makes complex Git operations easier to accomplish. Repo uses manifest files to aggregate Git projects into the Android superproject.

**Android kernel manifest:**
- An Android kernel manifest is an XML file (typically named manifest.xml or default.xml) that specifies the Git repositories, branches, and projects required to download the Generic Kernel Image (GKI) source code using the repo tool. It acts as a roadmap for developers to synchronize the kernel source tree from Google's Android Git repositories (e.g., https://android.googlesource.com/kernel/manifest).

### Notes:
- **LTS = Long-Term Support**
- **GKI = Generic Kernel Image**
- **SoC = System on Chip**
- **OEMs = Original Equipment Manufacturers:** like Samsung or OnePlus may still modify GKI 2.0 kernels to accommodate their needs, and can cause some issues like broken SD Card and broken Audio. 
  - **So, use their GKI kernel source instead if possible.** 

**Requirements:**
- A working 🧠
- Linux based PC/Server/VM (This will be done on Ubuntu WSL)
- Basic knowledge in Linux commands and Bash Script.
- Patience
	
### 🛠 Install required dependencies for GKI 2.0 kernels
- The command below only for Debian-based distros like Ubuntu, Linux Mint, Debian and etc.
- You can compile kernels with any distro! **Please search related packages below that match with your distro!**
- Paste the code below in your terminal to start installation:
 
```bash
sudo apt update && sudo apt install git-core gnupg flex bison build-essential zip curl zlib1g-dev libc6-dev-i386 x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig repo
```

### Quick Links :
01. 📁 [Downloading the kernel source code for your device](https://github.com/TheWildJames/Android_Kernel_Tutorials#--downloading-the-kernel-source-code-for-your-device)
02. 🧠 [Understanding the Kernel root](https://github.com/TheWildJames/Android_Kernel_Tutorials?tab=readme-ov-file#-understanding-the-kernel-root)
03. 🧠 [Understanding non-GKI & GKI kernels](https://github.com/TheWildJames/Android_Kernel_Tutorials#-understanding-non-gki--gki-kernels)
04. 👀 [Preparing for the Compilation](https://github.com/TheWildJames/Android_Kernel_Tutorials#--preparing-for-the-compilation)
05. ⚙️ [Customizing the Kernel (Temporary Method)](https://github.com/TheWildJames/Android_Kernel_Tutorials#-customizing-the-kernel-temporary-method)
06. ⚙️ [Customizing the Kernel (Permanent Method)](https://github.com/TheWildJames/Android_Kernel_Tutorials#-customizing-the-kernel-permanent-method)
07. [⁉️ How to nuke Samsung's anti-root protections?](https://github.com/TheWildJames/Android_Kernel_Tutorials#%EF%B8%8F-how-to-nuke-samsungs-anti-root-protections)
08. 🟢 [Additional Patches](https://github.com/TheWildJames/Android_Kernel_Tutorials/tree/main#-additional-patches)
09. ✅ [Compiling the Kernel](https://github.com/TheWildJames/Android_Kernel_Tutorials#-compiling-the-kernel)
10. 🟥 [Fixing the Known compiling issues](https://github.com/TheWildJames/Android_Kernel_Tutorials#-fixing-the-known-compiling-issues)
11. 🟡 [Building a Signed Boot Image from the Compiled Kernel](https://github.com/TheWildJames/Android_Kernel_Tutorials#-building-a-signed-boot-image-from-the-compiled-kernel)

<hr>
<h2> ✅ Downloading the kernel source code for your device</h2>

#### 00. Find kernel manifest from here:  
[Google Git](https://android.googlesource.com/kernel/manifest)  
[Generic Kernel Image (GKI) release builds](https://source.android.com/docs/core/architecture/kernel/gki-release-builds)

You can also use the table below for reference.

**Android 12 5.10 kernels:**
| Kernel Version           | Patch Level | Branch                        |
|--------------------------|-------------|-------------------------------|
| 5.10.168-android12       | 2023-04     | common-android12-5.10-2023-04 |
| 5.10.198-android12       | 2024-01     | common-android12-5.10-2024-01 |
| 5.10.205-android12       | 2024-03     | common-android12-5.10-2024-03 |
| 5.10.209-android12       | 2024-05     | common-android12-5.10-2024-05 |
| 5.10.218-android12       | 2024-08     | common-android12-5.10-2024-08 |
| 5.10.226-android12       | 2024-11     | common-android12-5.10-2024-11 |
| 5.10.233-android12       | 2025-02     | common-android12-5.10-2025-02 |
| 5.10.236-android12       | 2025-05     | common-android12-5.10-2025-05 |
| 5.10.X-android12         | lts         | common-android12-5.10-lts     |

**Android 13 5.10 kernels:**
| Kernel Version           | Patch Level | Branch                        |
|--------------------------|-------------|-------------------------------|
| 5.10.198-android13       | 2024-01     | common-android13-5.10-2024-01 |
| 5.10.205-android13       | 2024-03     | common-android13-5.10-2024-03 |
| 5.10.209-android13       | 2024-05     | common-android13-5.10-2024-05 |
| 5.10.210-android13       | 2024-06     | common-android13-5.10-2024-06 |
| 5.10.214-android13       | 2024-07     | common-android13-5.10-2024-07 |
| 5.10.218-android13       | 2024-08     | common-android13-5.10-2024-08 |
| 5.10.223-android13       | 2024-11     | common-android13-5.10-2024-11 |
| 5.10.228-android13       | 2025-01     | common-android13-5.10-2025-01 |
| 5.10.234-android13       | 2025-03     | common-android13-5.10-2025-03 |
| 5.10.236-android13       | 2025-05     | common-android13-5.10-2025-05 |
| 5.10.X-android13         | lts         | common-android13-5.10-lts     |

**Android 13 5.15 kernels:**
| Kernel Version           | Patch Level | Branch                        |
|--------------------------|-------------|-------------------------------|
| 5.15.123-android13       | 2023-11     | common-android13-5.15-2023-11 |
| 5.15.137-android13       | 2024-01     | common-android13-5.15-2024-01 |
| 5.15.144-android13       | 2024-03     | common-android13-5.15-2024-03 |
| 5.15.148-android13       | 2024-05     | common-android13-5.15-2024-05 |
| 5.15.149-android13       | 2024-07     | common-android13-5.15-2024-07 |
| 5.15.151-android13       | 2024-08     | common-android13-5.15-2024-08 |
| 5.15.153-android13       | 2024-09     | common-android13-5.15-2024-09 |
| 5.15.167-android13       | 2024-11     | common-android13-5.15-2024-11 |
| 5.15.170-android13       | 2025-01     | common-android13-5.15-2025-01 |
| 5.15.178-android13       | 2025-03     | common-android13-5.15-2025-03 |
| 5.15.180-android13       | 2025-05     | common-android13-5.15-2025-05 |
| 5.15.X-android13         | lts         | common-android13-5.15-lts     |

**Android 14 5.15 kernels:**
| Kernel Version           | Patch Level | Branch                        |
|--------------------------|-------------|-------------------------------|
| 5.15.137-android14       | 2024-01     | common-android14-5.15-2024-01 |
| 5.15.144-android14       | 2024-03     | common-android14-5.15-2024-03 |
| 5.15.148-android14       | 2024-05     | common-android14-5.15-2024-05 |
| 5.15.149-android14       | 2024-06     | common-android14-5.15-2024-06 |
| 5.15.153-android14       | 2024-07     | common-android14-5.15-2024-07 |
| 5.15.158-android14       | 2024-08     | common-android14-5.15-2024-08 |
| 5.15.167-android14       | 2024-11     | common-android14-5.15-2024-11 |
| 5.15.170-android14       | 2025-01     | common-android14-5.15-2025-01 |
| 5.15.178-android14       | 2025-03     | common-android14-5.15-2025-03 |
| 5.15.180-android14       | 2025-05     | common-android14-5.15-2025-05 |
| 5.15.X-android14         | lts         | common-android14-5.15-lts     |

**Android 14 6.1 kernels:**
| Kernel Version           | Patch Level | Branch                        |
|--------------------------|-------------|-------------------------------|
| 6.1.57-android14         | 2024-01     | common-android14-6.1-2024-01  |
| 6.1.68-android14         | 2024-03     | common-android14-6.1-2024-03  |
| 6.1.75-android14         | 2024-05     | common-android14-6.1-2024-05  |
| 6.1.78-android14         | 2024-06     | common-android14-6.1-2024-06  |
| 6.1.84-android14         | 2024-07     | common-android14-6.1-2024-07  |
| 6.1.90-android14         | 2024-08     | common-android14-6.1-2024-08  |
| 6.1.93-android14         | 2024-09     | common-android14-6.1-2024-09  |
| 6.1.99-android14         | 2024-10     | common-android14-6.1-2024-10  |
| 6.1.112-android14        | 2024-11     | common-android14-6.1-2024-11  |
| 6.1.115-android14        | 2024-12     | common-android14-6.1-2024-12  |
| 6.1.118-android14        | 2025-01     | common-android14-6.1-2025-01  |
| 6.1.124-android14        | 2025-02     | common-android14-6.1-2025-02  |
| 6.1.128-android14        | 2025-03     | common-android14-6.1-2025-03  |
| 6.1.129-android14        | 2025-04     | common-android14-6.1-2025-04  |
| 6.1.134-android14        | 2025-05     | common-android14-6.1-2025-05  |
| 6.1.X-android14          | lts         | common-android14-6.1-lts      |

**Android 15 6.6 kernels:**
| Kernel Version           | Patch Level | Branch                        |
|--------------------------|-------------|-------------------------------|
| 6.6.50-android15         | 2024-10     | common-android15-6.6-2024-10  |
| 6.6.56-android15         | 2024-11     | common-android15-6.6-2024-11  |
| 6.6.57-android15         | 2024-12     | common-android15-6.6-2024-12  |
| 6.6.58-android15         | 2025-01     | common-android15-6.6-2025-01  |
| 6.6.66-android15         | 2025-02     | common-android15-6.6-2025-02  |
| 6.6.77-android15         | 2025-03     | common-android15-6.6-2025-03  |
| 6.6.82-android15         | 2025-04     | common-android15-6.6-2025-04  |
| 6.6.87-android15         | 2025-05     | common-android15-6.6-2025-05  |
| 6.6.X-android15          | lts         | common-android15-6.6-lts      |


#### 01. Download the kernel source: https://source.android.com/docs/setup/build/building-kernels#downloading

```bash
# Make Directory & Open it
mkdir -p ~/android-kernel && cd ~/android-kernel
# Initialize Kernel Source
repo init --depth=1 -u https://android.googlesource.com/kernel/manifest -b REPLACE_WITH_BRANCH
# Download Kernel
repo --trace sync -c -j$(nproc --all) --no-tags --fail-fast
```

<img src="./screenshots/1.png">

#### 02. Determine the Kernel Build Systems: https://source.android.com/docs/setup/reference/bazel-support

| Kernel Version           | Bazel (Kleaf)  | build.sh (legacy) |
|--------------------------|----------------|-------------------|
| 5.10-android12           | ❌            | ✅ (official)     |
| 5.10-android13           | ✅            | ✅ (official) 	|
| 5.15-android13           | ✅            | ✅ (official)     |
| 5.15-android14           | ✅ (official) | ❌                |
| 6.1-android14            | ✅ (official) | ❌                |
| 6.6-android15            | ✅ (official) | ❌                |

"Official" means that this is the official way to build the kernel, even though the alternative way might also be used to build the kernel.

<img src="./screenshots/2.png">

**Note:** It's a good idea to give the entire kernel directory 755 permission to remove those read-only error from files and folders. This prevents issues when editing files and upstreaming the kernel.

**Run this command to fix it:**


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

- **⚠️ For other devices,** You can find them by your OEM's sites or from your OEM's **official** GitHub repos:

  <img src="./screenshots/13.png">=

## ✅ Understanding the ```Kernel root```

<img src="./screenshots/6.png">

- As you can see in the above screenshot, it's the Linux kernel source code.
- It must have those folders, **highlighted in blue in the terminal.**
- **In GKI kernels,** the kernel root is located in a folder named "common".

- If you have a **GKI Samsung kernel**, you should use the "common" kernel instead of "msm-kernel" for the compilation.

<h2> ✅ Preparing for the Compilation</h2>

### 01. After downloading or cloning the Kernel Source, we should have a build script to compile our kernel.

- Before creating a build script, we must determine the compatible compilers we will use to build our kernel.

- Run ```make kernelversion``` inside the kernel root to check your kernel version.

<img src="./screenshots/5.png">

- In my case, the kernel version is **5.4,** with qualcomm chipset, which is [qGKI](https://github.com/TheWildJames/Android_Kernel_Tutorials#-understanding-non-gki--gki-kernels).

- You can find full information about **choosing the correct compiler for your kernel version** [here](./toolchains/) (based on my experience, btw).

- Keep in mind that **you don't need to manually download any of these toolchains** since my build scripts handle everything for you :)  

- Next, go to [build_scripts](./build_scripts/), choose the appropriate script, download it, and place it inside your kernel's root directory.

<img src="./screenshots/7.png">

<hr>

### 02. Edit the Build script:

**💡 Better to Know:** A **defconfig** (default configuration) is like a preset settings file for the kernel.

- It tells the build system which features to enable or disable.

**So, Open the build script in a text editor and make these changes:**

- Replace `your_defconfig` to your current defconfig which is located in `arch/arm64/configs`

- In GKI 2.0 kernels, it's normally `gki_defconfig`

- But just in case, make sure to check `arch/arm64/configs` or `arch/arm64/configs/vendor`

- If your defconfig is located in the `arch/arm64/configs` directory, just replace `your_defconfig` with the name of your defconfig.

- If your defconfig is located in the `arch/arm64/configs/vendor` directory, replace `your_defconfig` like this:
  
  - `vendor/name_of_the_defconfig`
  - Example patch: [here](./patches/005.edit-defconfig.patch)

  <img src="./screenshots/12.png">

**❗If your device is Samsung Exynos, it doesn't support compiling the kernel in a separated 'out' directory. So, [edit your build script like this](./patches/001.nuke_out.patch)**  

---
#### ⚠️ [IMPORTANT] : *If your device is Samsung, it usually uses some device-specific variables in "some" kernels.*

- **As an example,** in the Galaxy S23 FE kernel source code, we can see they used variables called `TARGET_SOC=s5e9925`, `PLATFORM_VERSION=12`, and `ANDROID_MAJOR_VERSION=s`

- **If we didn't export those variables correctly,** the kernel failed to build in my case.

- Don't worry, they usually mention these required variables in their `README_Kernel.txt` or their own `build_kernel.sh`

  <img src="./screenshots/16.png">

**Refer to this example patch to properly integrate such variables into our build script:** [here](./patches/007.Define-OEM-Variables.patch)

**Note:** Just don't overthink it, even if they use values like 12 and S for Platform and Android versions, even if you have a higher Android version.

---

🔴 **If your device has a MediaTek chipset, usually it doesn't support booting a RAW kernel `Image`. Therefore, you should build a gzip-compressed kernel `Image.gz` instead.**  

- [Here's the required patch for it](./patches/014.build_gzip_compressed_kernel.patch)

---

### 03. Edit the Makefile.

- If you find these variables: ```REAL_CC``` or ```CFP_CC``` in your "Makefile", remove them from the "Makefile", then Search for "wrapper" in your Makefile. If there's a line related to a Python file, remove that entire line/function as well.

    - Example patch of removing the wrapper: [click here](./patches/004.remove_gcc%20wrapper.patch)

<hr>

### 04. Now, grant executable permissions to ```build_xxxx.sh``` using this command.
  ```
  chmod +x build_xxxx.sh
  ```
### 05. Finally, run the build script using this command :
  ```
./build_xxxx.sh
```

<img src="./screenshots/8.png">

- When you run the script for the first time, it will begin to install all the necessary dependencies and start downloading the required toolchains, depending on your kernel version.

- Make sure not to interrupt the first run. If it gets interrupted somehow, delete the `toolchains` folder from "~/" and try again: ```rm -rf ~/toolchains```

<img src="./screenshots/9.png">

### After the initial run is completed, the kernel should start building, 

<img src="./screenshots/11.png">

### and the "menuconfig" should appear.

<img src="./screenshots/10.png">

- **Additional notes:**
    - You can completely ignore anything displayed as `warning:`
      - Eg: `warning: ignoring unsupported character '`
<hr>

## ✅ Customizing the Kernel (Temporary Method)
- Once the *menuconfig* appears, you can navigate through it and customize the Kernel in a graphical way as needed.

- **As an example,** we can customize **the Kernel name, enable new drivers, enable new file systems, disable security features,** and more :)

#### You can navigate the *menuconfig* using the arrow keys (← → ↑ ↓) on your keyboard and press `y` to enable, `n` to disable or `m` to enable as a module `<M>`.

### 1. Changing the Kernel name.

- I guess no explanation is needed for this:

    <img src="./screenshots/14.png" width="60%">

- Located in: `General setup  ---> Local version - append to kernel release`

<img src="./screenshots/gif/1.gif">

### 2. Enabling BTRFS support.

- Btrfs is a modern Linux filesystem with copy-on-write, snapshots, and built-in RAID, ideal for reliability and scalability.

- Located in: `File systems  ---> < > Btrfs filesystem support`

<img src="./screenshots/gif/2.gif">

### 3. Enabling more CPU Governors

- **CPU governors control how the processor adjusts it's speed.**
-  You can choose between performance-focused governors (like "performance" for max speed) or battery-saving ones (like "powersave").
-  Please note that this may impact your SoC’s lifespan if the device overheats while handling performance-intensive tasks.

**Enabling more CPU Governors:**

- Located in: `CPU Power Management  ---> CPU Frequency scaling  ---> `

<img src="./screenshots/gif/3.gif">

**Changing the Default CPU Governor:**

- Located in: `CPU Power Management  ---> CPU Frequency scaling  ---> Default CPUFreq governor (performance)  --->`

<img src="./screenshots/gif/4.gif">

### 4. Enabling more IO Schedulers

- **IO schedulers control how your system handles reading and writing data to storage.**
- Different schedulers can make your system faster or help it run smoother, depending on what you're doing (like gaming, browsing, or saving battery).
- Located in: `IO Schedulers  --->`

<img src="./screenshots/15.png">

### The problem with menuconfig is that you have to do this every time you run the build script.

- All the changes you've made using menuconfig are saved in a temporary hidden file called `.config` inside the `out` directory.

  <img src="./screenshots/18.png">

- and it resets every time you run the build script.

  <img src="./screenshots/17.png">

- So, we need a permanent method to save our changes, right?  

## ✅ Customizing the Kernel (Permanent Method)

- In this method, **we are going to create a separate `custom.config` to store our changes** and **link it to our build script.** 

- After that, when we run the build script, **it will first use your OEM defconfig to generate the `.config` file, then merge the changes from our `custom.config` into `.config` again.** 

**Refer to these examples to get a basic idea:** [patch](./patches/008.add-custom-defconfig-support.patch), [commit](https://github.com/ravindu644/android_kernel_m145f_common/commit/c427dbebed22c5bb314b4c94c711deffe671b14c)

---

### 🤓 How to add changes to our `custom.config` ?

- First, We have to find the exact **kernel configuration option** you want to **enable** or **disable**.

- Example **kernel configuration option**: `CONFIG_XXXX=y`

  - `CONFIG_XXXX`: The name of the kernel option or feature **( Must begin with `CONFIG_` )**
  - `=y`: This means "yes" -> the option is enabled and will be included in the kernel.
  - `=n`: This means "no" -> the option is disabled.

- You can find the name of the **kernel configuration option** this way:

  - Run the build script and wait until `menuconfig` appears.
  - Navigate to the option/feature you want to enable.
  - Press `shift + ?` on your keyboard, and an explanation about the option/feature will appear.
  - You’ll see the name of the **kernel configuration option** in the top-left corner of the menuconfig.

    <img src="./screenshots/19.png">

  - **Copy that name** and add it to your `custom.config` with `=y` or `=n` to enable or disable it.

    <img src="./screenshots/20.png">

## ⁉️ How to nuke Samsung's anti-root protections?

 - ### [Moved to here](./samsung-rkp/)

## 🟢 Additional Patches

### 01. To fix broken system funcitons like Wi-Fi, touch, sound etc.
> [!NOTE]
> Bypassing this usually not a good practice, because something like this is used as **last effort,**
>
> when there's no open source linux driver found. (e.g Proprietary drivers)
>
> But, for newbies or kernel developer that wanna ship their Loadable Kernel Module, **this is okay.**

---

  - On some devices, **compiling a custom kernel can break system-level functionalities like Wi-Fi, touch, sound, and even cause the system to not boot.**

  - The reason behind this is that the device can't load the external kernel modules `(*.ko)`, due to linux's prebuilt security feature `(symversioning, signature)` that prevent malicious kernel module to load.

  - To fix this issue, [use this patch](./patches/010.Disable-CRC-Checks.patch) to force the kernel to load those modules.

  **Even if you don't have such an issue, using this patch is still a good practice.**

  ---

### 02. Fix: `There's an internal problem with your device.` issue.

**The reason:**

  ```
Userspace reads /proc/config.gz and spits out an error message after boot
finishes when it doesn't like the kernel's configuration. In order to
preserve our freedom to customize the kernel however we'd like, show
userspace the stock defconfig so that it never complains about our
kernel configuration.
  ```

- To fix this issue, make a copy of your OEM's Defconfig and rename it to `stock_defconfig`.

  <img src="./screenshots/30.png">

- Then, use the patch below to fool Android into thinking that the defconfig was not changed:

  - [Patch](./patches/011.stock_defconfig.patch), [Commit](https://github.com/ravindu644/android_kernel_a047f_eur/commit/d306bd4c4c84a12be5235e31540f40fb9c1a1066)
    
## ✅ Compiling the Kernel

- Once you've customized the kernel as you want, simply **exit menuconfig**.  
- After exiting, the kernel will start compiling!

<img src="./screenshots/gif/5.gif">

### 💡 If everything goes smoothly like this,

  <img src="./screenshots/21.png">

### you’ll find the built kernel `Image` inside the `build` folder in your kernel root!

  <img src="./screenshots/22.png">

## 🟥 Fixing the Known compiling issues

- **If you ever encounter any errors during your kernel compilation,** jump to [fixes](./patches/) and see if your specific issue is mentioned there.

**[Click here to learn about known issues and their fixes](./patches/README.md)**

## 🟡 Building a Signed Boot Image from the Compiled Kernel

- On Android devices, **the `kernel` image is usually located inside the `boot` partition.**

  <img src="./screenshots/23.png">

- So, all we have to do is **get the boot image from the stock ROM, unpack it, replace its kernel with our "built" one, repack it, flash it,** and **enjoy :)**

**For the unpacking and repacking process, we are going to use [Android_boot_image_editor](https://github.com/cfig/Android_boot_image_editor) by [@cfig](https://github.com/cfig) :)**

### 01. Downloading `Android_boot_image_editor`

- Download the latest release zip from [here](https://github.com/cfig/Android_boot_image_editor/releases/latest) and unzip it like this:

  <img src="./screenshots/24.png">

**Note:** Make sure to follow the [requirements installation section](https://github.com/TheWildJames/Android_Kernel_Tutorials#-install-the-dependencies-for-compiling-kernels) before using the [Android_boot_image_editor](https://github.com/cfig/Android_boot_image_editor)

### 02. Unpacking the `boot.img`

1. Extract both the `boot` and `vbmeta` images from your stock ROM and place them inside the `boot_editor_vXX_XX` folder

  <img src="./screenshots/26.png">

**✔️ Samsung-only note:**

  - **On Samsung devices,** these images are usually located inside the `AP_XXXX.tar.md5` file.

  - All you have to do is rename `AP_XXXX.tar.md5` to `AP_XXXX.tar` to remove the `md5` extension, extract `AP_XXXX.tar`, and grab the `boot.img.lz4` and `vbmeta.img.lz4` files from the extracted folder.

  - Then, **decompress these lz4 files using the following commands,** and you will get your `boot.img` and `vbmeta.img`

    ```bash
    lz4 boot.img.lz4
    lz4 vbmeta.img.lz4
    ```  
    
    <img src="./screenshots/25.png">

2. Now, run following command to unpack the `boot.img` :

- **Keep in mind,** this will take some time on the first run since the tool downloads dependencies during its initial execution.


  ```bash
  ./gradlew unpack
  ```

  <img src="./screenshots/27.png">

#### 🟠 As you can see in the screenshot above, the original `kernel` of the unpacked `boot.img` is located in `build/unzip_boot/kernel`

### 03. Repacking the `boot.img`

- Now, all we have to do is **replacing the original `kernel` located inside the `boot_editor_vXX_XX/build/unzip_boot` with our custom kernel.**

**Example:**

<img src="./screenshots/gif/6.gif">
<br><br>

**What did I do?**

1. Copied the compiled `Image` from the `build` folder of the Kernel Root to `boot_editor_vXX_XX/build/unzip_boot`

2. Deleted the original `kernel` and renamed `Image` to `kernel` 😎

#### 🟢 Now, run the command below to cook our new `boot.img`, which contains our custom kernel :)

  ```bash
  ./gradlew pack
  ```

  <img src="./screenshots/28.png">

### 🟨 Our new boot image will be located inside the `boot_editor_v15_r1` folder with the name `boot.img.signed`

- Copy the `boot.img.signed` file to another location and rename it to `boot.img`

- Now, all you have to do is **flash that `boot.img` through fastboot mode** or **Download mode** (Samsung)

**✔️ Samsung-only note:**  

- You can create an ODIN-flashable `tar` file using the command below:  

  ```bash
  tar -cvf "Custom-Kernel.tar" boot.img
  ```

- Then, flash that `tar` file using ODIN's AP slot :)

---

**Written by:** [@ravindu644](https://t.me/ravindu) and our contributor(s)

**Join Telegram:** [@SamsungTweaks](https://t.me/SamsungTweaks)

---
