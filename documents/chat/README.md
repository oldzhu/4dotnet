# Chat Tracking System / 聊天记录跟踪系统

## Purpose / 目的
This directory stores all AI assistant chat interactions for the 4dotnet project, providing a complete, searchable record of all development discussions, decisions, and actions.

本目录存储 4dotnet 项目的所有 AI 助手聊天交互记录，提供完整的、可搜索的开发讨论、决策和操作记录。

## File Naming Convention / 文件命名规范
```
chat-[YYYYMMDD]-00[n].md
```
- `YYYYMMDD`: Date of the session / 会话日期
- `00[n]`: Sequential number for sessions on the same day / 同一天的会话序号

Examples / 示例:
- `chat-20260512-001.md` — First session on May 12, 2026 / 2026年5月12日第一次会话
- `chat-20260512-002.md` — Second session on May 12, 2026 / 2026年5月12日第二次会话

## Content Format / 内容格式
Each chat file should contain / 每个聊天文件应包含：
- Session info (date, session ID, agent name) / 会话信息
- User requests / 用户请求
- Agent responses and actions / 代理响应和操作
- Key decisions made / 做出的关键决策
- File changes / 文件变更
- Evidence references / 证据引用

## Usage / 使用方式
- Chat files are created automatically by the executor agent / 聊天文件由执行代理自动创建
- Never delete chat files — they are the project's institutional memory / 永远不要删除聊天文件
- Reference chat files in commit messages for traceability / 在提交消息中引用聊天文件以实现可追溯性
