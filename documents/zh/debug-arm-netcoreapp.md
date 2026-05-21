# 在 arm 虚拟机中调试 .NET Core 应用

> 本文档是 debug-arm-netcoreapp.md 的中文翻译版。
> This document is the Chinese translation of debug-arm-netcoreapp.md.

使用 arm 虚拟机调试 .NET Core 应用的步骤。

1. 使用以下命令启动虚拟机。
~~~
$HOME/4dotnet/scripts/arm/start-qemu.sh
~~~

2. 以 root 身份登录，无需密码。
~~~
Welcome to Buildroot
buildroot login: root
qemu-system-arm: warning: 9p: degraded performance...
#
~~~

**如果使用发布版 arm 虚拟机，你不会遇到非法指令错误，因为发布版 arm 虚拟机已经打过补丁。**
**因此，如果使用发布版 arm 虚拟机，请跳过步骤 3 到 9，从步骤 11 开始享受调试。**

3. 运行 lldb 调试演示 dotnethello 应用程序。
4. 如果遇到非法指令（SIGILL），请参阅 [非法指令变通方案](workaround4illegalinstruction.md) 和 [POC 补丁](pocpatch4illegalinstruction.md)。

有关调试命令，请参阅 [arm64 调试指南](debug-arm64-netcoreapp.md)（命令语法相同）。
