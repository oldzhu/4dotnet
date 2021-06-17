# host qemu debugging
<!--img src="armhostqemu_demo_120.gif" width="1500"/-->

![host qemu debug demo ](armhostqemu_demo.svg)
1. Install host gdb in WSL2 if it is not installed.
~~~
sudo apt install gdb
~~~
2. Start the qemu for arm or arm64.  
for arm  
~~~
$HOME/4dotnet/scripts/arm/start-qemu.sh
~~~  
for arm64  
~~~
$HOME/4dotnet/scripts/arm64/start-qemu.sh
~~~  
3. Open another WSL2 session and using gdb to attach to the started qemu.
for arm  
~~~
gdb $HOME/buildroot/output/host/bin/qemu-system-arm <pid of qemu>
~~~
for arm64  
~~~
gdb $HOME/buildroot/output/host/bin/qemu-system-aarch64 <pid of qemu>
~~~
4. If couldn't list the source of the qemu in debugging, run the dir command to add source search path.  
~~~
dir ~/buildroot/output/build/host-qemu-5.2.0/build/
~~~  