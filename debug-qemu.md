# host qemu debugging

1. Install host gdb in WSL2 if it is not installed.
~~~
sudo apt install gdb
~~~
2. Rebuild the host qemu with the debug enabled.
~~~
~/4dotnet/scripts/build_debug_hostqemu.sh
~~~
3. Start the qemu for arm or arm64.  

for arm
~~~
~/4dotnet/scripts/arm/start-qemu.sh
~~~  
for arm64
~~~
/4dotnet/scripts/arm64/start-qemu.sh
~~~

4. Open another WSL2 session and using gdb to attach to the started qemu.

for arm
~~~
gdb $HOME/buildroot/output/host/bin/qemu-system-arm <pid of qemu>
~~~
for arm64
~~~
gdb $HOME/buildroot/output/host/bin/qemu-system-aarch64 <pid of qemu>
~~~