# Code Style — 跨工具代码规范安装器

一键安装代码风格规则到所有 AI 编程工具。

## 使用

```bash
# 全局安装（Claude Code）
node bin/code-style.js --global

# 项目安装（Cursor / Copilot / Windsurf）
node bin/code-style.js --project

# 一键安装全部
node bin/code-style.js
```

发布到 npm 后可直接 `npx code-style`。

## 安装位置

| 工具 | 安装路径 |
|------|----------|
| Claude Code | `~/.claude/CLAUDE.md` |
| Cursor | `.cursorrules` |
| Copilot | `.github/copilot-instructions.md` |
| Windsurf | `.windsurfrules` |

## 规则文件

| 文件 | 内容 |
|------|------|
| `rules/engineering.md` | 工程决策约束、调研规则、输出格式 |
| `rules/code-style.md` | 间距系统、色彩规范、字体层级、深色主题 |
| `rules/commit-style.md` | Git 提交规范（Conventional Commits） |
| `rules/review.md` | Code Review 维度、UI 审查标准 |
| `rules/figma.md` | Figma 还原规则 |
| `rules/i18n.md` | 国际化规范 |

## 修改规则

直接编辑 `rules/` 下的文件，然后重新执行安装命令。
