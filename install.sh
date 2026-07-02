#!/bin/bash
set -e

STANDARDS_DIR="$HOME/.claude/standards"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "📦 安装 dev-standards..."

# 1. 确保 ~/.claude 目录存在
mkdir -p "$HOME/.claude"

# 2. 链接 standards 目录
if [ -L "$STANDARDS_DIR" ]; then
  echo "✔ standards 链接已存在，跳过"
elif [ -d "$STANDARDS_DIR" ]; then
  echo "⚠️  $STANDARDS_DIR 已存在（非链接），备份为 .bak"
  mv "$STANDARDS_DIR" "$STANDARDS_DIR.bak"
  ln -s "$SCRIPT_DIR/standards" "$STANDARDS_DIR"
  echo "✔ 已创建符号链接（原目录已备份）"
else
  ln -s "$SCRIPT_DIR/standards" "$STANDARDS_DIR"
  echo "✔ 已创建符号链接: $STANDARDS_DIR"
fi

# 3. 自动配置 CLAUDE.md
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
  echo "✔ 已追加规范引用到 CLAUDE.md"
fi

echo ""
echo "✅ 安装完成！重启 Claude Code 即可生效。"
