#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

patch -N -d $4/eng/common/cross -p0 -u -b toolchain.cmake -i $6/toolchain.cmake.mypatch

if [ $3 == "ARM64" ]; then
	mkdir $2/aarch64-buildroot-linux-gnueabihf/myinclude
	cp $5/usr/include/{features.h,stdc-predef.h} $2/aarch64-buildroot-linux-gnueabihf/myinclude
        cp -r $2/aarch64-buildroot-linux-gnueabihf/include/c++/10.2.0/{\
type_traits,cstdlib,new,exception,bits,cstring,string,typeinfo,ext,set,debug,cwchar,\
backward,cstdint,initializer_list,clocale,concepts,iosfwd,cctype,cstdio,cerrno,vector,\
algorithm,utility,cstddef,cassert,limits,cinttypes,memory,tuple,array,mutex,chrono,\
ratio,ctime,system_error,stdexcept,map} \
$2/aarch64-buildroot-linux-gnueabihf/myinclude
	cp -u -v $2/lib/gcc/aarch64-buildroot-linux-gnueabihf/10.2.0/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $5/usr/lib
else
	mkdir $2/arm-buildroot-linux-gnueabihf/myinclude
	cp $5/usr/include/{features.h,stdc-predef.h} $2/arm-buildroot-linux-gnueabihf/myinclude
	cp -r $2/arm-buildroot-linux-gnueabihf/include/c++/10.2.0/{\
type_traits,cstdlib,new,exception,bits,cstring,string,typeinfo,ext,set,debug,cwchar,\
backward,cstdint,initializer_list,clocale,concepts,iosfwd,cctype,cstdio,cerrno,vector,\
algorithm,utility,cstddef,cassert,limits,cinttypes,memory,tuple,array,mutex,chrono,\
ratio,ctime,system_error,stdexcept,map} \
$2/arm-buildroot-linux-gnueabihf/myinclude
        cp -u -v $2/lib/gcc/arm-buildroot-linux-gnueabihf/10.2.0/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $5/usr/lib
fi

mkdir -p -v $5/usr/include/lldb/API
cp -u -v $2/include/lldb/API/* $5/usr/include/lldb/API
cp -u -v $2/include/lldb/*.h  $5/usr/include/lldb
