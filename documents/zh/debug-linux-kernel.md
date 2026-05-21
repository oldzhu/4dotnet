# Linux 内核调试

> 本文档是 debug-linux-kernel.md 的中文翻译版。
> This document is the Chinese translation of debug-linux-kernel.md.

1. 使用额外的 "-s -S" 参数启动 arm/arm64 虚拟机实例并等待调试。

对于 arm：
~~~
$HOME/4dotnet/scripts/arm/start-qemu.sh -s
~~~
对于 arm64：
~~~
$HOME/4dotnet/scripts/arm64/start-qemu.sh -s
~~~

2. 运行 arm-linux-gdb 或 aarch64-linux-gdb 加载构建的 Linux 内核 vmlinux。

对于 arm：
~~~
$HOME/buildroot/output/host/bin/arm-linux-gdb $HOME/buildroot/output/build/linux-5.12.4/vmlinux
~~~
对于 arm64：
~~~
$HOME/buildroot/output/host/bin/aarch64-linux-gdb $HOME/buildroot/output/build/linux-5.12.4/vmlinux
~~~

3. 连接到远程目标并开始内核调试。
~~~
(gdb) target remote :1234
Remote debugging using :1234
cpu_v7_do_idle () at arch/arm/mm/proc-v7.S:78
78              ret     lr
(gdb) bt
...
(gdb) info var jiffies_64
...
(gdb) watch jiffies_64
(gdb) c
Continuing.
~~~

4. 使用标准 GDB 命令设置断点、检查变量、单步执行内核代码。
