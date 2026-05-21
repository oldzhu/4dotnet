# 宿主 QEMU 调试

> 本文档是 debug-qemu.md 的中文翻译版。
> This document is the Chinese translation of debug-qemu.md.

1. 如果尚未安装，请在 WSL2 中安装宿主 gdb。
~~~
sudo apt install gdb
~~~
2. 启动 arm 或 arm64 的 QEMU。

对于 arm：
~~~
$HOME/4dotnet/scripts/arm/start-qemu.sh
~~~
对于 arm64：
~~~
$HOME/4dotnet/scripts/arm64/start-qemu.sh
~~~

3. 打开另一个 WSL2 会话，使用 gdb 附加到启动的 QEMU。

对于 arm：
~~~
gdb $HOME/buildroot/output/host/bin/qemu-system-arm <qemu的pid>
~~~
对于 arm64：
~~~
gdb $HOME/buildroot/output/host/bin/qemu-system-aarch64 <qemu的pid>
~~~

4. 如果在调试中无法列出 QEMU 的源代码，运行 dir 命令添加源代码搜索路径。
~~~
dir ~/buildroot/output/build/host-qemu-5.2.0/build/
~~~
