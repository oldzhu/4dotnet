#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR
# fix the compile error [-Werror,-Wreserved-identifier]

#patch -N -d $4/src/coreclr/inc -p0 -u -b sbuffer.inl -i $6/mypatches/sbuffer.inl.mypatch
#patch -N -d $4/src/coreclr/md/ceefilegen -p0 -u -b blobfetcher.cpp -i $6/mypatches/blobfetcher.cpp.mypatch
#patch -N -d $4/src/coreclr/md/ceefilegen -p0 -u -b cceegen.cpp -i $6/mypatches/cceegen.cpp.mypatch
#patch -N -d $4/src/coreclr/inc -p0 -u -b holder.h -i $6/mypatches/holder.h.mypatch
#patch -N -d $4/src/libraries/Native/Unix/System.Globalization.Native -p0 -u -b pal_collation.c -i $6/mypatches/pal_collation.c.mypatch
#patch -N -d $4/src/libraries/Native/Unix/System.Security.Cryptography.Native -p0 -u -b openssl.c -i $6/mypatches/openssl.c.mypatch
#patch -N -d $4/src/coreclr/md/enc -p0 -u -b metamodelrw.cpp -i $6/mypatches/metamodelrw.cpp.mypatch
#patch -N -d $4/src/coreclr/md/enc -p0 -u -b liteweightstgdbrw.cpp -i $6/mypatches/liteweightstgdbrw.cpp.mypatch
#patch -N -d $4/src/coreclr/md/compiler -p0 -u -b importhelper.cpp -i $6/mypatches/importhelper.cpp.mypatch
#patch -N -d $4/src/coreclr/md/compiler -p0 -u -b mdutil.cpp -i $6/mypatches/mdutil.cpp.mypatch
#patch -N -d $4/src/libraries/Native/Unix/System.Security.Cryptography.Native -p0 -u -b pal_err.c -i $6/mypatches/pal_err.c.mypatch
#patch -N -d $4/src/coreclr/md/compiler -p0 -u -b import.cpp -i $6/mypatches/import.cpp.mypatch
#patch -N -d $4/src/coreclr/md/enc -p0 -u -b stgio.cpp -i $6/mypatches/stgio.cpp.mypatch
#patch -N -d $4/src/coreclr/md/compiler -p0 -u -b regmeta_emit.cpp -i $6/mypatches/regmeta_emit.cpp.mypatch
#patch -N -d $4/src/libraries/Native/Unix/System.Security.Cryptography.Native -p0 -u -b pal_ssl.c -i $6/mypatches/pal_ssl.c.mypatch
patch -N -d $4/src/libraries/Native/Unix/System.Native -p0 -u -b pal_process.c -i $6/mypatches/pal_process.c.mypatch
#patch -N -d $4/src/coreclr/gcdump/i386 -p0 -u -b gcdumpx86.cpp -i $6/mypatches/gcdumpx86.cpp.mypatch
#patch -N -d $4/src/coreclr/dlls/mscorpe -p0 -u -b pewriter.cpp -i $6/mypatches/pewriter.cpp.mypatch
#patch -N -d $4/src/coreclr/pal/src/cruntime -p0 -u -b wchar.cpp -i $6/mypatches/wchar.cpp.mypatch
#patch -N -d $4/src/coreclr/pal/src/loader -p0 -u -b module.cpp -i $6/mypatches/module.cpp.mypatch
#patch -N -d $4/src/coreclr/pal/src/locale -p0 -u -b unicode.cpp -i $6/mypatches/unicode.cpp.mypatch
#patch -N -d $4/src/coreclr/pal/src/misc -p0 -u -b fmtmessage.cpp -i $6/mypatches/fmtmessage.cpp.mypatch
#patch -N -d $4/src/coreclr/pal/src/safecrt  -p0 -u -b input.inl -i $6/mypatches/input.inl.mypatch
#patch -N -d $4/src/coreclr/pal/src/shmemory -p0 -u -b shmemory.cpp -i $6/mypatches/shmemory.cpp.mypatch
#patch -N -d $4/src/coreclr/pal/src/sync -p0 -u -b cs.cpp  -i $6/mypatches/cs.cpp.mypatch
#patch -N -d $4/src/coreclr/pal/src/synchmgr -p0 -u -b synchcontrollers.cpp -i $6/mypatches/synchcontrollers.cpp.mypatch
#patch -N -d $4/src/coreclr/pal/src/synchmgr -p0 -u -b synchmanager.cpp -i $6/mypatches/synchmanager.cpp.mypatch
patch -N -d $4/eng/native -p0 -u -b configurecompiler.cmake -i $6/mypatches/configurecompiler.cmake.mypatch
