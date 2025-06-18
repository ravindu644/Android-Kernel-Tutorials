> [!CAUTION]
> **By using this guide, you accept all risks -** including potential device bricking, failed boots, or other issues. **We take no responsibility for any damage.**
> 
> Questions will **only** be considered **if you've read the full documentation** and **done your own research first.**

## A Beginner-Friendly Guide to Compile Your First Android Kernel!

![Android](https://img.shields.io/badge/Android-3DDC84?logo=android&logoColor=white)

# Android Kernel Tutorial: GKI 2.0

### Readings:  

First, you should read the official Android documentation for kernel building:  
- https://source.android.com/docs/setup/build/building-kernels  
- https://source.android.com/docs/core/architecture/kernel/gki-release-builds

### Extras:  
- https://kernelsu.org/guide/how-to-build.html
- https://source.android.com/docs/setup/build/building-pixel-kernels

### What You Need To Know: 

### Generic Kernel Image (GKI):
- A Generic Kernel Image (GKI) for Android is a standardized Linux kernel created by Google to reduce device differences and make updates easier. It separates hardware-specific code into loadable modules, letting one kernel work across various devices.

### Android Kernel Evolution: Pre-GKI, GKI 1.0, GKI 2.0:
- Pre-GKI: Custom kernels forked from the Android Common Kernel, tailored by vendors and OEMs, caused fragmentation and slow updates.
- GKI 1.0: Launched with Android 11 (kernel 5.4), introduced a standardized kernel with vendor modules to reduce fragmentation, but vendor modifications limited success.
- GKI 2.0: Introduced with Android 12 (kernel 5.10+), enforces a stable Kernel Module Interface, separates hardware code, and enables independent updates.

### Kernel version vs Android version:

Please note: Kernel version and Android version aren't necessarily the same!

If you find that your kernel version is 5.10.101-android12, but your Android system version is Android 13 or other, don't be surprised, because the version number of the Android system isn't necessarily the same as the version number of the Linux kernel. The version number of the Linux kernel is generally correspondent to the version of the Android system that comes with the device when it is shipped. If the Android system is upgraded later, the kernel version will generally not change. Always check kernel version before building!

This tutorial covers GKI 2.0 kernels, the current standard for Android devices.

### Git:
- Git is a free and open source distributed version control system. Android uses Git for local operations such as branching, commits, diffs, and edits. For help learning Git, refer to the Git documentation.

### Repo:
- Repo is a Python wrapper around Git that simplifies performing complex operations across multiple Git repositories. Repo doesn't replace Git for all version control operations, it only makes complex Git operations easier to accomplish. Repo uses manifest files to aggregate Git projects into the Android superproject.

### Android kernel manifest:
- An Android kernel manifest is an XML file (typically named manifest.xml or default.xml) that specifies the Git repositories, branches, and projects required to download the Generic Kernel Image (GKI) source code using the repo tool. It acts as a roadmap for developers to synchronize the kernel source tree from Google's Android Git repositories (e.g., https://android.googlesource.com/kernel/manifest).

### Notes:
- **LTS = Long-Term Support**
- **GKI = Generic Kernel Image**
- **SoC = System on Chip**
- **OEMs = Original Equipment Manufacturers:** like Samsung or OnePlus may still modify GKI 2.0 kernels to accommodate their needs, and can cause some issues like broken SD Card and broken Audio. 
  - **So, use their GKI kernel source instead if possible.** 

### Requirements:
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
01. 👀 [Find kernel manifest](https://github.com/TheWildJames/Android_Kernel_Tutorials#01-find-kernel-manifest-from-here)
02. ⚙️ [Download the kernel source](https://github.com/TheWildJames/Android_Kernel_Tutorials#02-download-the-kernel-source-httpssourceandroidcomdocssetupbuildbuilding-kernelsdownloading)
03. 👀 [Determine the Kernel Build Systems](https://github.com/TheWildJames/Android_Kernel_Tutorials#03-determine-the-kernel-build-systems-httpssourceandroidcomdocssetupreferencebazel-support)
04. ✅ [Time to compile our kernel](https://github.com/TheWildJames/Android_Kernel_Tutorials04-time-to-compile-our-kernel)

### 01. Find kernel manifest from here:  
Google Git: https://android.googlesource.com/kernel/manifest  
Generic Kernel Image (GKI) release builds: https://source.android.com/docs/core/architecture/kernel/gki-release-builds

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


### 02. Download the kernel source: https://source.android.com/docs/setup/build/building-kernels#downloading

```bash
# If this is you first time running repo you may need to configure these below
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Make Directory & Open it
mkdir -p ~/android-kernel && cd ~/android-kernel
# Initialize Kernel Source
repo init --depth=1 -u https://android.googlesource.com/kernel/manifest -b REPLACE_WITH_BRANCH
# Download Kernel Source
repo --trace sync -c -j$(nproc --all) --no-tags --fail-fast
```

<img src="./screenshots/2.png">
<img src="./screenshots/2.1.png">

### 03. Determine the Kernel Build Systems: https://source.android.com/docs/setup/reference/bazel-support

| Kernel Version           | Bazel (Kleaf)  | build.sh (legacy) |
|--------------------------|----------------|-------------------|
| 5.10-android12           | ❌            | ✅ (official)     |
| 5.10-android13           | ✅            | ✅ (official) 	|
| 5.15-android13           | ✅            | ✅ (official)     |
| 5.15-android14           | ✅ (official) | ❌                |
| 6.1-android14            | ✅ (official) | ❌                |
| 6.6-android15            | ✅ (official) | ❌                |

"Official" means that this is the official way to build the kernel, even though the alternative way might also be used to build the kernel.

<img src="./screenshots/3.png"> 

### 04. Time to compile our kernel.

- In my case, the kernel version is **6.1.124-android14,** with the branch **common-android14-6.1-2025-02,** which is GKI 2.0.

- You can find full information about **choosing the correct build system for your kernel version** [above](https://github.com/TheWildJames/Android_Kernel_Tutorials#03-determine-the-kernel-build-systems-httpssourceandroidcomdocssetupreferencebazel-support).

To build with build.sh:
```bash
LTO=thin BUILD_CONFIG=common/build.config.gki.aarch64 build/build.sh
```

To Build with Bazel
```bash
tools/bazel build --config=fast --lto=thin //common:kernel_aarch64_dist
```

<img src="./screenshots/4.png"> 
