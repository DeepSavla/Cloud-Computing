sudo qemu-system-x86_64 -smp 2 -hda ubuntu.img -boot c -cdrom ./Downloads/ubuntu-20.04.5-live-server-amd64.iso -m 2G -device e1000,netdev=unet0 -netdev user,id=unet0,hostfwd=tcp::8888-:22 -nographic
