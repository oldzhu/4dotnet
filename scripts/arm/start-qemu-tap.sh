#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
#echo $SCRIPTPATH
$BUILDROOTPATH=$SCRIPTPATH/../../../buildroot
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BUILDROOTPATH/output/host/lib
$BUILDROOTPATH/output/host/bin/qemu-system-arm -M virt -smp 2 -m 2048 -nographic -kernel $BUILDROOTPATH/output/images/zImage -drive file=$BUILDROOTPATH/output/images/rootfs.ext2,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -append "console=ttyAMA0,115200 rootwait root=/dev/vda vmalloc=500M" -device virtio-net-device,netdev=eth0 -netdev tap,id=eth0,script=$SCRIPTPATH/../qemu-ifup,downscript=no -fsdev local,id=v_9p_dev,path=$BUILDROOTPATH,security_model=none -device virtio-9p-device,fsdev=v_9p_dev,mount_tag=hostshare "$@"
