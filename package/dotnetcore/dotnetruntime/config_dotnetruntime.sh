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
add_includes $4 src/coreclr/src/hosts/unixcoreruncommon/CMakeLists.txt
add_includes $4 src/coreclr/src/hosts/unixcorerun/CMakeLists.txt
add_includes $4 src/coreclr/src/hosts/unixcoreconsole/CMakeLists.txt
#add_includes $4 src/coreclr/src/pal/CMakeLists.txt
add_includes $4 src/coreclr/src/pal/src/eventprovider/lttngprovider/CMakeLists.txt
add_includes $4 src/coreclr/src/pal/src/CMakeLists.txt
add_includes $4 src/coreclr/src/debug/dbgutil/CMakeLists.txt
add_includes $4 src/coreclr/src/gc/CMakeLists.txt
add_includes $4 src/coreclr/src/debug/createdump/CMakeLists.txt
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

if [ $3 == "ARM64" ]; then
	mkdir $2/aarch64-buildroot-linux-gnueabihf/myinclude
	cp -r $5/usr/include/{features.h,stdc-predef.h,sys,bits,gnu} $2/aarch64-buildroot-linux-gnueabihf/myinclude
        cp -r $2/aarch64-buildroot-linux-gnueabihf/include/c++/10.2.0/{\
type_traits,cstdlib,new,exception,bits,cstring,string,typeinfo,ext,set,debug,cwchar,\
backward,cstdint,initializer_list,clocale,concepts,iosfwd,cctype,cstdio,cerrno,vector,\
algorithm,utility,cstddef,cassert,limits,cinttypes,memory,tuple,array,mutex,chrono,\
ratio,ctime,system_error,stdexcept,map,iostream,fstream,istream,ostream,cwctype,sstream,cstdarg,unordered_map,unordered_set,\
climits,functional,locale,codecvt,iterator,list,atomic,condition_variable,thread,future} \
$2/aarch64-buildroot-linux-gnueabihf/myinclude
	cp -u -v $2/lib/gcc/aarch64-buildroot-linux-gnueabihf/10.2.0/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $5/usr/lib
else
	patch -N -d $4/src/coreclr/src/vm/arm -p0 -u -b cgencpu.h -i $6/cgencpu.h.mypatch
	mkdir $2/arm-buildroot-linux-gnueabihf/myinclude
	cp -r $5/usr/include/{features.h,stdc-predef.h,sys,bits,gnu} $2/arm-buildroot-linux-gnueabihf/myinclude
	cp -r $2/arm-buildroot-linux-gnueabihf/include/c++/10.2.0/{\
type_traits,cstdlib,new,exception,bits,cstring,string,typeinfo,ext,set,debug,cwchar,\
backward,cstdint,initializer_list,clocale,concepts,iosfwd,cctype,cstdio,cerrno,vector,\
algorithm,utility,cstddef,cassert,limits,cinttypes,memory,tuple,array,mutex,chrono,\
ratio,ctime,system_error,stdexcept,map,iostream,fstream,istream,ostream,cwctype,sstream,cstdarg,unordered_map,unordered_set,\
climits,functional,locale,codecvt,iterator,list,atomic,condition_variable,thread,future} \
$2/arm-buildroot-linux-gnueabihf/myinclude
        cp -u -v $2/lib/gcc/arm-buildroot-linux-gnueabihf/10.2.0/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $5/usr/lib
fi

mkdir -p -v $5/usr/include/lldb/API
cp -u -v $2/include/lldb/API/* $5/usr/include/lldb/API
cp -u -v $2/include/lldb/*.h  $5/usr/include/lldb
