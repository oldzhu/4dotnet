#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR
# fix the compile error [-Werror,-Wreserved-identifier]

sed -i "99s/_STACK/STACK_/"  $4/src/libraries/Native/Unix/System.Security.Cryptography.Native/opensslshim.h

