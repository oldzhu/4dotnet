# LLDB SOS 插件调试

> 本文档是 debug-lldb-sos.md 的中文翻译版。
> This document is the Chinese translation of debug-lldb-sos.md.

1. 使用大内存（=16G）选项和 tap 网络选项启动 arm64 虚拟机实例。
~~~
sudo $HOME/buildroot/output/host/bin/qemu-system-aarch64 -M virt -cpu cortex-a53 -nographic -smp 2 -m 16384 -kernel $HOME/buildroot/output/images/Image -append "rootwait root=/dev/vda console=ttyAMA0" -netdev tap,id=eth0,script=$HOME/4dotnet/scripts/qemu-ifup,downscript=no -device virtio-net-device,netdev=eth0 -drive file=$HOME/buildroot/output/images/rootfs.ext4,if=none,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -fsdev local,id=v_9p_dev,path=$HOME/buildroot,security_model=none -device virtio-9p-device,fsdev=v_9p_dev,mount_tag=hostshare
~~~

2. 登录并运行 lldb 启动 dotnethello。
3. 使用 clrstack 显示托管调用栈。
4. 使用 dumpobj、dumpheap、dumpdomain 等 SOS 命令检查 .NET 运行时状态。

SOS 加载消息确认插件已加载：
~~~
Using .NET Core runtime to host the managed SOS code
Host runtime path: /root/dotnethello
~~~

有关更多 SOS 命令，请参阅 [.NET SOS 调试文档](https://docs.microsoft.com/en-us/dotnet/core/diagnostics/sos-debugging-extension)。
