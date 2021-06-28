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

function add_includes {
	echo >> $1/$2
#	echo if\(\$ENV{CROSSCOMPILE} EQUAL 1\) >> $1/$2
	echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/include/c++/$cplusplusver\) >> $1/$2
	echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/include/c++/$cplusplusver/\$ENV{TOOLCHAIN}\) >> $1/$2
#	echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/myinclude\) >> $1/$2
#	echo endif\(\) >> $1/$2
}

add_includes $4 eng/cross/toolchain.cmake

patch -N -d $4/eng -p0 -u -b build.sh -i $6/diag_eng_build.sh.mypatch
#patch -N -d $4/eng/cross -p0 -u -b toolchain.cmake -i $6/toolchain.cmake.mypatch

if [ $3 == "ARM64" ]; then
	patch -N -d $4/src/pal/src/locale -p0 -u -b utf8.cpp -i $6/utf8.cpp.mypatch
fi

cp -u -v $2/lib/gcc/$toolchain/$cplusplusver/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $5/usr/lib

mkdir -p -v $5/usr/include/lldb/API
cp -u -v $2/include/lldb/API/* $5/usr/include/lldb/API
cp -u -v $2/include/lldb/*.h  $5/usr/include/lldb

