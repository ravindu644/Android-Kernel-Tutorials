#!/bin/sh

set -e

# Init android-partition-tools
git clone https://github.com/ravindu644/android-partition-tools.git $HOME/android-partition-tools --depth=1
echo PATH="\$PATH:\$HOME/android-partition-tools" >> $HOME/.bashrc