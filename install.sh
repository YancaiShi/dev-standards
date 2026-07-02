#!/bin/bash
set -e

REPO_URL="https://github.com/YancaiShi/dev-standards.git"
INSTALL_DIR="$HOME/dev-standards"
STANDARDS_DIR="$HOME/.claude/standards"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"

echo "📦 安装 dev-standards..."

# 1. 克隆或更新仓库
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "✔ 仓库已存在，拉取最新..."
  cd "$INSTALL_DIR" && git pull -q
else
  git clone -q "$REPO_URL" "$INSTALL_DIR"
  echo "✔ 已克隆仓库到 $INSTALL_DIR"
fi

# 2. 创建符号链接
mkdir -p "$HOME/.claude"
if [ -L "$STANDARDS_DIR" ]; then
  echo "✔ 符号链接已存在，跳过"
elif [ -d "$STANDARDS_DIR" ]; then
  mv "$STANDARDS_DIR" "$STANDARDS_DIR.bak"
  ln -s "$INSTALL_DIR/standards" "$STANDARDS_DIR"
  echo "✔ 已创建符号链接（原目录已备份）"
else
  ln -s "$INSTALL_DIR/standards" "$STANDARDS_DIR"
  echo "✔ 已创建符号链接"
fi

# 3. 配置 CLAUDE.md
MARKER="# 个人前端开发规范"
if [ -f "$CLAUDE_MD" ] && grep -q "$MARKER" "$CLAUDE_MD"; then
  echo "✔ CLAUDE.md 已配置，跳过"
else
  cat >> "$CLAUDE_MD" << 'EOF'

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
EOF
  echo "✔ 已配置 CLAUDE.md"
fi

echo ""
echo "✅ 安装完成！重启 Claude Code 即可生效。"
