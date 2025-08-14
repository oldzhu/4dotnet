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
elif [ $3 == "ARM64" ]; then
        export TOOLCHAIN=aarch64-buildroot-linux-gnu;
else
        export TOOLCHAIN=x86_64-buildroot-linux-gnu;
fi

cplusplusver=$(cd $2/$TOOLCHAIN/include/c++;echo *)

export CPLUS_INCLUDE_PATH="$2/$TOOLCHAIN/include/c++/$cplusplusver:$2/$TOOLCHAIN/include/c++/$cplusplusver/$TOOLCHAIN:$2/$TOOLCHAIN/sysroot/usr/include"
export C_INCLUDE_PATH="$2/$TOOLCHAIN/sysroot/usr/include"
export LIBRARY_PATH="$2/lib/gcc/$TOOLCHAIN/$cplusplusver"
export LDFLAGS="-L$2/lib/gcc/$TOOLCHAIN/$cplusplusver -Wl,-rpath=$2/lib/gcc/$TOOLCHAIN/$cplusplusver"

# Preserve existing CMAKE_LIBRARY_PATH and APPEND new path LAST
export CMAKE_LIBRARY_PATH="${CMAKE_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu"

$4/build.sh \
-subset clr+libs+host+packs \
-arch $3 \
-cross \
-c release \
-cmakeargs "--debug-trycompile" \
-cmakeargs "-DCMAKE_VERBOSE_MAKEFILE=ON"
#-v d
#/p:EnableSourceLink=false
