# dev-standards

前端开发规范，用于 Claude Code 每次会话自动加载。

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

执行上述命令后，脚本会依次执行以下操作：

### 1. 克隆仓库
```bash
git clone https://github.com/YancaiShi/dev-standards.git ~/dev-standards
```
- 将仓库克隆到 `~/dev-standards` 目录
- 如果已存在，则执行 `git pull` 拉取最新

### 2. 创建链接
```bash
# macOS/Linux
ln -s ~/dev-standards/standards ~/.claude/standards

# Windows（使用 junction，不需要管理员权限）
mklink /J %USERPROFILE%\.claude\standards %USERPROFILE%\dev-standards\standards
```
- 在 `~/.claude/` 下创建链接指向仓库的 `standards/` 目录
- 如果 `~/.claude/standards` 已存在，会备份为 `standards.bak`

### 3. 配置 CLAUDE.md
在 `~/.claude/CLAUDE.md` 中追加：
```markdown
# 个人前端开发规范

前端开发规范，通过 Claude Code import(`@`)自动加载到上下文，会话启动即生效，无需手动读取。

@standards/engineering.md
@standards/code-style.md
@standards/error-handling.md
@standards/testing.md
@standards/component-design.md
@standards/commit-style.md
@standards/review.md
@standards/figma.md
@standards/i18n.md
```
- 如果 `CLAUDE.md` 已包含 `# 个人前端开发规范`，则跳过

### 4. 完成
重启 Claude Code 后，规范自动生效。

## 验证安装

### 检查链接
```bash
# macOS/Linux
ls -la ~/.claude/standards

# Windows PowerShell
dir ~/.claude/standards
```
应显示指向 `~/dev-standards/standards` 的链接/目录

### 检查规范文件
```bash
ls ~/.claude/standards/
```
应看到 9 个文件：`code-style.md` `commit-style.md` `engineering.md` `error-handling.md` `figma.md` `i18n.md` `review.md` `testing.md` `component-design.md`

### 检查 CLAUDE.md
```bash
grep "个人前端开发规范" ~/.claude/CLAUDE.md
```
应有输出

### 重启 Claude Code 后测试
在新会话中问 Claude：
```
你的输出格式是什么？
```
如果回答包含 `结论 → 原因 → 成本/Trade-off → 行动`，说明规范已生效。

## 文件变更

| 操作 | 路径 | 说明 |
|------|------|------|
| 新增 | `~/dev-standards/` | 仓库目录 |
| 新增 | `~/.claude/standards` | 链接 → `~/dev-standards/standards` |
| 修改 | `~/.claude/CLAUDE.md` | 追加规范引用（如未配置） |

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
4. 询问是否删除仓库 `~/dev-standards`

## 包含规范

| 文件 | 作用 |
|------|------|
| `engineering.md` | 工程决策约束 |
| `code-style.md` | 代码风格 |
| `error-handling.md` | 错误处理 |
| `testing.md` | 测试规范 |
| `component-design.md` | 组件设计 |
| `commit-style.md` | Git 提交规范 |
| `i18n.md` | 国际化规范 |
| `figma.md` | Figma 还原规则 |
| `review.md` | Code Review 偏好 |

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

更新脚本会拉取远程最新并经链接同步到 `~/.claude/standards`。规范以远程为唯一源，本地仓库的改动会被覆盖——自定义请提 PR 或 fork。

重启 Claude Code 后生效。
