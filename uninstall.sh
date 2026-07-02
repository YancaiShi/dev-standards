#!/bin/bash
set -e

STANDARDS_DIR="$HOME/.claude/standards"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"

echo "🗑️  卸载 dev-standards..."

# 1. 删除链接/目录
if [ -L "$STANDARDS_DIR" ]; then
  rm "$STANDARDS_DIR"
  echo "✔ 已删除链接"
elif [ -d "$STANDARDS_DIR" ]; then
  rm -rf "$STANDARDS_DIR"
  echo "✔ 已删除 standards 目录"
fi

# 2. 恢复备份
if [ -d "$STANDARDS_DIR.bak" ]; then
  mv "$STANDARDS_DIR.bak" "$STANDARDS_DIR"
  echo "✔ 已恢复备份"
fi

# 3. 从 CLAUDE.md 移除我们添加的内容（精确匹配）
MARKER='# 个人前端开发规范'
REFERENCE='
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
详见 `~/.claude/standards/review.md`'

if [ -f "$CLAUDE_MD" ]; then
  # 只有当 CLAUDE.md 中的内容是我们添加的精确内容时才移除
  if grep -q "$MARKER" "$CLAUDE_MD"; then
    # 创建临时文件，跳过我们添加的块
    awk -v marker="$MARKER" '
      /^# 个人前端开发规范/ { skip=1; next }
      skip && /^## / { skip=0 }
      skip { next }
      !skip { print }
    ' "$CLAUDE_MD" > "$CLAUDE_MD.tmp"
    mv "$CLAUDE_MD.tmp" "$CLAUDE_MD"
    echo "✔ 已从 CLAUDE.md 移除规范引用"
  else
    echo "✔ CLAUDE.md 中未找到规范引用，跳过"
  fi
fi

# 4. 询问是否删除仓库
echo ""
read -p "是否删除仓库 ~/dev-standards？(y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -rf "$HOME/dev-standards"
  echo "✔ 已删除仓库"
else
  echo "✔ 保留仓库 ~/dev-standards"
fi

echo ""
echo "✅ 卸载完成！重启 Claude Code 生效。"
