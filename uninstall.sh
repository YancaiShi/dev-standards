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

# 3. 从 CLAUDE.md 移除规范引用
if [ -f "$CLAUDE_MD" ] && grep -q "# 个人前端开发规范" "$CLAUDE_MD"; then
  # 移除从 "# 个人前端开发规范" 到下一个顶级标题之间的内容
  sed -i.bak '/^# 个人前端开发规范$/,/^# [^#]/{ /^# [^#]/!d; /^# 个人前端开发规范$/d; }' "$CLAUDE_MD"
  rm -f "$CLAUDE_MD.bak"
  echo "✔ 已从 CLAUDE.md 移除规范引用"
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
