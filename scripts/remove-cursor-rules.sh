#!/bin/bash
# Remove ~/.cursor/rules/dev-standards-*.mdc
set -e

CURSOR_RULES_DIR="$HOME/.cursor/rules"

if [ ! -d "$CURSOR_RULES_DIR" ]; then
  echo "✔ 无 Cursor Rules 目录，跳过"
  exit 0
fi

shopt -s nullglob
files=("$CURSOR_RULES_DIR"/dev-standards-*.mdc)
if [ ${#files[@]} -eq 0 ]; then
  echo "✔ 未找到 dev-standards-*.mdc，跳过"
  exit 0
fi

rm -f "${files[@]}"
echo "✔ 已删除 Cursor Rules（${#files[@]} 个 dev-standards-*.mdc）"
