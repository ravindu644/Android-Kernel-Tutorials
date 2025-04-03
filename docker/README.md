How to Build ?

```bash
docker build -t kernel-builder .

docker save -o kernel-builder.tar kernel-builder

xz -z -T0 -9 kernel-builder.tar
```