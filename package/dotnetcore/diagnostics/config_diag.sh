#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

patch -N -d $4/eng -p0 -u -b build.sh -i $6/diag_eng_build.sh.mypatch
patch -N -d $4/eng/cross -p0 -u -b toolchain.cmake -i $6/toolchain.cmake.mypatch

if [ $3 == "ARM64" ]; then
	cp -u -v $2/lib/gcc/aarch64-buildroot-linux-gnu/10.2.0/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $5/usr/lib
elif [ $3 == "ARM" ]; then
	cp -u -v $2/lib/gcc/arm-buildroot-linux-gnueabihf/10.2.0/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $5/usr/lib
else
	cp -u -v $2/lib/gcc/x86_64-buildroot-linux-gnu/10.2.0/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $5/usr/lib
fi

mkdir -p -v $5/usr/include/lldb/API
cp -u -v $2/include/lldb/API/* $5/usr/include/lldb/API
cp -u -v $2/include/lldb/*.h  $5/usr/include/lldb

