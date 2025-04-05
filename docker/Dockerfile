# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV KBUILD_BUILD_USER="@ravindu644"
ENV CROSS_COMPILE="/home/kernel-builder/toolchains/gcc/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-"

# Install all required packages
RUN apt-get update && apt-get install -y \
    android-sdk-libsparse-utils \
    bash-completion \
    bc \
    bison \
    build-essential \
    bzip2 \
    coreutils \
    cpio \
    curl \
    default-jdk \
    device-tree-compiler \
    e2fsprogs \
    erofs-utils \
    f2fs-tools \
    file \
    findutils \
    flex \
    g++ \
    gcc \
    git \
    gnupg \
    gperf \
    grep \
    iproute2 \
    iputils-ping \
    kmod \
    libarchive-tools \
    libc6-dev \
    libelf-dev \
    libgl1 \
    libgl1-mesa-dev \
    libncurses-dev \
    libreadline-dev \
    libssl-dev \
    libx11-dev \
    libxml2-utils \
    lz4 \
    make \
    nano \
    net-tools \
    openssl \
    openjdk-17-jdk \
    p7zip-full \
    pahole \
    procps \
    python-is-python3 \
    python3 \
    python3-markdown \
    repo \
    sudo \
    tar \
    tofrodos \
    unzip \
    util-linux \
    vim \
    wget \
    xsltproc \
    xz-utils \
    zip \
    zlib1g-dev \
    zstd \
    --fix-missing && \
    wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb && \
    dpkg -i libtinfo5_6.3-2ubuntu0.1_amd64.deb && \
    rm libtinfo5_6.3-2ubuntu0.1_amd64.deb && \
    apt-get full-upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create the user and set up passwordless sudo
RUN useradd -m -s /bin/bash kernel-builder && \
    echo "kernel-builder:kernel-builder" | chpasswd && \
    adduser kernel-builder sudo && \
    echo "kernel-builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/kernel-builder

# Set the working directory to the kernel-builder's home
WORKDIR /home/kernel-builder

# Add a custom greeting to the bash prompt
RUN echo 'echo -e "\e[32mAndroid-Kernel-Tutorials by @ravindu644\e[0m\n"' >> /home/kernel-builder/.bashrc

# Set the default user to "kernel-builder"
USER kernel-builder

# Init arm gnu toolchain
RUN mkdir -p "/home/kernel-builder/toolchains/gcc" && \
    cd "/home/kernel-builder/toolchains/gcc" && \
    curl -LO "https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz" && \
    tar -xf arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz && \
    rm arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz

# Init neutron-clang 
RUN mkdir -p "/home/kernel-builder/toolchains/neutron-clang" && \
    cd "/home/kernel-builder/toolchains/neutron-clang" && \
    curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman" && chmod +x antman && \
    bash antman -S && bash antman --patch=glibc

# Init android-partition-tools
RUN git clone https://github.com/ravindu644/android-partition-tools.git /home/kernel-builder/android-partition-tools --depth=1
ENV PATH=$PATH:/home/kernel-builder/android-partition-tools

# sKETCHY way to initialize boot image editor :3
RUN cd "/home/kernel-builder" && \
    curl -LO "https://github.com/cfig/Android_boot_image_editor/releases/download/v15_r1/boot_editor_v15_r1.zip" && \
    unzip boot_editor_v15_r1.zip && rm -rf boot_editor_v15_r1.zip && \
    cd boot_editor_v15_r1 && \
    curl -LO "https://github.com/ravindu644/android_kernel_m145f_common/raw/refs/heads/M145FXXU4CXG4/prebuilts/Android_boot_image_editor/boot.img" && \
    curl -LO "https://github.com/ravindu644/android_kernel_m145f_common/raw/refs/heads/M145FXXU4CXG4/prebuilts/Android_boot_image_editor/vbmeta.img" && \
    bash gradlew unpack && \
    bash gradlew clear && \
    rm -f boot.img vbmeta.img

# Final command to keep the container running
CMD ["bash"]
