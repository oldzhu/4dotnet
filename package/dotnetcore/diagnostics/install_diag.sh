#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR

if [ $3 == "ARM64" ]; then
	mkdir -p $7/root/.dotnet/sos
	cp $4/artifacts/bin/Linux.aarch64.Debug/{libsos.so,libsosplugin.so,sosdocsunix.txt} \
	$7/root/.dotnet/sos
else
	mkdir -p $7/root/.dotnet/sos
	cp $4/artifacts/bin/Linux.arm.Debug/{libsos.so,libsosplugin.so,sosdocsunix.txt} \
	$7/root/.dotnet/sos
fi
