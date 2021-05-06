#!/bin/bash
# p1 BUILD_DIR
# p2 HOST_DIR
# p3 BR2_PACKAGE_{PKGNAME}_TARGET_ARCH
# p4 @D
# p5 STAGING_DIR
# p6 [PKGNAME}_PKGDIR
# p7 TARGET_DIR
# fix the compile error [-Werror,-Wreserved-identifier]

sed -i '312s/__c2/c__2/' $5/usr/include/unicode/utf16.h
sed -i '313s/__c2/c__2/' $5/usr/include/unicode/utf16.h
sed -i '315s/__c2/c__2/' $5/usr/include/unicode/utf16.h

sed -i '23s/__padding/_padding/' $4/src/libraries/Native/Unix/System.Native/pal_interfaceaddresses.h
sed -i '33s/__padding/_padding/' $4/src/libraries/Native/Unix/System.Native/pal_interfaceaddresses.h
sed -i '47s/__padding/_padding/' $4/src/libraries/Native/Unix/System.Native/pal_interfaceaddresses.h

sed -i '9s/_STACK/STACK_/'  $4/src/libraries/Native/Unix/System.Security.Cryptography.Native/osslcompat_102.h

sed -i '30s/__padding/_padding/' $4/src/libraries/Native/Unix/System.Native/pal_networkstatistics.h
sed -i '123s/__padding/_padding/' $4/src/libraries/Native/Unix/System.Native/pal_networkstatistics.h

sed -i '60s/__cpu/_cpu/'  $5/usr/include/bits/cpu-set.h
sed -i '61s/__cpu/_cpu/'  $5/usr/include/bits/cpu-set.h
sed -i '62s/ (__cpu/ (_cpu/'  $5/usr/include/bits/cpu-set.h
sed -i '63s/__cpu/_cpu/'  $5/usr/include/bits/cpu-set.h
sed -i '74s/__cpu/_cpu/'  $5/usr/include/bits/cpu-set.h
sed -i '75s/__cpu/_cpu/'  $5/usr/include/bits/cpu-set.h
sed -i '76s/(__cpu/(_cpu/'  $5/usr/include/bits/cpu-set.h
sed -i '77s/__cpu/_cpu/'  $5/usr/include/bits/cpu-set.h

sed -i '445s/__Static/Static/' $5/usr/include/sys/cdefs.h
sed -i '446s/__error/error/'  $5/usr/include/sys/cdefs.h
