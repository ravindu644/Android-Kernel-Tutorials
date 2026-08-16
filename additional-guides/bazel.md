# 🅱️ Building GKI 2.0 kernels with Bazel

[← Back to the main guide](../README.md)

Some GKI 2.0 sources dropped the plain `make` build and use Google's
[Bazel](https://bazel.build) setup instead. If your kernel is on one of these
branches, the build scripts in this repo are not enough on their own:

- `android14-5.15`
- `android14-6.1`
- `android15-6.6`

The common command looks like this:

```bash
chmod +x tools/bazel
tools/bazel build --config=fast //common:kernel_aarch64_dist
```

> [!NOTE]
> Every OEM tweaks this. Read Google's build instructions, or your OEM's if they
> published any, before assuming the command above is right for your source.

---

[← Back to the main guide](../README.md)
