#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

export PATH=$1/host-lldb-origin_master/llvm/buildroot-build/bin:$PATH:$2/bin;
export ROOTFS_DIR=$5

if [ $3 == "ARM" ]; then
	export TOOLCHAIN=arm-buildroot-linux-gnueabihf;
else
	export TOOLCHAIN=aarch64-buildroot-linux-gnueabihf;
fi

$4/build.sh \
-subset clr+libs \
-arch $3 \
-c debug \
-cross \
-pack \
/p:EnableSourceLink=false
