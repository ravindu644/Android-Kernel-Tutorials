### 01. ```→ Kernel Features``` => Disable "```Enable RKP (Realtime Kernel Protection) UH feature```", "```Enable LKM authentication by micro hypervisor```", "```Block LKM by micro hypervisor```", "```Enable micro hypervisor feature of Samsung```" respectively.
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/d821da9f-0b45-4701-b681-3996bec509be" width="75%">

### 02. ```→ Kernel Features → Control Flow Protection``` => Disable "```JOP Prevention```", "```ROP Prevention```" and "```JOPP and ROPP```" Respectively.
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/58e0680a-8052-4df8-aba1-cb282d6963ee" width="75%">

### Additional notes : 
- If you can't find them (01 and 02) in the "```→ Kernel Features```", they are located in the "```→ Boot options```".
<hr>

## ❗In Android 14 and some Android 13 sources, they are located in ```→ Hypervisor```. Disable them ALL!
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/eb67e7fd-46ff-4aa7-a424-73e22f1d29da" width="75%">
- As I mentioned at the beginning of this guide, your must use your brain..! 🧠

<hr>

### 03. ```→ Security options``` => Disable "```Integrity subsystem```" and "```Defex Support```".
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/ca396e53-26fc-4ee4-99ea-c8359926ea51" width="75%">
<hr>

## ✅ How to make your kernel supports with APatch..?
<hr>

### 01. Open ```→ General setup → Local version - append to kernel release``` => Choose any string you like.
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/448a24b9-454b-47b9-82a8-0b9c2804e693">
### 02. Open ```→ Kernel hacking``` => Turn on the ```Kernel debugging``` ❗.
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/54eaf94a-3d7e-44ca-81aa-093b76ed9893">
### 03. ```→ General setup → Configure standard kernel features (expert users)``` => Enable everything except "```sgetmask/ssetmask syscalls support``` and ```Sysctl syscall support```"
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/8927d898-d3ef-471a-8f68-bbe418068565" width="75%">
### 04. ```→ Enable loadable module support``` => Enable "```Forced module loading```", "```Module unloading```", "```Forced module unloading```", "```Module versioning support```" and disable others.
- Image : <br><br><img src="https://github.com/ravindu644/Android-Kernel-Tutorials/assets/126038496/865ddeca-88de-484d-8f99-922b439e0e7c" width="75%"><br><br>
**❗Additional Notes :** To force load the vendor/system modules in some devices, use this commit (⚠️ This fixes various hardware related issues after installing a custom kernel) - [Click here](https://github.com/rama982/kernel_common/commit/d5e8b83f0c5eee4e2f8c6d9888cc56d03f2615fb)

### 05. ```→ Boot options``` => enable "```Build a concatenated Image.gz/dtb by default```" and "```Kernel compression method (Build compressed kernel image)```"  ---> "```(X) Build compressed kernel image```"
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/3c7704a7-ea16-4bee-a0bf-6ecd0424f2b7" width="75%">
### 06. ```→ File systems``` => Enable "```<*> Overlay filesystem support```".
- Image : <br><br><img src="https://github.com/ravindu644/APatch/assets/126038496/0cbff894-ba4c-4f51-a1bd-3ffa1963cd51" width="75%">
<hr>