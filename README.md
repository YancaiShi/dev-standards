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

## 使用方法

### 1. 克隆仓库

```bash
git clone https://github.com/YancaiShi/dev-standards.git ~/dev-standards
```

### 2. 链接到 Claude Code 配置目录

```bash
# macOS / Linux
ln -s ~/dev-standards/standards ~/.claude/standards

# Windows (管理员 PowerShell)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\standards" -Target "$env:USERPROFILE\dev-standards\standards"
```

### 3. 在全局 CLAUDE.md 中引用

在 `~/.claude/CLAUDE.md` 中添加：

```markdown
# 个人前端开发规范

> 详细规范文档位于 `~/.claude/standards/`，需要时读取。

## 工程决策约束
（从 engineering.md 复制要点，或写"详见 engineering.md"）

## 代码风格
（从 code-style.md 复制要点，或写"详见 code-style.md"）

...其他规范同理
```

## 更新规范

```bash
cd ~/dev-standards
git pull
# 链接会自动同步，无需额外操作
```
