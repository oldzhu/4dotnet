# 4dotnet

> 本文档是 README.md 的中文翻译版。
> This document is the Chinese translation of README.md.

本仓库用于构建 Linux arm/arm64 虚拟机（在 WSL2 中运行），让你无需购买真实硬件即可在 arm/arm64 系统上体验 .NET Core 调试。

项目的两个目标：
1. 降低在 Linux arm/arm64 上体验 .NET Core 应用的门槛。
2. 在开源世界中提供"全栈"调试体验（从 QEMU、Linux 内核、Clang/LLVM、LLDB/GDB、SOS 到 .NET Core 应用）。

目标 arm/arm64 虚拟机包含：

- Linux 系统 (6.0.x) — 由 Buildroot gcc 工具链构建
- GDB (12) — 由 Buildroot gcc 工具链构建
- LLDB (15.0.x) — 由 Buildroot gcc 工具链构建
- SOS LLDB 插件 (main 分支) — 由 clang/llvm（原生部分）+ MS 编译器（托管部分）构建
- 自包含的 .NET Core 应用程序及 .NET Core 运行时 — 由宿主 clang/llvm 和 MS 编译器构建

同时为 x86-64 宿主构建了以下工具：

- QEMU (7.1.0) — 用于托管构建的 arm/arm64 虚拟机
- 最新的 clang/llvm (main 分支) — 用于交叉编译 SOS LLDB 插件和 .NET Core 运行时

有两种方式获取虚拟机包：

1. [从头构建 arm/arm64 虚拟机](build.md) — 可能需要数小时
2. [下载已发布的虚拟机并直接使用](download.md)

也可以在容器内构建：

3. [使用 Docker/Podman 构建](build-container.md)

构建或下载虚拟机包后，你可以：

1. [在 arm64 虚拟机上调试 .NET Core 应用](debug-arm64-netcoreapp.md)
2. [在 arm 虚拟机上调试 .NET Core 应用](debug-arm-netcoreapp.md)
3. [发布 .NET Core 应用到虚拟机](publish.md)
4. [宿主 QEMU 调试](debug-qemu.md)
5. [Linux 内核调试](debug-linux-kernel.md)
6. [LLDB SOS 插件调试](debug-lldb-sos.md)

---

## 文档 / Documentation

- **中文文档**: [documents/zh/](zh/)
- **English Docs**: [documents/](../)
- **开发跟踪**: [documents/tracking/next-steps.md](../tracking/next-steps.md)
