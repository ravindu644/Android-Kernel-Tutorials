### 🟠 How to remove Samsung's Real-time Kernel Protection (RKP), which prevents the kernel from booting in kernel-based rooting solutions.

---

- I don't want to upload GIFs or images of the `menuconfig` since the method may vary depending on your kernel version.

- However, you can add all of these possible configs to your `custom.config` to completely disable Samsung's hypervisor, which in turn disables Knox-based protections.  

---

**🟢 Easy method:** *Add these configs to your `custom.config` to disable RKP/Hypervisor (or whatever you call it):*

```
# Disable Samsung Securities

CONFIG_UH=n
CONFIG_UH_RKP=n
CONFIG_UH_LKMAUTH=n
CONFIG_UH_LKM_BLOCK=n
CONFIG_RKP_CFP_JOPP=n
CONFIG_RKP_CFP=n
CONFIG_SECURITY_DEFEX=n
CONFIG_PROCA=n
CONFIG_FIVE=n

```
---

**🔴 Hard method:**

### Possible Locations of these Security features in Menuconfig:

01. `---> Kernel Features`
   - Disable:
     - "Enable RKP (Realtime Kernel Protection) UH feature"
     - "Enable LKM authentication by micro hypervisor"
     - "Block LKM by micro hypervisor"
     - "Enable micro hypervisor feature of Samsung"

02. `---> Kernel Features ---> Control Flow Protection`
   - Disable:
     - "JOP Prevention"
     - "ROP Prevention"
     - "JOPP and ROPP"

**Additional Notes:**  

   - If the above configs are missing in "Kernel Features," check "Boot options."
   - **Android 14 & some Android 13 sources:** These options are under "---> Hypervisor" (Disable all).

<br>

03. `---> Security options`
   - Disable:
     - "Defex, PROCA, FIVE Support"

**Note:** *Not all devices have these options. If you can't find any of them in your `menuconfig`, just relax and skip to the next step. :)*
