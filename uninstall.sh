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

# 3. 从 CLAUDE.md 移除我们添加的精确内容
# 我们添加的内容以 "# 个人前端开发规范" 开头，以 "详见 `~/.claude/standards/review.md`" 结尾
if [ -f "$CLAUDE_MD" ] && grep -q "# 个人前端开发规范" "$CLAUDE_MD"; then
  # 使用 Python 精确匹配并移除我们的块
  python3 -c "
import re
import sys

with open('$CLAUDE_MD', 'r', encoding='utf-8') as f:
    content = f.read()

# 我们添加的精确块
our_block = '''

# 个人前端开发规范

前端开发规范，通过 Claude Code import(\`@\`)自动加载到上下文，会话启动即生效，无需手动读取。

@standards/engineering.md
@standards/code-style.md
@standards/error-handling.md
@standards/testing.md
@standards/component-design.md
@standards/commit-style.md
@standards/review.md
@standards/figma.md
@standards/i18n.md'''

if our_block in content:
    content = content.replace(our_block, '')
    with open('$CLAUDE_MD', 'w', encoding='utf-8') as f:
        f.write(content.rstrip() + '\n')
    print('✔ 已从 CLAUDE.md 移除规范引用')
else:
    print('✔ CLAUDE.md 中未找到精确匹配的规范引用，跳过')
" 2>/dev/null || {
    # 如果 Python 不可用，使用 sed 精确匹配
    # 创建临时文件存储我们要移除的内容
    TEMP_FILE=$(mktemp)
    cat > "$TEMP_FILE" << 'BLOCK'

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
BLOCK
    # 使用 awk 移除精确匹配的块
    awk -v block="$(cat "$TEMP_FILE")" '
    {
        content = content $0 "\n"
    }
    END {
        if (index(content, block) > 0) {
            sub(block, "", content)
            printf "%s", content
        } else {
            printf "%s", content
        }
    }' "$CLAUDE_MD" > "$CLAUDE_MD.tmp"
    mv "$CLAUDE_MD.tmp" "$CLAUDE_MD"
    rm "$TEMP_FILE"
    echo "✔ 已从 CLAUDE.md 移除规范引用"
  }
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
