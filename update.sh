#!/bin/bash
set -e

INSTALL_DIR="$HOME/dev-standards"
STANDARDS_DIR="$HOME/.claude/standards"

echo "🔄 更新 dev-standards..."

# 1. 检查是否已安装
if [ ! -d "$INSTALL_DIR/.git" ]; then
    echo "✖ 未检测到安装，请先执行安装命令：" >&2
    echo "  bash <(curl -sSL https://raw.githubusercontent.com/YancaiShi/dev-standards/main/install.sh)" >&2
    exit 1
fi

# 2. 拉取最新（规范以远程为唯一源，强制对齐远程）
git -C "$INSTALL_DIR" fetch -q origin
git -C "$INSTALL_DIR" reset --hard -q origin/main
echo "✔ 已更新到最新版本"

# 3. 确认链接
if [ ! -e "$STANDARDS_DIR" ]; then
    echo "⚠ 检测到 $STANDARDS_DIR 不存在，建议重新执行安装脚本"
else
    echo "✔ 链接正常，规范已同步到 ~/.claude/standards"
fi

echo ""
echo "✅ 更新完成！重启 Claude Code 即可生效。"
