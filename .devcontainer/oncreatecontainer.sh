#!/bin/sh

# Install all required packages
apt-get update && apt-get install -y \
    android-sdk-libsparse-utils \
    bash-completion \
    bc \
    tmux \
    bison \
    build-essential \
    bzip2 \
    neofetch \
    coreutils \
    cpio \
    curl \
    rsync \
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
    htop \
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
    python3-pip \
    repo \
    sudo \
    tar \
    tofrodos \
    unzip \
    tree \
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
    apt-get full-upgrade -y

# Create the user and set up passwordless sudo
adduser kernel-builder sudo
echo "kernel-builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/kernel-builder

# setup da kitchen
mkdir /workspaces/kitchen
chmod -R 777 /workspaces/kitchen