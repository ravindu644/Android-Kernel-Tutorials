## If you want to build your Snapdragon/Mediatek kernel with the proton clang, Just follow these steps
<hr>

### 01. Clone Proton clang using this command :
```
cd ~
git clone https://github.com/kdrag0n/proton-clang.git --depth=1
```

### 02. Create a build script to compile with proton.
```
touch build_proton.sh
chmod +x  build_proton.sh
```
### 03. Open ```build_proton.sh``` and enter this code :
```
export ARCH=arm64
export PLATFORM_VERSION=13
export ANDROID_MAJOR_VERSION=t
export PATH="$HOME/proton-clang/bin:$PATH" #path to proton
clear
mkdir out

ARGS="
CC=clang
CROSS_COMPILE=aarch64-linux-gnu-
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
AR=llvm-ar
NM=llvm-nm
OBJCOPY=llvm-objcopy
OBJDUMP=llvm-objdump
STRIP=llvm-strip
ARCH=arm64
"
make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} clean && make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} mrproper
make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} YOUR_DEFCONFIG
make -j8 -C $(pwd) O=$(pwd)/out ${ARGS} menuconfig
make -j8 -C $(pwd) O=$(pwd)/out ${ARGS}
```
<hr>

### 04. You don't need to edit any variable in the ```build_proton.sh```. This is the common format.