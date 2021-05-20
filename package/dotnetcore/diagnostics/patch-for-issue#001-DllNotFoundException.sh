#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR
# fix the compile error [-Werror,-Wreserved-identifier]

# this script does not fix the DllNotFoundException but raise another building error as the the latest diagnostics sources call some functions 
# do not exist in the old version ClrMD libraries
# the soltuion should be report the issue to ClrMD or diagnostics repo. In our side, we need to support build sos plugin from tarball release

sed -i "39s/226801/222201/" $4/eng/Versions.props
sed -i "40s/226801/222201/" $4/eng/Versions.props

