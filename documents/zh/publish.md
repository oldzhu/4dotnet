# 发布 .NET Core 应用到 arm/arm64 虚拟机

> 本文档是 publish.md 的中文翻译版。
> This document is the Chinese translation of publish.md.

如何将 .NET Core 应用发布到 arm/arm64 虚拟机。

如果你按照 [从头构建 arm/arm64 虚拟机](build.md) 的步骤构建了虚拟机，可以使用 vi 或 vscode 修改 dotnethello 源码（位于 `~/buildroot/output/build/dotnethello-1.0/Program.cs`）来添加自定义代码，然后运行以下命令重建 dotnethello 和新的系统镜像以进行调试。

~~~
        export PATH=`echo $PATH|tr -d ' '`
        make dotnethello-rebuild all
~~~

如果你直接下载并使用发布版的 arm/arm64 虚拟机，请参考以下步骤将 .NET Core 应用与发布的 .NET Core 运行时一起发布到虚拟机镜像中进行调试：
这些步骤类似于 [将自包含 .NET 应用部署到 Raspberry Pi](https://docs.microsoft.com/zh-cn/dotnet/iot/deployment#deploying-a-self-contained-app)。

1. 如果尚未安装，请在 WSL2 中安装要测试的 .NET Core。
~~~
curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin
~~~
***如果需要特定版本，请在末尾添加 --version <VERSION>，其中 <VERSION> 是特定的构建版本。***
~~~
echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
echo 'export PATH=$PATH:$HOME/.dotnet' >> ~/.bashrc
source ~/.bashrc
dotnet --info
~~~
2. 运行以下命令创建新的控制台程序
~~
dotnet new console -n myhello
~~
3. 使用 vi 或 VScode 修改 myhello 目录下的 Program.cs，使其在退出前等待输入。
~~~
using System;

namespace myhello
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            Console.ReadLine();
        }
    }
}
~~~
4. 在 myhello 文件夹中运行以下命令，为 linux arm 或 arm64 发布自包含应用。

对于 linux arm：
~~~
cd myhello
dotnet publish -r linux-arm -c Release
~~~
对于 linux-arm64：
~~~
cd myhello
dotnet publish -r linux-arm64 -c Release
~~~
或发布 ReadyToRun 应用程序：
~~~
dotnet publish -r linux-arm -c Release -p:PublishReadyToRun=true
dotnet publish -r linux-arm64 -c Release -p:PublishReadyToRun=true
~~~

5. 运行位于 arm/arm64 虚拟机同一文件夹中的 pub2img.sh，将自包含应用发布到 arm/arm64 虚拟机镜像。
~~~
[用法] pub2img.sh [本地发布路径] [目标文件夹名] [rootfs 路径]
~~~
arm 示例：
~~~
~/4dotnet/scripts/pub2img.sh /home/oldzhu/myhello/bin/Release/netcoreapp3.1/linux-arm/publish/ myhello /home/oldzhu/vm_releases/arm/buildroot/output/images
~~~
arm64 示例：
~~~
~/4dotnet/scripts/pub2img.sh /home/oldzhu/myhello/bin/Release/netcoreapp3.1/linux-arm64/publish/ myhello /home/oldzhu/vm_releases/arm64/buildroot/output/images
~~~
