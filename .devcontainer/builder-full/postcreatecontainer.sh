#!/bin/sh

set -e

# assume it is running in repository's root directory
./.devcontainer/scripts/setup-arm-gnu-toolchain.sh &
./.devcontainer/scripts/setup-android-partition-tools.sh &
./.devcontainer/scripts/setup-neutron-clang.sh &
./.devcontainer/scripts/setup-boot-image-editor.sh &

# wait for these jobs to complete
wait