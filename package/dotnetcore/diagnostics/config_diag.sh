#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

if [ $3 == "ARM64" ]; then
        toolchain=aarch64-buildroot-linux-gnu
elif [ $3 == "ARM" ]; then
        toolchain=arm-buildroot-linux-gnueabihf
else
        toolchain=x86_64-buildroot-linux-gnu
fi
cplusplusver=$(cd $2/$toolchain/include/c++;echo *)

function copy_headslibs {
        cp -u -v $1/lib/gcc/$3/$cplusplusver/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $2/usr/lib
}

copy_headslibs $2 $5 $toolchain

mkdir -p -v $5/usr/include/lldb/API
cp -u -v $2/include/lldb/API/* $5/usr/include/lldb/API
cp -u -v $2/include/lldb/*.h  $5/usr/include/lldb

