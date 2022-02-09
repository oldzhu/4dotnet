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
	echo if\(\$ENV{CROSSCOMPILE} EQUAL 1\) >> $1/$2
	echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/include/c++/$cplusplusver\) >> $1/$2
	echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/include/c++/$cplusplusver/\$ENV{TOOLCHAIN}\) >> $1/$2
	echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/myinclude\) >> $1/$2
	echo endif\(\) >> $1/$2
}
function apply_mypatches {
        shopt -s globstar
        for mypatchfile in $2/mypatches/*.mypatch
	do
	    patch -N -d $1 -p7 -u -b -i $mypatchfile
	done
}
function copy_headslibs {
        mkdir -p -v $1/$3/myinclude
        cp -r -v $2/usr/include/{features.h,stdc-predef.h,sys,bits,gnu} $1/$3/myinclude
        cp -r -v $1/$3/include/c++/$cplusplusver/{\
type_traits,cstdlib,new,exception,bits,cstring,string,typeinfo,ext,set,debug,cwchar,\
backward,cstdint,initializer_list,clocale,concepts,iosfwd,cctype,cstdio,cerrno,vector,\
algorithm,utility,cstddef,cassert,limits,cinttypes,memory,tuple,array,mutex,chrono,\
ratio,ctime,system_error,stdexcept,map,iostream,fstream,istream,ostream,cwctype,sstream,cstdarg,unordered_map,unordered_set,\
climits,functional,locale,codecvt,iterator,list,atomic,condition_variable,thread,future,ios,streambuf,bit,cxxabi.h} \
$1/$3/myinclude
        cp -u -v $1/lib/gcc/$3/$cplusplusver/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $2/usr/lib
}

apply_mypatches $4 $6
#add_includes $4 eng/cross/toolchain.cmake
copy_headslibs $2 $5 $toolchain

add_includes $4 src/SOS/extensions/CMakeLists.txt
add_includes $4 src/shared/pal/src/CMakeLists.txt
add_includes $4 src/shared/dbgutil/CMakeLists.txt
add_includes $4 src/SOS/lldbplugin/CMakeLists.txt
add_includes $4 src/SOS/Strike/CMakeLists.txt

#cp -u -v $2/lib/gcc/$toolchain/$cplusplusver/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $5/usr/lib

mkdir -p -v $5/usr/include/lldb/API
cp -u -v $2/include/lldb/API/* $5/usr/include/lldb/API
cp -u -v $2/include/lldb/*.h  $5/usr/include/lldb

