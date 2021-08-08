#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
#echo $SCRIPTPATH
BUILDROOTPATH=$SCRIPTPATH/../../../buildroot
$BUILDROOTPATH/output/host/bin/qemu-system-riscv32 -M virt -smp 2 -m 1024 -nographic -bios $BUILDROOTPATH/output/images/fw_jump.elf -kernel $BUILDROOTPATH/output/images/Image -drive file=$BUILDROOTPATH/output/images/rootfs.ext2,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -append "rootwait root=/dev/vda" -device virtio-net-device,netdev=eth0 -netdev user,id=eth0,hostfwd=tcp::2222-:22 -fsdev local,id=v_9p_dev,path=$BUILDROOTPATH,security_model=none -device virtio-9p-device,fsdev=v_9p_dev,mount_tag=hostshare "$@"
