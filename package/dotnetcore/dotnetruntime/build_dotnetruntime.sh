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

clang_include_dir=$(find "$hostlldbpath/llvm/buildroot-build/lib/clang" -maxdepth 1 -type d -name '*.*' -print -quit)/include

if [ $3 == "ARM" ]; then
        export TOOLCHAIN=arm-buildroot-linux-gnueabihf;
elif [ $3 == "ARM64" ]; then
	export TOOLCHAIN=aarch64-buildroot-linux-gnu;
elif [ $3 == "RISCV32" ]; then
	export TOOLCHAIN=riscv32-buildroot-linux-gnu;
elif [ $3 == "RISCV64" ]; then
	export TOOLCHAIN=riscv64-buildroot-linux-gnu;
else
        export TOOLCHAIN=x86_64-buildroot-linux-gnu;
fi

cplusplusver=$(cd $2/$TOOLCHAIN/include/c++;echo *)

export MY_CPLUS_INCLUDE_PATH="$2/$TOOLCHAIN/include/c++/$cplusplusver:$2/$TOOLCHAIN/include/c++/$cplusplusver/$TOOLCHAIN:$2/$TOOLCHAIN/sysroot/usr/include"
#export C_INCLUDE_PATH="$2/$TOOLCHAIN/sysroot/usr/include"
#export LIBRARY_PATH="$2/lib/gcc/$TOOLCHAIN/$cplusplusver"
#export LDFLAGS="-L$2/lib/gcc/$TOOLCHAIN/$cplusplusver -Wl,-rpath=$2/lib/gcc/$TOOLCHAIN/$cplusplusver"

# Build EXTRA_CFLAGS with multi-line formatting
EXTRA_CFLAGS="-Wno-jump-misses-init"
EXTRA_CFLAGS="$EXTRA_CFLAGS -Wno-implicit-void-ptr-cast"
EXTRA_CFLAGS="$EXTRA_CFLAGS -Wno-implicit-int-enum-cast"
#EXTRA_CFLAGS="$EXTRA_CFLAGS -nostdinc"
#EXTRA_CFLAGS="$EXTRA_CFLAGS -isystem $clang_include_dir"

# Build EXTRA_CXXFLAGS with same structure
EXTRA_CXXFLAGS="-Wno-jump-misses-init"
EXTRA_CXXFLAGS="$EXTRA_CXXFLAGS -Wno-implicit-void-ptr-cast"
EXTRA_CXXFLAGS="$EXTRA_CXXFLAGS -Wno-implicit-int-enum-cast"
#EXTRA_CXXFLAGS="$EXTRA_CXXFLAGS -nostdinc"
#EXTRA_CXXFLAGS="$EXTRA_CXXFLAGS -isystem $clang_include_dir"

export EXTRA_CFLAGS
export EXTRA_CXXFLAGS

# Preserve existing CMAKE_LIBRARY_PATH and APPEND new path LAST
export CMAKE_LIBRARY_PATH="${CMAKE_LIBRARY_PATH}:/usr/lib/x86_64-linux-gnu"

$4/build.sh \
-subset clr+libs+tools+host+packs \
-arch $3 \
-cross \
-c release \
-cmakeargs "--debug-trycompile" \
-cmakeargs "-DCMAKE_VERBOSE_MAKEFILE=ON" \
-cmakeargs "-DCMAKE_CXX_COMPILER=$hostlldbpath/llvm/buildroot-build/bin/clang++" \
-cmakeargs "-DCMAKE_C_COMPILER=$hostlldbpath/llvm/buildroot-build/bin/clang"
#-v d
#/p:EnableSourceLink=false
