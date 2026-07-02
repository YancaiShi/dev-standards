# dev-standards

前端开发规范，用于 Claude Code 每次会话自动加载。

## 包含内容

| 文件 | 作用 |
|------|------|
| `engineering.md` | 工程决策约束：决策流程、调研规则、代码标准、输出格式 |
| `code-style.md` | 代码风格：文件组织、Vue/TS 规范、命名规范 |
| `commit-style.md` | Git 提交规范：格式、type、scope、subject |
| `i18n.md` | 国际化规范：key 命名、传参方式、资源文件格式 |
| `figma.md` | Figma 还原规则：MCP 工具调用、验证流程 |
| `review.md` | Code Review 偏好：审查维度、优先级 |

## 安装

### 克隆并运行安装脚本

```bash
git clone https://github.com/YancaiShi/dev-standards.git ~/dev-standards
cd ~/dev-standards
```

**macOS / Linux:**
```bash
chmod +x install.sh
./install.sh
```

**Windows (PowerShell):**
```powershell
.\install.ps1
```

脚本会自动：
1. 创建符号链接 `~/.claude/standards` -> 仓库的 `standards/`
2. 提示你在 `~/.claude/CLAUDE.md` 中添加引用（如未配置）

### 手动安装

如果不使用脚本：

```bash
# 1. 链接 standards
ln -s ~/dev-standards/standards ~/.claude/standards

# 2. 在 ~/./.claude/CLAUDE.md 中添加引用
# 详见 install.sh 输出的模板
```

## 更新规范

```bash
cd ~/dev-standards
git pull
# 符号链接自动同步，重启 Claude Code 生效
```
