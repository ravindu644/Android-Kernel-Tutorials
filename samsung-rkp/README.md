# 🟠 How to remove Samsung's RKP

[← Back to the main guide](../README.md)

Real-time Kernel Protection (RKP) is Samsung's hypervisor-based protection. It is
what stops the kernel from booting when you use a kernel-based rooting solution,
so it has to go.

I don't want to upload GIFs or images of the `menuconfig` here, since the method
may vary depending on your kernel version. So here are the configs themselves.

## 🟢 Easy method

Add these to your `custom.config` to completely disable Samsung's hypervisor,
which in turn disables the Knox-based protections:

```kconfig
# Disable Samsung Securities
CONFIG_UH=n
CONFIG_UH_RKP=n
CONFIG_UH_LKMAUTH=n
CONFIG_UH_LKM_BLOCK=n
CONFIG_RKP_CFP_JOPP=n
CONFIG_RKP_CFP_ROPP=n
CONFIG_RKP_CFP=n
CONFIG_SECURITY_DEFEX=n
CONFIG_PROCA=n
CONFIG_FIVE=n
```

## 🔴 Hard method

Possible locations of these security features in `menuconfig`:

1. `---> Kernel Features`
    - Disable:
      - "Enable RKP (Realtime Kernel Protection) UH feature"
      - "Enable LKM authentication by micro hypervisor"
      - "Block LKM by micro hypervisor"
      - "Enable micro hypervisor feature of Samsung"

2. `---> Kernel Features ---> Control Flow Protection`
    - Disable:
      - "JOP Prevention"
      - "ROP Prevention"
      - "JOPP and ROPP"

    Additional notes:

    - If the above configs are missing in "Kernel Features," check "Boot options."
    - **Android 14 & some Android 13 sources:** These options are under
      "---> Hypervisor" (disable all).

3. `---> Security options`
    - Disable:
      - "Defex, PROCA, FIVE Support"

> [!NOTE]
> Not all devices have these options. If you can't find any of them in your
> `menuconfig`, just relax and skip to the next step. :)

---

[← Back to the main guide](../README.md)
