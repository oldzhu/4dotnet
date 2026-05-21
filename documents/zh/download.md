# 下载虚拟机

> 本文档是 download.md 的中文翻译版。
> This document is the Chinese translation of download.md.

下载 arm 虚拟机：
~~~
wget https://github.com/oldzhu/4dotnet/releases/download/v1.0.0/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.xz.00
wget https://github.com/oldzhu/4dotnet/releases/download/v1.0.0/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.xz.01
cat $HOME/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.xz.0* > $HOME/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.xz
tar -xvf $HOME/dotnet_arm_linux_vm_[dd-mm-yyyy].tar.xz -C $HOME
~~~

下载 arm64 虚拟机：
~~~
wget https://github.com/oldzhu/4dotnet/releases/download/v1.0.0/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.xz.00
wget https://github.com/oldzhu/4dotnet/releases/download/v1.0.0/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.xz.01
cat $HOME/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.xz.0* > $HOME/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.xz
tar -xvf $HOME/dotnet_arm64_linux_vm_[dd-mm-yyyy].tar.xz -C $HOME
~~~

**请将 [dd-mm-yyyy] 替换为最新 GitHub Release 中的实际日期。**
