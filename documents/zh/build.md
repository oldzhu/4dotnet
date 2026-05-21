# 构建 arm/arm64 虚拟机

> 本文档是 build.md 的中文翻译版。
> This document is the Chinese translation of build.md.

本文档包含构建用于 .NET Core 调试的 arm/arm64 虚拟机的步骤。

1. [在 Windows 10 上设置 WSL2 + Ubuntu 发行版](https://docs.microsoft.com/zh-cn/windows/wsl/install-win10)
2. 在 WSL2 + Ubuntu 上安装以下必备软件：

    * make
    * unzip
    * gcc
    * g++
    * libncurses-dev
    * liblttng-ust-dev
~~~
sudo apt-get update
sudo apt install make unzip gcc g++ libncurses-dev liblttng-ust-dev
~~~

## 可选：在容器内构建（Linux 上推荐）

如果你安装了 Docker 或 Podman，可以在不安装大多数宿主依赖的情况下构建：

- [使用 Docker/Podman 构建](build-container.md)

3. 将 buildroot 和 4dotnet 克隆到你的 home 文件夹。
~~~
    git clone https://github.com/oldzhu/buildroot.git
    git clone https://github.com/oldzhu/4dotnet.git
~~~
4. 运行以下命令更新默认配置以构建虚拟机。

**对于 arm：**
~~~
    cd buildroot
    make distclean
    make BR2_EXTERNAL=~/4dotnet defconfig BR2_DEFCONFIG=~/4dotnet/savedconfigs/arm/br2.defconfig
~~~
**对于 arm64：**
~~~
    cd buildroot
    make distclean
    make BR2_EXTERNAL=~/4dotnet defconfig BR2_DEFCONFIG=~/4dotnet/savedconfigs/arm64/br2.defconfig
~~~

5. 运行以下 make 命令开始构建。根据系统性能，可能需要数小时甚至数天。
~~~
    export PATH=`echo $PATH|tr -d ' '`
    make
~~~
6. 完成后，你可以前往 [使用 arm 虚拟机调试](debug-arm-netcoreapp.md) 或 [使用 arm64 虚拟机调试](debug-arm64-netcoreapp.md) 享受 .NET Core 应用调试。
