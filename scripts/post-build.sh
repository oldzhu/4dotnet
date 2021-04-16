#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

echo 'PermitRootLogin yes' >> $TARGET_DIR/etc/ssh/sshd_config
echo 'PermitEmptyPasswords yes' >> $TARGET_DIR/etc/ssh/sshd_config

cat >$TARGET_DIR/root/.gdbinit <<EOF 
set substitute-path $HOME/buildroot  /root/buildroot
define hook-stop
disas /mr \$pc,+0xa
end
EOF

cat >$TARGET_DIR/root/.lldbinit <<EOF
settings set target.source-map $HOME/buildroot /root/buildroot
plugin load /root/.dotnet/sos/libsosplugin.so
settings set stop-disassembly-display always
sethostruntime /dotnethello/dotnethello
EOF

cat >$TARGET_DIR/root/.profile <<EOF
#export DOTNET_ROOT=\$HOME/dotnet
#export PATH=\$PATH:\$HOME/dotnet
#if [ ! -d "\$HOME/.dotnet/tools" ]
#if [ ! -d "\$HOME/.dotnet" ]
#then
#       dotnet tool install -g dotnet-sos
#       export PATH=\$PATH:\$HOME/.dotnet/tools
#       dotnet-sos install
#       echo 'settings set target.source-map /__w/1/s/src/ /root/dotnet/src' >>  /root/.lldbinit
#else
#       export PATH=\$PATH:\$HOME/.dotnet/tools
#fi
#if ! mount | grep buildroot > /dev/null
if [ ! -d "/root/buildroot/output" ]
then
        mkdir -p /root/buildroot
	mount -t 9p -o trans=virtio,version=9p2000.L hostshare /root/buildroot
fi
EOF
