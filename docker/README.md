# 🐳 The kernel-builder container

[← Back to the main guide](../README.md)

A ready-made Ubuntu container with every build dependency already installed. It
is the easiest way to build a kernel on a machine that is not Debian based, and
it behaves the same on any OS.

> [!TIP]
> **You probably don't need this folder.** Grab the prebuilt container from the
> [releases page](https://github.com/ravindu644/Android-Kernel-Tutorials/releases)
> and run `kernel-builder.sh`. This folder is for building the image yourself.

## What is in here

| File | What it does |
| --- | --- |
| `full/Dockerfile` | The full image, with everything |
| `minimal/Dockerfile` | A smaller image with just the kernel build essentials |
| `build-container-full.sh` | Builds the full image and packs it into `kernel-builder.tar.xz` |
| `build-container-minimal.sh` | Same thing, for the minimal image |
| `kernel-builder.sh` | What you actually run. Loads the image and drops you into a shell |

## Building it yourself

Pick full or minimal, then run its build script from this folder:

```bash
chmod +x build-container-full.sh
./build-container-full.sh
```

That builds the image, saves it as a tar and compresses it with `xz`. The result
is `kernel-builder.tar.xz`, the same file the releases page gives you.

Set `DOCKER_CONTAINER_VERSION` first if you want the tag to say something other
than `dev`:

```bash
export DOCKER_CONTAINER_VERSION="1.0"
```

## Running it

Put `kernel-builder.tar.xz` and `kernel-builder.sh` in the same folder, then:

```bash
chmod +x kernel-builder.sh
./kernel-builder.sh
```

The first run loads the image, which takes a while. After that it starts straight
away.

Your home folder is mounted inside the container, and so is `~/toolchains`, so
any toolchain the container downloads stays on your machine and is still there
next time you start it.

---

[← Back to the main guide](../README.md)
