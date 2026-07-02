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

安装脚本会自动：
1. 克隆仓库到 `~/dev-standards`
2. 创建符号链接 `~/.claude/standards`
3. 配置 `~/.claude/CLAUDE.md`

完成后重启 Claude Code 即可生效。

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

符号链接自动同步，重启 Claude Code 生效。
