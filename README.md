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
03. 🔎 [Determine the Kernel Build Systems](https://github.com/TheWildJames/Android_Kernel_Tutorials#03-determine-the-kernel-build-systems-httpssourceandroidcomdocssetupreferencebazel-support)
04. ✅ [Time to compile our kernel](https://github.com/TheWildJames/Android_Kernel_Tutorials#04-time-to-compile-our-kernel)
05. 🔐 [Integrate KernelSU (Optional)](https://github.com/TheWildJames/Android_Kernel_Tutorials#05-integrate-kernelsu-optional)
06. 🛡️ [Integrate SUSFS (Optional)](https://github.com/TheWildJames/Android_Kernel_Tutorials#06-integrate-susfs-optional)
07. 🔨 [Build kernel with KernelSU/SUSFS](https://github.com/TheWildJames/Android_Kernel_Tutorials#07-build-kernel-with-kernelsususfs)
08. 📤 [Unpack boot.img](https://github.com/TheWildJames/Android_Kernel_Tutorials#08-unpack-bootimg)
09. 📥 [Repack boot.img](https://github.com/TheWildJames/Android_Kernel_Tutorials#09-repack-bootimg)

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

> [!NOTE]
> You must replace `REPLACE_WITH_BRANCH` in the command below with the correctly formatted branch name you obtained earlier (e.g., common-android15-6.6-lts).

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

> [!NOTE]
> After running these commands you may see this error:  
> `error: Cannot fetch kernel/common from https://android.googlesource.com/kernel/common`

In that case your branch might be depricated and you will have to run the commands below to find out:
```bash
#!/bin/bash

# Prompt for branch name without using read -p
echo "Enter the branch name: "
read FORMATTED_BRANCH

# Remove 'common-' from the start of the branch name
FORMATTED_BRANCH=${FORMATTED_BRANCH#common-}

REMOTE_BRANCH=$(git ls-remote https://android.googlesource.com/kernel/common ${FORMATTED_BRANCH})
DEFAULT_MANIFEST_PATH=.repo/manifests/default.xml

if grep -q deprecated <<< $REMOTE_BRANCH; then
  echo "Found deprecated branch: $FORMATTED_BRANCH"
  sed -i "s/\"${FORMATTED_BRANCH}\"/\"deprecated\/${FORMATTED_BRANCH}\"/g" $DEFAULT_MANIFEST_PATH
fi

# Download Kernel Source
repo --trace sync -c -j$(nproc --all) --no-tags --fail-fast
```


### 03. Determine the Kernel Build Systems: https://source.android.com/docs/setup/reference/bazel-support

| Kernel Version           | Bazel (Kleaf)  | build.sh (legacy) |
|--------------------------|----------------|-------------------|
| 5.10-android12           | ❌            | ✅ (official)     |
| 5.10-android13           | ✅            | ✅ (official) 	|
| 5.15-android13           | ✅            | ✅ (official)     |
| 5.15-android14           | ✅ (official) | ❌                |
| 6.1-android14            | ✅ (official) | ❌                |
| 6.6-android15            | ✅ (official) | ❌                |

> [!NOTE]
> "Official" means that this is the official way to build the kernel, even though the alternative way might also be used to build the kernel.

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

### 05. Integrate KernelSU (Optional)

> [!NOTE]
> KernelSU is a kernel-based root solution for Android GKI devices. This step is optional but recommended if you want root access.

KernelSU provides kernel-level root access and is specifically designed for GKI 2.0 kernels. Follow these steps to integrate it:

#### What is KernelSU?
- **KernelSU** is a kernel-based root solution for Android devices
- It provides root access through kernel modules rather than system modifications
- Designed specifically for GKI (Generic Kernel Image) devices
- More stable and secure compared to traditional root methods

#### Integration Steps:
Check [here](https://kernelsu.org/guide/how-to-build.html#build-kernel-with-kernelsu) for more info!

```bash
# Navigate to your kernel source directory
cd ~/android-kernel

# Add KernelSU to your kernel source
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
```

This script will:
- Download the latest KernelSU source code
- Integrate it into your kernel source tree
- Modify necessary kernel configuration files
- Add KernelSU-specific patches

#### Verify Integration:
After running the setup script, you should see:
- New KernelSU directory in your kernel source
- Modified kernel configuration files
- KernelSU-related entries in the build system

### 06. Integrate SUSFS (Optional)

SUSFS4KSU: An addon root hiding kernel patches and userspace module for KernelSU.

#### What is SUSFS?
- Provides advanced hiding capabilities for root detection bypass
- Works in conjunction with KernelSU
- Helps hide root access from banking apps and other security-sensitive applications

#### Supported Kernel Versions:
SUSFS has specific branches for different kernel versions. Choose the correct branch for your kernel:

| Kernel Version | SUSFS Branch |
|----------------|--------------|
| android12-5.10 | gki-android12-5.10 |
| android13-5.10 | gki-android13-5.15 |
| android13-5.15 | gki-android13-5.15 |
| android14-5.15 | gki-android13-5.15 |
| android14-6.1  | gki-android14-6.1 |
| android15-6.6  | gki-android15-6.6 |

#### Integration Steps:

> [!IMPORTANT]
> SUSFS requires KernelSU to be integrated first. Make sure you've completed step 05 before proceeding.
> You must also replace <kernel_version> below with the appropriate SUSFS Branch from the list above.

#### Branch Selection:

```bash
# Navigate to your kernel source directory
cd ~/

# example: gki-android15-6.1
git clone https://gitlab.com/simonpunk/susfs4ksu.git -b <kernel_version>

# Then apply the patches
cp ~/susfs4ksu/kernel_patches/KernelSU/10_enable_susfs_for_ksu.patch ~/android-kernel/KernelSU/

cp ~/susfs4ksu/kernel_patches/50_add_susfs_in_kernel-<kernel_version>.patch ~/android-kernel/common/

cp ~/susfs4ksu/kernel_patches/fs/* ~/android-kernel/common/fs/

cp ./susfs4ksu/kernel_patches/include/linux/* ~/android-kernel/common/include/linux/

cd ~/android-kernel/KernelSU && patch -p1 < 10_enable_susfs_for_ksu.patch

cd ~/android-kernel/common && patch -p1 < 50_add_susfs_in_kernel.patch
```

> [!IMPORTANT]
> If there are failed patches, you may try to patch them manually by yourself.
> Link here for more info(not added yet)

#### Verify SUSFS Integration:
After applying SUSFS patches, you should see:
- SUSFS-related configuration options in kernel config
- Modified kernel source files with SUSFS patches
- SUSFS module integrated into the build system

### 07. Build kernel with KernelSU/SUSFS

Now that you've integrated KernelSU and optionally SUSFS, it's time to build the kernel with these modifications.

#### Build Configuration:
The integration scripts should have automatically modified your kernel configuration. However, you can verify the configuration:

```bash
# Navigate to kernel source
cd ~/android-kernel

# Check if KernelSU is properly configured
grep -r "KERNELSU" common/arch/arm64/configs/ || echo "KernelSU config not found - this is normal for some integration methods"

# For Bazel builds, check if the configuration is properly set
if [ -f "common/arch/arm64/configs/gki_defconfig" ]; then
    echo "GKI defconfig found"
else
    echo "Warning: GKI defconfig not found"
fi
```

#### Build the Kernel:

Choose the appropriate build method based on your kernel version (refer to step 03):

**For build.sh (legacy method):**
```bash
# Build with KernelSU/SUSFS integrated
LTO=thin BUILD_CONFIG=common/build.config.gki.aarch64 build/build.sh
```

**For Bazel (official method for newer kernels):**
```bash
# Build with KernelSU/SUSFS integrated
tools/bazel build --config=fast --lto=thin //common:kernel_aarch64_dist
```

#### Build Verification:
After the build completes successfully, verify that KernelSU is integrated:

```bash
# For build.sh builds
if [ -f "out/*/dist/Image" ]; then
    echo "✅ Kernel build successful!"
    echo "📍 Kernel location: out/*/dist/Image"
else
    echo "❌ Kernel build failed!"
fi

# For Bazel builds
if [ -f "bazel-bin/common/kernel_aarch64/Image" ]; then
    echo "✅ Kernel build successful!"
    echo "📍 Kernel location: bazel-bin/common/kernel_aarch64/Image"
else
    echo "❌ Kernel build failed!"
fi

# Check for KernelSU integration (this may not always show output)
strings out/*/dist/Image 2>/dev/null | grep -i kernelsu || echo "KernelSU strings not found (this is normal)"
```

#### Troubleshooting Build Issues:

If you encounter build errors:

1. **Clean build environment:**
```bash
# For build.sh
rm -rf out/

# For Bazel
tools/bazel clean --expunge
```

2. **Check integration:**
```bash
# Verify KernelSU files are present
ls -la KernelSU/ 2>/dev/null || echo "KernelSU directory not found"

# Verify SUSFS files are present (if you integrated SUSFS)
ls -la susfs/ 2>/dev/null || echo "SUSFS directory not found"
```

3. **Re-run integration if needed:**
```bash
# Re-integrate KernelSU if there are issues
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s main

# Re-integrate SUSFS if there are issues (replace branch name as needed)
cd susfs && ./susfs4ksu.sh && cd ..
```

### 08. Unpack boot.img

On GKI 2.0 devices the kernels are built into the boot.img. We need to get our stock boot.img and unpack it

Start by downloading magiskboot from the [tools above](https://github.com/TheWildJames/Android_Kernel_Tutorials/blob/gki-2.0/tools/magiskboot) and placing it in a new folder

```bash
# Make new directory and move into it
mkdir -p ~/android-tools && cd ~/android-tools

# Download magiskboot
curl -LO https://raw.githubusercontent.com/TheWildJames/Android_Kernel_Tutorials/gki-2.0/tools/magiskboot

# Make it executable
chmod +x magiskboot
```

Then download your stock boot.img, after that you must move it to a new folder `~/android-bootimgs`
After that you must unpack the boot.img:

```bash
# Make new directory and move into it
mkdir -p ~/android-bootimgs && cd ~/android-bootimgs

# Move stock boot.img to ~/android-bootimgs
# You must do this yourself there is no command for me to give you!

# Unpack boot.img
~/android-tools/magiskboot unpack boot.img
```

You will now see an output containing one of the following lines:

1. `KERNEL_FMT      [raw]`  
2. `KERNEL_FMT      [lz4]`  
3. `KERNEL_FMT      [gzip]`  

These are three common formats. Once you identify your format, you must repack your boot.img with the custom kernel you created.

### 09. Repack boot.img

> [!NOTE]
> You must use the same kernel format as you original stock boot.img from your device.

If you ran `build.sh` then use one of these command to move kernel image to `android-bootimgs` folder:

1. KERNEL_FMT = raw
```bash
# Copy Kernel Image & rename to kernel
cp ~/android-kernel/out/*/dist/Image ~/android-bootimgs/kernel
```
2. KERNEL_FMT = lz4
```bash
# Copy Kernel Image.lz4 & rename to kernel
cp ~/android-kernel/out/*/dist/Image.lz4 ~/android-bootimgs/kernel
```
3. KERNEL_FMT = gzip
```bash
# gzip Kernel Image & rename to kernel
gzip -n -k -f -9 ~/android-kernel/out/*/dist/Image > ~/android-bootimgs/kernel
```

If you ran `Bazel` then use one of these command to move kernel image to boot.img folder:

KERNEL_FMT = raw
```bash
# Copy Kernel Image & rename to kernel
cp ~/android-kernel/bazel-bin/common/kernel_aarch64/Image ~/android-bootimgs/kernel
```
KERNEL_FMT = lz4
```bash
# Copy Kernel Image.lz4 & rename to kernel
cp ~/android-kernel/bazel-bin/common/kernel_aarch64/Image.lz4 ~/android-bootimgs/kernel
```
KERNEL_FMT = gzip
```bash
# gzip Kernel Image & rename to kernel
gzip -n -k -f -9 ~/android-kernel/bazel-bin/common/kernel_aarch64/Image > ~/android-bootimgs/kernel
```

After that you will now have to repack your boot.img with your kerenl!

```bash
# Move into the dir
cd ~/android-bootimgs

# Repack boot.img with magiskboot
~/android-tools/magiskboot repack boot.img
```
You will now see a newly created file: `new-boot.img` 

# 🎉 Congratulations!  
You've successfully built a GKI 2.0 Android kernel with KernelSU and optionally SUSFS, and repacked it into your boot.img.  

## What You've Accomplished:
- ✅ Built a custom GKI 2.0 kernel
- ✅ Integrated KernelSU for kernel-level root access
- ✅ Optionally integrated SUSFS for advanced hiding capabilities
- ✅ Created a flashable boot.img with your custom kernel

## Next Steps:
1. **Flash the kernel:** Use fastboot or your preferred flashing method to install `new-boot.img`
2. **Install KernelSU Manager:** Download and install the KernelSU Manager app from the official repository
3. **Verify installation:** Check that KernelSU is working properly after boot
4. **Configure SUSFS:** If you integrated SUSFS, configure it according to your needs

## Important Notes:
- Always backup your original boot.img before flashing
- Test the kernel thoroughly before daily use
- Keep your KernelSU Manager app updated
- Join the KernelSU community for support and updates

You're now ready to flash your custom kernel to your device! 🚀
