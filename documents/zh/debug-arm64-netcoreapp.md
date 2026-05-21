# 在 arm64 虚拟机中调试 .NET Core 应用

> 本文档是 debug-arm64-netcoreapp.md 的中文翻译版。
> This document is the Chinese translation of debug-arm64-netcoreapp.md.

使用构建的 arm64 虚拟机调试 .NET Core 应用的步骤。

1. 使用以下命令启动虚拟机。
~~~
$HOME/4dotnet/scripts/arm64/start-qemu.sh
~~~
2. 以 root 身份登录，无需密码。
~~~
Welcome to Buildroot
buildroot login: root
qemu-system-aarch64: warning: 9p: degraded performance: a reasonable high msize should be chosen on client/guest side (chosen msize is <= 8192). See https://wiki.qemu.org/Documentation/9psetup#msize for details.
#
~~~
3. 运行 lldb 调试演示 dotnethello 应用程序。
~~~
# lldb ./dotnethello/dotnethello
(lldb) target create "./dotnethello/dotnethello"
Current executable set to '/root/dotnethello/dotnethello' (aarch64).
(lldb) r
Process 128 launched: '/root/dotnethello/dotnethello' (aarch64)
Process 128 stopped and restarted: thread 1 received signal: SIGCHLD
Process 128 stopped and restarted: thread 1 received signal: SIGCHLD
Hello World from .NET 6.0.0-dev
The location is /root/dotnethello/System.Private.CoreLib.dll
press anykey to exit...
~~~
4. 按 CTRL+c 中断到 lldb。
5. 显示当前线程的原生调用栈：`(lldb) bt`
6. 显示托管调用栈：`(lldb) clrstack`
7. 显示局部变量：`(lldb) clrstack -l`
8. 显示对象：`(lldb) dumpobj <address>`

有关更详细的 LLDB + SOS 调试体验，请参阅 [LLDB SOS 插件调试](debug-lldb-sos.md)。
