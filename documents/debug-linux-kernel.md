# linux kernel debugging
![host qemu debug demo ](armkernel_demo_c.svg)
1. Start arm/arm64 vm instance with additional "-s -S" parameters and wait for debugging.  
for arm
~~~
$HOME/4dotnet/scripts/arm/start-qemu.sh -s -S
~~~
for arm64
~~~
$HOME/4dotnet/scripts/arm64/start-qemu.sh -s -S
~~~
2. Run arm-linux-gdb or aarch64-linux-gdb to load the built linux kernel vmlinux.  
for arm
~~~
$HOME/buildroot/output/host/bin/arm-linux-gdb  $HOME/buildroot/output/build/linux-5.12.4/vmlinux
~~~
for arm64
~~~
$HOME/buildroot/output/host/bin/aarch64-linux-gdb  $HOME/buildroot/output/build/linux-5.12.4/vmlinux
~~~  
3. Connect to the remote target and start the kernel debugging as the below
~~~
(gdb) target remote :1234
Remote debugging using :1234
0x40000000 in ?? ()
(gdb)
~~~
