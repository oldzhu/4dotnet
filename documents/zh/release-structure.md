# 模块化 GitHub Release 结构

> 本文档是 release-structure.md 的中文翻译版。
> This document is the Chinese translation of release-structure.md.

## 概述
4dotnet 发布采用模块化设计——小型基础虚拟机配合可选附加包以满足不同的调试需求。

## 组件布局

### 基础虚拟机（必需）
包含：Linux 内核、根文件系统、LLDB、GDB、QEMU 启动脚本

### .NET 调试包（可选）
包含：SOS 插件、.NET 运行时库、dotnethello 演示应用、原生调试符号

### 内核调试包（可选）
包含：vmlinux 及内核调试符号

### 完整发布版（便捷）
所有内容合一的归档文件。

## 安装
```bash
# 最小化安装
tar -xvf 4dotnet-arm64-base-[date].tar.xz
cd 4dotnet-arm64
./start-qemu.sh

# 添加 .NET 调试
tar -xvf 4dotnet-arm64-debug-pack-[date].tar.xz -C 4dotnet-arm64/
```

## 发布脚本
```bash
bash scripts/release-modular.sh --dry-run arm64  # 预览
bash scripts/release-modular.sh arm64             # 创建模块化发布
bash scripts/release-modular.sh --full arm64      # 创建完整发布
```
