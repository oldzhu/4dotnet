#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
#echo $SCRIPTPATH
BUILDROOTPATH=$SCRIPTPATH/../../../buildroot
$BUILDROOTPATH/output/host/bin/qemu-system-aarch64 -M virt -cpu cortex-a53 -nographic -smp 2 -m 4096 -kernel $BUILDROOTPATH/output/images/Image -append "rootwait root=/dev/vda console=ttyAMA0" -netdev tap,id=eth0,script=$SCRIPTPATH/../qemu-ifup,downscript=no -device virtio-net-device,netdev=eth0 -drive file=$BUILDROOTPATH/output/images/rootfs.ext4,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -fsdev local,id=v_9p_dev,path=$BUILDROOTPATH,security_model=none -device virtio-9p-device,fsdev=v_9p_dev,mount_tag=hostshare "$@"
