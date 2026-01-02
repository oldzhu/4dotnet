#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

# --- NEW: Strip massive LLVM/Clang libraries to fix filesystem generation ---
echo "Stripping massive libraries in $TARGET_DIR..."
# We use the cross-strip tool from the host directory to shrink files in the target directory
# This keeps the unstripped versions safe in the staging directory for debugging
if [ -f "$TARGET_DIR/usr/lib/libLLVM.so.22.0git" ]; then
    $HOST_DIR/bin/aarch64-linux-strip "$TARGET_DIR/usr/lib/libLLVM.so.22.0git"
fi

if [ -f "$TARGET_DIR/usr/lib/libclang-cpp.so.22.0git" ]; then
    $HOST_DIR/bin/aarch64-linux-strip "$TARGET_DIR/usr/lib/libclang-cpp.so.22.0git"
fi
# ----------------------------------------------------------------------------

echo 'PermitRootLogin yes' >> $TARGET_DIR/etc/ssh/sshd_config
echo 'PermitEmptyPasswords yes' >> $TARGET_DIR/etc/ssh/sshd_config

cat >$TARGET_DIR/root/.gdbinit <<EOF 
set substitute-path $HOME/buildroot  /root/buildroot
define hook-stop
disas /rs \$pc,+0xa
end
EOF

cat >$TARGET_DIR/root/.lldbinit <<EOF
settings set target.source-map $HOME/buildroot /root/buildroot
plugin load /root/.dotnet/sos/libsosplugin.so
settings set stop-disassembly-display always
sethostruntime /root/dotnethello
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
