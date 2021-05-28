#!/bin/bash

qemumkfile=$HOME/buildroot/package/qemu/qemu.mk

sed -i -r '/\t\t--enable-debug \\/d' $qemumkfile
sed -i -r '/\$\(HOST_QEMU_OPTS\)/i\\t\t--enable-debug \\' $qemumkfile
pushd $HOME/buildroot
make host-qemu-reconfigure
popd
sed -i -r '/\t\t--enable-debug \\/d' $qemumkfile

