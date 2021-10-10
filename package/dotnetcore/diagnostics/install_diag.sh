#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

dotnetruntimepath=$(find $1 -maxdepth 1  -name dotnetruntime-\* -type d -print -quit)
clrmdpath=$(find $1 -maxdepth 1  -name clrmd-\* -type d -print -quit)
symstorepath=$(find $1 -maxdepth 1  -name symstore-\* -type d -print -quit)

sourcepath=($4/artifacts/bin/Linux.*)
mkdir -p $7/root/.dotnet/sos
cp -v $sourcepath/* $7/root/.dotnet/sos

# fix the issue #1 SOS throw System.DllNotFoundException in latest build
cp -v $clrmdpath/artifacts/bin/Microsoft.Diagnostics.Runtime/Release/netcoreapp3.1/*.dll $7/root/.dotnet/sos
cp -v $clrmdpath/artifacts/bin/Microsoft.Diagnostics.Runtime.Utilities/Release/netcoreapp3.1/*.dll $7/root/.dotnet/sos

# using the self build Microsoft.FileFormats.dll and Microsoft.SymbolStore.dll
cp -v $symstorepath/artifacts/bin/SymClient/Release/netcoreapp3.1/Microsoft.FileFormats.* $7/root/.dotnet/sos
cp -v $symstorepath/artifacts/bin/SymClient/Release/netcoreapp3.1/Microsoft.SymbolStore.* $7/root/.dotnet/sos

# fix the issue #3 sos clrstack throw System.ArgumentNullException
#cp -v $7/root/dotnethello/{System.Collections.Immutable.dll,System.Reflection.Metadata.dll} $7/root/.dotnet/sos
r2rpath=($dotnetruntimepath/artifacts/obj/Microsoft.NETCore.App.Runtime/Release/net*/linux-*/R2R)
cp -v $r2rpath/{System.Collections.Immutable.dll,System.Reflection.Metadata.dll} $7/root/.dotnet/sos

#if [ $3 == "ARM64" ]; then
#	mkdir -p $7/root/.dotnet/sos
#	cp -v $4/artifacts/bin/Linux.aarch64.Debug/{libsos.so,libsosplugin.so,sosdocsunix.txt} \
#	$7/root/.dotnet/sos
#elif [ $3 == "ARM" ]; then
#	mkdir -p $7/root/.dotnet/sos
#	cp -v $4/artifacts/bin/Linux.arm.Debug/{libsos.so,libsosplugin.so,sosdocsunix.txt} \
#	$7/root/.dotnet/sos
#else
#	mkdir -p $7/root/.dotnet/sos
#        cp -v $4/artifacts/bin/Linux.x86_64.Debug/{libsos.so,libsosplugin.so,sosdocsunix.txt} \
#        $7/root/.dotnet/sos
#fi
