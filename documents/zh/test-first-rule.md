# 4dotnet 测试优先规则

> This document is the Chinese translation of test-first-rule.md.

## 原则
**每个交付物必须在实施开始之前定义测试。**

测试 = 具有 PASS/FAIL/SKIP 结果的自动化验证，证据保存。

## 测试类别
| 类别 | 运行时机 | 示例 |
|------|---------|------|
| 构建测试 | 包变更后 | defconfig 成功，make 退出 0，二进制文件生成 |
| 启动测试 | 构建成功后 | VM 启动，内核加载，出现登录提示 |
| 调试测试 | 启动验证后 | LLDB 启动，SOS 加载，断点工作 |
| 容器测试 | 容器工作流变更后 | 镜像构建，缓存持久化，defconfig 工作 |

## 全调试场景测试
1. .NET 应用调试（LLDB + SOS）
2. 内核调试（GDB）
3. 宿主 QEMU 调试（GDB）
4. 容器构建
