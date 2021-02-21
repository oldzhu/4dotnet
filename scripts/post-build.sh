#!/bin/sh
echo 'PermitRootLogin yes' >> $TARGET_DIR/etc/ssh/sshd_config
echo 'PermitEmptyPasswords yes' >> $TARGET_DIR/etc/ssh/sshd_config

cat >$TARGET_DIR/root/.gdbinit <<EOF 
set substitute-path $HOME/buildroot  /root/buildroot
define hook-stop
disas /mr $pc,+0xa
end
EOF

cat >$TARGET_DIR/root/.lldbinit <<EOF
settings set target.source-map $HOME/buildroot /root/buildroot
plugin load /root/.dotnet/sos/libsosplugin.so
settings set stop-disassembly-display always
EOF
