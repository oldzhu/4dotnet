#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

hostlldbpath=$(find $1 -maxdepth 1  -name host-lldb-\* -type d -print -quit)
export PATH=$hostlldbpath/llvm/buildroot-build/bin:$PATH:$2/bin;
export ROOTFS_DIR=$5

if [ $3 == "ARM" ]; then
	export TOOLCHAIN=arm-buildroot-linux-gnueabihf;
	rid=linux-arm;
elif [ $3 == "ARM64" ]; then
	export TOOLCHAIN=aarch64-buildroot-linux-gnu;
	rid=linux-arm64;
elif [ $3 == "RISCV32" ]; then
        export TOOLCHAIN=riscv32-buildroot-linux-gnu;
elif [ $3 == "RISCV64" ]; then
        export TOOLCHAIN=riscv64-buildroot-linux-gnu;
else
	export TOOLCHAIN=x86_64-buildroot-linux-gnu;
	rid=linux-x64
fi

$4/build.sh \
-architecture $3 \
-cross \
-c release 
#/p:PublishReadyToRun=true
#/p:EnableSourceLink=false 
#/p:Platform=$3
#-v d
#-rootfs  $5 
