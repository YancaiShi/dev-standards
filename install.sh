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

# 2. 创建链接
mkdir -p "$HOME/.claude"

create_link() {
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Windows: 使用 junction（不需要管理员权限）
    cmd.exe /c "mklink /J \"$(cygpath -w "$STANDARDS_DIR")\" \"$(cygpath -w "$INSTALL_DIR/standards")\"" > /dev/null 2>&1
  else
    # macOS/Linux: 使用符号链接
    ln -s "$INSTALL_DIR/standards" "$STANDARDS_DIR"
  fi
}

if [ -L "$STANDARDS_DIR" ]; then
  echo "✔ 链接已存在，跳过"
elif [ -d "$STANDARDS_DIR" ]; then
  mv "$STANDARDS_DIR" "$STANDARDS_DIR.bak"
  create_link
  echo "✔ 已创建链接（原目录已备份）"
else
  create_link
  echo "✔ 已创建链接"
fi

# 3. 配置 CLAUDE.md
MARKER="# 个人前端开发规范"
if [ -f "$CLAUDE_MD" ] && grep -q "$MARKER" "$CLAUDE_MD"; then
  echo "✔ CLAUDE.md 已配置，跳过"
else
  cat >> "$CLAUDE_MD" << 'EOF'

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
EOF
  echo "✔ 已配置 CLAUDE.md"
fi

# 4. 同步 Cursor User Rules（alwaysApply，跨项目稳定注入）
chmod +x "$INSTALL_DIR/scripts/sync-cursor-rules.sh"
bash "$INSTALL_DIR/scripts/sync-cursor-rules.sh"

echo ""
echo "✅ 安装完成！重启 Claude Code / Cursor 即可生效。"
echo "   Cursor：Settings → Rules, Commands → User Rules 可见 dev-standards-*"
