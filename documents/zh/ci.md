# CI 流水线

> 本文档是 ci.md 的中文翻译版（待英文原文创建后将同步更新）。
> This document is the Chinese translation of ci.md.

## 概述
4dotnet 使用 GitHub Actions 进行持续集成。流水线在每次推送和 PR 时自动运行。

## 流水线作业

| 作业 | 触发条件 | 描述 |
|------|---------|------|
| `container-image` | push, PR, 每周一 | 验证容器镜像构建 |
| `defconfig-arm64` | push, PR, 每周一 | 验证 arm64 defconfig |
| `defconfig-arm` | push, PR, 每周一 | 验证 arm defconfig |
| `shellcheck` | push, PR, 每周一 | Shell 脚本静态分析 |

## CI 状态徽章
[![CI](https://github.com/oldzhu/4dotnet/actions/workflows/ci.yml/badge.svg)](https://github.com/oldzhu/4dotnet/actions/workflows/ci.yml)

## 本地运行测试
```bash
bash scripts/test/run-tests.sh
```
