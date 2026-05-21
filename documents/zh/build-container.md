# 使用容器构建（Docker/Podman）

> 本文档是 build-container.md 的中文翻译版。
> This document is the Chinese translation of build-container.md.

本仓库是一个 Buildroot 外部树。容器工作流可以避免在宿主上安装大多数构建依赖。

## 前置条件（宿主）

- 安装了 **Docker** 或 **Podman**
- 足够的磁盘空间（Buildroot 下载 + 输出可能达数 GB）

## 快速开始（arm64）

从 `4dotnet/` 文件夹：

1. 构建容器镜像（一次性）：

~~~
./tools/build-env/run.sh --build
~~~

2. 为 arm64 配置 Buildroot（使用现有的 defconfig）：

~~~
./tools/build-env/run.sh -- make distclean
./tools/build-env/run.sh -- make BR2_EXTERNAL=/work/4dotnet defconfig \
  BR2_DEFCONFIG=/work/4dotnet/savedconfigs/arm64/br2.defconfig
~~~

3. 构建：

~~~
./tools/build-env/run.sh -- make
~~~

## 快速开始（arm）

~~~
./tools/build-env/run.sh -- make distclean
./tools/build-env/run.sh -- make BR2_EXTERNAL=/work/4dotnet defconfig \
  BR2_DEFCONFIG=/work/4dotnet/savedconfigs/arm/br2.defconfig
./tools/build-env/run.sh -- make
~~~

## 注意事项

- 包装脚本挂载：
  - `buildroot/` 到 `/work/buildroot`
  - `4dotnet/` 到 `/work/4dotnet`
- 在容器内设置 `HOME=/work`，使引用 `$HOME/buildroot` 的脚本继续工作。
- 如果你的 `buildroot/` 文件夹不在 `4dotnet/` 的同级目录，运行：

~~~
BUILDROOT_DIR=/abs/path/to/buildroot ./tools/build-env/run.sh -- make
~~~

## 如果镜像构建失败（网络/代理）

某些网络会阻止 Docker 构建流量或需要代理。

- 使用宿主网络构建镜像：

~~~
BUILD_NETWORK=host ./tools/build-env/run.sh --build
~~~

- 使用不同的 Ubuntu 镜像源（示例镜像；选择离你近的）：

~~~
APT_MIRROR=http://<your-mirror>/ubuntu/ APT_SECURITY_MIRROR=http://<your-mirror>/ubuntu/ \
  ./tools/build-env/run.sh --build
~~~

- 如果你在代理后面，在宿主上导出 `http_proxy` / `https_proxy` / `no_proxy`；
  构建包装器会将它们作为构建参数传递。
