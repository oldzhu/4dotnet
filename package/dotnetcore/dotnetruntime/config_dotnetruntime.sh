#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

#patch -N -d $4/eng/common/cross -p0 -u -b toolchain.cmake -i $6/toolchain.cmake.mypatch

if [ $3 == "ARM64" ]; then
	toolchain=aarch64-buildroot-linux-gnu
elif [ $3 == "ARM" ]; then
        #patch -N -d $4/src/coreclr/vm/arm -p0 -u -b cgencpu.h -i $6/cgencpu.h.mypatch
        toolchain=arm-buildroot-linux-gnueabihf
elif [ $3 == "RISCV32" ]; then
	toolchain=riscv32-buildroot-linux-gnu
elif [ $3 == "RISCV64" ]; then
	toolchain=riscv64-buildroot-linux-gnu
else
        toolchain=x86_64-buildroot-linux-gnu
fi

cplusplusver=$(cd $2/$toolchain/include/c++;echo *)
bldver=${4#*-}
echo $bldver

#$6/patch-2021-05-06.sh "$@"
#$6/patch-to-v6.0.0-preview.3.21201.4-001.sh "$@"
#$6/patch-for-clang13-Wunused-but-set-variable.sh "$@"

#fix FALSE/TRUE compilation error in src/libraries/Native/Unix/System.Globalization.Native
#sed -i 's/FALSE/0/g'  $4/src/libraries/Native/Unix/System.Globalization.Native/*.c
#sed -i 's/TRUE/1/g' $4/src/libraries/Native/Unix/System.Globalization.Native/*.c

function add_includes {
if [ -f "$1/$2" ]; then
   echo >> $1/$2
#   echo if\(\$ENV{CROSSCOMPILE} EQUAL 1\) >> $1/$2
   echo if\(NOT CLR_CROSS_COMPONENTS_BUILD\) >> $1/$2
   echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/include/c++/$cplusplusver/\$ENV{TOOLCHAIN}\) >> $1/$2
   echo include_directories\(\$ENV{HOST_DIR}/\$ENV{TOOLCHAIN}/myinclude\) >> $1/$2
#   echo endif\(\) >> $1/$2
   echo endif\(\) >> $1/$2
fi
}

add_includes $4 src/coreclr/pal/src/eventprovider/lttngprovider/CMakeLists.txt
add_includes $4 src/coreclr/pal/src/CMakeLists.txt
add_includes $4 src/coreclr/debug/dbgutil/CMakeLists.txt
add_includes $4 src/coreclr/debug/createdump/CMakeLists.txt
add_includes $4 src/coreclr/debug/debug-pal/CMakeLists.txt
add_includes $4 src/coreclr/debug/daccess/CMakeLists.txt
add_includes $4 src/coreclr/debug/runtimeinfo/CMakeLists.txt
add_includes $4 src/coreclr/debug/di/CMakeLists.txt
add_includes $4 src/coreclr/debug/ee/wks/CMakeLists.txt
add_includes $4 src/coreclr/debug/ee/dac/CMakeLists.txt
add_includes $4 src/coreclr/gc/CMakeLists.txt
add_includes $4 src/coreclr/gc/unix/CMakeLists.txt
add_includes $4 src/coreclr/interop/CMakeLists.txt
add_includes $4 src/coreclr/nativeresources/CMakeLists.txt
add_includes $4 src/coreclr/palrt/CMakeLists.txt
add_includes $4 src/coreclr/inc/CMakeLists.txt
add_includes $4 src/coreclr/gcinfo/CMakeLists.txt
add_includes $4 src/coreclr/md/runtime/CMakeLists.txt
add_includes $4 src/coreclr/md/compiler/CMakeLists.txt
add_includes $4 src/coreclr/md/enc/CMakeLists.txt
add_includes $4 src/coreclr/md/ceefilegen/CMakeLists.txt
add_includes $4 src/coreclr/md/datasource/CMakeLists.txt
add_includes $4 src/coreclr/md/staticmd/CMakeLists.txt
add_includes $4 src/coreclr/dlls/mscorpe/CMakeLists.txt
add_includes $4 src/coreclr/vm/eventing/eventpipe/CMakeLists.txt
add_includes $4 src/coreclr/vm/eventing/userevents/CMakeLists.txt
add_includes $4 src/coreclr/vm/wks/CMakeLists.txt
add_includes $4 src/coreclr/vm/CMakeLists.txt
add_includes $4 src/coreclr/classlibnative/float/CMakeLists.txt
add_includes $4 src/coreclr/classlibnative/bcltype/CMakeLists.txt
add_includes $4 src/coreclr/binder/CMakeLists.txt
add_includes $4 src/coreclr/unwinder/CMakeLists.txt
add_includes $4 src/coreclr/utilcode/CMakeLists.txt
add_includes $4 src/coreclr/jit/static/CMakeLists.txt
add_includes $4 src/coreclr/jit/CMakeLists.txt
add_includes $4 src/coreclr/ilasm/CMakeLists.txt
add_includes $4 src/coreclr/ildasm/exe/CMakeLists.txt
add_includes $4 src/coreclr/tools/superpmi/CMakeLists.txt
add_includes $4 src/coreclr/tools/superpmi/mcs/CMakeLists.txt
add_includes $4 src/coreclr/tools/superpmi/superpmi/CMakeLists.txt
add_includes $4 src/coreclr/tools/superpmi/superpmi-shim-collector/CMakeLists.txt
add_includes $4 src/coreclr/tools/superpmi/superpmi-shim-counter/CMakeLists.txt
add_includes $4 src/coreclr/tools/superpmi/superpmi-shim-simple/CMakeLists.txt
add_includes $4 src/coreclr/dlls/mscordbi/CMakeLists.txt
add_includes $4 src/coreclr/dlls/mscoree/coreclr/CMakeLists.txt
add_includes $4 src/native/watchdog/CMakeLists.txt
add_includes $4 src/coreclr/nativeaot/Runtime/eventpipe/CMakeLists.txt
add_includes $4 src/native/corehost/apphost/standalone/CMakeLists.txt
add_includes $4 src/native/corehost/apphost/static/CMakeLists.txt
add_includes $4 src/native/corehost/fxr/standalone/CMakeLists.txt
add_includes $4 src/native/corehost/fxr/staticlib/CMakeLists.txt
add_includes $4 src/native/corehost/hostcommon/CMakeLists.txt
add_includes $4 src/native/corehost/dotnet/CMakeLists.txt
add_includes $4 src/native/corehost/nethost/CMakeLists.txt
add_includes $4 src/native/corehost/test/mockcoreclr/CMakeLists.txt
add_includes $4 src/native/corehost/test/mockhostpolicy/CMakeLists.txt
add_includes $4 src/native/corehost/test/nativehost/CMakeLists.txt
add_includes $4 src/native/corehost/hostpolicy/standalone/CMakeLists.txt
add_includes $4 src/native/corehost/hostmisc/CMakeLists.txt
add_includes $4 src/coreclr/hosts/corerun/CMakeLists.txt
add_includes $4 src/native/corehost/test/fx_ver/CMakeLists.txt
add_includes $4 src/native/corehost/test/mockhostfxr/2_2/CMakeLists.txt
add_includes $4 src/native/corehost/test/mockhostfxr/5_0/CMakeLists.txt
add_includes $4 src/native/corehost/test/mockhostfxr/CMakeLists.txt
add_includes $4 src/coreclr/nativeaot/Runtime/Full/CMakeLists.txt

