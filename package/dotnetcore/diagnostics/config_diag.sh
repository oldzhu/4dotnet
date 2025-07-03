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
elif [ $3 == "RISCV32" ]; then
        toolchain=riscv32-buildroot-linux-gnu
elif [ $3 == "RISCV64" ]; then
        toolchain=riscv64-buildroot-linux-gnu
else
        toolchain=x86_64-buildroot-linux-gnu
fi
cplusplusver=$(cd $2/$toolchain/include/c++;echo *)

function add_includes {
	echo >> $1/$2
#	echo if\(\$ENV{CROSSCOMPILE} EQUAL 1\) >> $1/$2
	echo if\(NOT CLR_CROSS_COMPONENTS_BUILD\) >> $1/$2
#	echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/include/c++/$cplusplusver\) >> $1/$2
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
backward,cstdint,initializer_list,clocale,concepts,iosfwd,cctype,cstdio,cerrno,deque,vector,\
algorithm,utility,cstddef,cassert,limits,cinttypes,memory,tuple,array,mutex,chrono,\
ratio,ctime,system_error,stdexcept,map,iostream,fstream,istream,ostream,cwctype,sstream,cstdarg,unordered_map,unordered_set,\
climits,functional,locale,codecvt,iterator,list,atomic,condition_variable,thread,future,ios,streambuf,bit,cxxabi.h} \
$1/$3/myinclude
        cp -u -v $1/lib/gcc/$3/$cplusplusver/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $2/usr/lib
}

#apply_mypatches $4 $6
#add_includes $4 eng/cross/toolchain.cmake
copy_headslibs $2 $5 $toolchain

add_includes $4 src/SOS/extensions/CMakeLists.txt
add_includes $4 src/shared/pal/src/CMakeLists.txt
add_includes $4 src/shared/dbgutil/CMakeLists.txt
add_includes $4 src/shared/debug/dbgutil/CMakeLists.txt
add_includes $4 src/shared/palrt/CMakeLists.txt
add_includes $4 src/shared/utilcode/CMakeLists.txt
add_includes $4 src/shared/inc/CMakeLists.txt
add_includes $4 src/dbgshim/CMakeLists.txt
add_includes $4 src/SOS/lldbplugin/CMakeLists.txt
add_includes $4 src/SOS/Strike/CMakeLists.txt

#cp -u -v $2/lib/gcc/$toolchain/$cplusplusver/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $5/usr/lib

mkdir -p -v $5/usr/include/lldb/API
cp -u -v $2/include/lldb/API/* $5/usr/include/lldb/API
cp -u -v $2/include/lldb/*.h  $5/usr/include/lldb

# Insert the line "sed -e" at the 2nd line of eng/build.sh
sed -i '2i set -e' $4/eng/build.sh

# Define the file to modify
file="$4/src/SOS/lldbplugin/services.cpp"

# Use sed to find and insert lines

sed -i '/#elif DBG_TARGET_ARM64/{N;/\n    DWORD64 spToFind = dtcontext->Sp;/a #elif DBG_TARGET_RISCV64\n    DWORD64 spToFind = dtcontext->Sp;
}' "$file"

sed -i '/#elif DBG_TARGET_X86/{
    N
    /    \*type = IMAGE_FILE_MACHINE_I386;/a\
#elif DBG_TARGET_RISCV64\
    \*type = IMAGE_FILE_MACHINE_RISCV64;
}' "$file"
