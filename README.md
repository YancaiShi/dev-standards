# dev-standards

前端开发规范。一次安装，同时给 **Claude Code** 与 **Cursor** 使用：

| 工具 | 生效方式 |
|------|----------|
| Claude Code | `~/.claude/CLAUDE.md` 通过 `@standards/*.md` 导入 |
| Cursor | `~/.cursor/rules/dev-standards-*.mdc`，`alwaysApply: true` 跨项目稳定注入 |

规范正文以仓库 `standards/` 为唯一源；安装 / 更新时自动生成 Cursor Rules，避免两套文件漂移。

## 一键安装

**macOS / Linux:**
```bash
bash <(curl -sSL https://raw.githubusercontent.com/YancaiShi/dev-standards/main/install.sh)
```

**Windows PowerShell:**
```powershell
irm https://raw.githubusercontent.com/YancaiShi/dev-standards/main/install.ps1 | iex
```

## 安装脚本做了什么

### 1. 克隆仓库
```bash
git clone https://github.com/YancaiShi/dev-standards.git ~/dev-standards
```
- 将仓库克隆到 `~/dev-standards` 目录
- 如果已存在，则执行 `git pull` 拉取最新

### 2. 创建链接（Claude Code）
```bash
# macOS/Linux
ln -s ~/dev-standards/standards ~/.claude/standards

# Windows（使用 junction，不需要管理员权限）
mklink /J %USERPROFILE%\.claude\standards %USERPROFILE%\dev-standards\standards
```
- 在 `~/.claude/` 下创建链接指向仓库的 `standards/` 目录
- 如果 `~/.claude/standards` 已存在，会备份为 `standards.bak`

### 3. 配置 CLAUDE.md
在 `~/.claude/CLAUDE.md` 中追加规范 `@` 引用（若尚未配置）。

### 4. 同步 Cursor User Rules
将 `standards/*.md` 写成带 frontmatter 的规则文件：

```
~/.cursor/rules/dev-standards-engineering.mdc
~/.cursor/rules/dev-standards-code-style.mdc
...（共 9 个，前缀均为 dev-standards-）
```

每条规则含：
```yaml
---
description: …
alwaysApply: true
---
```

`alwaysApply: true` 保证每个 Cursor Agent 会话都会加载，不依赖「智能选用」。你已有的其他 User Rules（如 `global-*.mdc`）不受影响。

### 5. 完成
重启 Claude Code / Cursor 后生效。

## 验证安装

### Claude Code
```bash
# macOS/Linux
ls -la ~/.claude/standards

# Windows PowerShell
dir ~/.claude/standards
```
应看到 9 个 `*.md` 规范文件；`CLAUDE.md` 中含「个人前端开发规范」。

### Cursor
```bash
# macOS/Linux
ls ~/.cursor/rules/dev-standards-*.mdc

# Windows PowerShell
dir ~/.cursor/rules/dev-standards-*.mdc
```
应列出 9 个文件。也可在 **Cursor Settings → Rules, Commands → User Rules** 中确认均为 Always Apply。

### 会话内自检
问 Agent：
```
你的输出格式是什么？
```
若回答包含 `结论 → 原因 → 成本/Trade-off → 行动`（或等价结构化格式），说明规范已加载。

## 文件变更

| 操作 | 路径 | 说明 |
|------|------|------|
| 新增 | `~/dev-standards/` | 仓库目录 |
| 新增 | `~/.claude/standards` | 链接 → `~/dev-standards/standards` |
| 修改 | `~/.claude/CLAUDE.md` | 追加规范引用（如未配置） |
| 新增 | `~/.cursor/rules/dev-standards-*.mdc` | 由 `standards/` 生成的 Cursor Rules |

## 一键卸载

**macOS / Linux:**
```bash
bash <(curl -sSL https://raw.githubusercontent.com/YancaiShi/dev-standards/main/uninstall.sh)
```

**Windows PowerShell:**
```powershell
irm https://raw.githubusercontent.com/YancaiShi/dev-standards/main/uninstall.ps1 | iex
```

卸载脚本会：
1. 删除 `~/.claude/standards` 链接
2. 恢复备份（如有）
3. 从 `~/.claude/CLAUDE.md` 移除规范引用
4. 删除 `~/.cursor/rules/dev-standards-*.mdc`（不动你其他 User Rules）
5. 询问是否删除仓库 `~/dev-standards`

## 包含规范

| 文件 | Cursor Rule | 作用 |
|------|-------------|------|
| `engineering.md` | `dev-standards-engineering.mdc` | 工程决策约束 |
| `code-style.md` | `dev-standards-code-style.mdc` | 代码风格 |
| `error-handling.md` | `dev-standards-error-handling.mdc` | 错误处理 |
| `testing.md` | `dev-standards-testing.mdc` | 测试规范 |
| `component-design.md` | `dev-standards-component-design.mdc` | 组件设计 |
| `commit-style.md` | `dev-standards-commit-style.mdc` | Git 提交规范 |
| `i18n.md` | `dev-standards-i18n.mdc` | 国际化规范 |
| `figma.md` | `dev-standards-figma.mdc` | Figma 还原规则 |
| `review.md` | `dev-standards-review.mdc` | Code Review 偏好 |

## 一键更新

远程有更新时，执行以下命令即可同步到本机（无需卸载重装）：

**macOS / Linux:**
```bash
bash <(curl -sSL https://raw.githubusercontent.com/YancaiShi/dev-standards/main/update.sh)
```

**Windows PowerShell:**
```powershell
irm https://raw.githubusercontent.com/YancaiShi/dev-standards/main/update.ps1 | iex
```

更新脚本会：
1. 强制对齐远程 `main`（规范以远程为唯一源，本地仓库改动会被覆盖——自定义请提 PR 或 fork）
2. 经链接同步到 `~/.claude/standards`
3. 重新生成 `~/.cursor/rules/dev-standards-*.mdc`

重启 Claude Code / Cursor 后生效。

### 仅从当前仓库同步 Cursor（开发 / 本机改规范时）

```bash
# macOS/Linux
bash ./scripts/sync-cursor-rules.sh

# Windows PowerShell
.\scripts\sync-cursor-rules.ps1
```