function copy_headslibs {
        mkdir -p -v $1/$3/myinclude
        cp -r -v $2/usr/include/{features.h,features-time64.h,stdc-predef.h,sys,bits,gnu,math.h} $1/$3/myinclude
        cp -r -v $1/$3/include/c++/$cplusplusver/{\
type_traits,cstdlib,new,exception,bits,cstring,string,typeinfo,ext,set,debug,cwchar,\
backward,cstdint,initializer_list,clocale,concepts,iosfwd,cctype,cstdio,cerrno,vector,\
algorithm,utility,cstddef,cassert,limits,cinttypes,memory,tuple,compare,array,mutex,chrono,\
ratio,ctime,system_error,stdexcept,map,iostream,fstream,istream,ostream,cwctype,sstream,cstdarg,unordered_map,unordered_set,\
climits,functional,locale,codecvt,iterator,list,atomic,condition_variable,thread,future,ios,streambuf,bit,cxxabi.h,cmath} \
$1/$3/myinclude
	cp -r -v $1/$3/include/c++/$cplusplusver/type_traits $2/usr/include
	cp -r -v $1/$3/include/c++/$cplusplusver/$3/bits $2/usr/include
        cp -u -v $1/lib/gcc/$3/$cplusplusver/{crtbegin.o,crtend.o,crtbeginS.o,crtendS.o,libgcc.a} $2/usr/lib
}

function apply_mypatches {
	shopt -s globstar
	for mypatchfile in $2/mypatches/*.local.$bldver.mypatch
	do
	    [ -f "$mypatchfile" ] || continue
            patch -N -d $1 -p7 -u -b -i $mypatchfile
        done
        for mypatchfile in $2/mypatches/*.git.$bldver.mypatch
	do
	    [ -f "$mypatchfile" ] || continue
            patch -N -d $1 -p1 -u -b -i $mypatchfile
        done
}

apply_mypatches $4 $6
copy_headslibs $2 $5 $toolchain


mkdir -p -v $5/usr/include/lldb/API
cp -u -v $2/include/lldb/API/* $5/usr/include/lldb/API
cp -u -v $2/include/lldb/*.h  $5/usr/include/lldb

# Replace 'abs(' with 'std::abs(' in the file src/coreclr/jit/codegenriscv64.cpp
sed -i 's/abs(/std::abs(/g' $4/src/coreclr/jit/codegenriscv64.cpp
