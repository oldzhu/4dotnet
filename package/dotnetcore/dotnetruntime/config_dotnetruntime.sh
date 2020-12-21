#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

#patch -N -d $4/eng/common/cross -p0 -u -b toolchain.cmake -i $6/toolchain.cmake.mypatch

function add_includes {
echo if\(\$ENV{CROSSCOMPILE} EQUAL 1\) >> $1/$2
echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/include/c++/10.2.0/\$ENV{TOOLCHAIN}\) >> $1/$2
echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/myinclude\) >> $1/$2
echo endif\(\) >> $1/$2
}

#add_includes $4 src/coreclr/src/CMakeLists.txt
#add_includes $4 src/coreclr/src/hosts/CMakeLists.txt
#add_includes $4 src/coreclr/hosts/unixcoreruncommon/CMakeLists.txt
add_includes $4 src/coreclr/hosts/unixcorerun/CMakeLists.txt
#add_includes $4 src/coreclr/hosts/unixcoreconsole/CMakeLists.txt
#add_includes $4 src/coreclr/pal/CMakeLists.txt
add_includes $4 src/coreclr/pal/src/eventprovider/lttngprovider/CMakeLists.txt
add_includes $4 src/coreclr/pal/src/CMakeLists.txt
add_includes $4 src/coreclr/debug/dbgutil/CMakeLists.txt
add_includes $4 src/coreclr/gc/CMakeLists.txt
add_includes $4 src/coreclr/debug/createdump/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/apphost/standalone/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/hostcommon/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/dotnet/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/apphost/static/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/nethost/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/test/mockcoreclr/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/test/mockhostfxr/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/test/mockhostpolicy/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/test_fx_ver/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/test/nativehost/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/fxr/standalone/CMakeLists.txt
add_includes $4 src/installer/corehost/cli/hostpolicy/standalone/CMakeLists.txt

function copy_headslibs {
        mkdir -p -v $1/$3/myinclude
        cp -r -v $2/usr/include/{features.h,stdc-predef.h,sys,bits,gnu} $1/$3/myinclude
        cp -r -v $1/$3/include/c++/10.2.0/{\
type_traits,cstdlib,new,exception,bits,cstring,string,typeinfo,ext,set,debug,cwchar,\
backward,cstdint,initializer_list,clocale,concepts,iosfwd,cctype,cstdio,cerrno,vector,\
algorithm,utility,cstddef,cassert,limits,cinttypes,memory,tuple,array,mutex,chrono,\
ratio,ctime,system_error,stdexcept,map,iostream,fstream,istream,ostream,cwctype,sstream,cstdarg,unordered_map,unordered_set,\
climits,functional,locale,codecvt,iterator,list,atomic,condition_variable,thread,future} \
$1/$3/myinclude
        cp -u -v $1/lib/gcc/$3/10.2.0/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $2/usr/lib
}

if [ $3 == "ARM64" ]; then
	toolchain=aarch64-buildroot-linux-gnu
	copy_headslibs $2 $5 $toolchain
elif [ $3 == "ARM" ]; then
	patch -N -d $4/src/coreclr/vm/arm -p0 -u -b cgencpu.h -i $6/cgencpu.h.mypatch
	toolchain=arm-buildroot-linux-gnueabihf
	copy_headslibs $2 $5 $toolchain
else
	toolchain=x86_64-buildroot-linux-gnu
	copy_headslibs $2 $5 $toolchain
fi

mkdir -p -v $5/usr/include/lldb/API
cp -u -v $2/include/lldb/API/* $5/usr/include/lldb/API
cp -u -v $2/include/lldb/*.h  $5/usr/include/lldb
