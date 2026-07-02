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

> 详细规范文档位于 `~/.claude/standards/`，需要时读取。

## 工程决策约束
详见 `~/.claude/standards/engineering.md`

## 代码风格
详见 `~/.claude/standards/code-style.md`

## Git 提交规范
详见 `~/.claude/standards/commit-style.md`

## 国际化（i18n）
详见 `~/.claude/standards/i18n.md`

## Figma 还原规则
详见 `~/.claude/standards/figma.md`

## Code Review
详见 `~/.claude/standards/review.md`
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
应看到 6 个文件：`code-style.md` `commit-style.md` `engineering.md` `figma.md` `i18n.md` `review.md`

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
| `commit-style.md` | Git 提交规范 |
| `i18n.md` | 国际化规范 |
| `figma.md` | Figma 还原规则 |
| `review.md` | Code Review 偏好 |

## 更新

```bash
cd ~/dev-standards && git pull
```

链接自动同步，重启 Claude Code 生效。
