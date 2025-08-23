#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

dotnetruntimepath=$(find $1 -maxdepth 1  -name dotnetruntime-\* -type d -print -quit)
publishpath=($4/bin/*/*/*/publish)
mkdir -p $7/root/dotnethello
cp -v $publishpath/* $7/root/dotnethello
#nativesympath=($1/dotnetruntime-origin_main/artifacts/bin/microsoft.netcore.app.runtime.*/Release/runtimes/*/native)
nativesympath=($dotnetruntimepath/artifacts/bin/microsoft.netcore.app.runtime.*/Release/runtimes/*/native)
cp -v $nativesympath/*.so.dbg $7/root/dotnethello
#cp -v $1/dotnetruntime-origin_main/artifacts/bin/*/corehost/{libhostfxr.so.dbg,libhostpolicy.so.dbg} $7/root/dotnethello
#cp -v $dotnetruntimepath/artifacts/bin/*/corehost/{libhostfxr.so.dbg,libhostpolicy.so.dbg} $7/root/dotnethello

#cp -v $dotnetruntimepath/artifacts/bin/coreclr/*/{corerun,corerun.dbg} $7/root/dotnethello

