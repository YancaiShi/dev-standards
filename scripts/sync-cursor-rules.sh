#!/bin/bash
# Sync standards/*.md -> ~/.cursor/rules/dev-standards-*.mdc (alwaysApply)
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STANDARDS_DIR="$REPO_ROOT/standards"
CURSOR_RULES_DIR="$HOME/.cursor/rules"
MANIFEST="$(dirname "$0")/cursor-rules-manifest.json"

if [ ! -d "$STANDARDS_DIR" ]; then
  echo "Missing standards dir: $STANDARDS_DIR" >&2
  exit 1
fi
if [ ! -f "$MANIFEST" ]; then
  echo "Missing manifest: $MANIFEST" >&2
  exit 1
fi

mkdir -p "$CURSOR_RULES_DIR"
rm -f "$CURSOR_RULES_DIR"/dev-standards-*.mdc

if ! command -v python3 >/dev/null 2>&1 && ! command -v python >/dev/null 2>&1; then
  echo "python3 required to read cursor-rules-manifest.json" >&2
  exit 1
fi
PYTHON="$(command -v python3 || command -v python)"

"$PYTHON" - "$MANIFEST" "$STANDARDS_DIR" "$CURSOR_RULES_DIR" <<'PY'
import json, sys
from pathlib import Path

manifest, standards_dir, out_dir = sys.argv[1:4]
rules = json.loads(Path(manifest).read_text(encoding="utf-8"))
standards = Path(standards_dir)
out = Path(out_dir)

for rule in rules:
    src = standards / rule["file"]
    if not src.is_file():
        print(f"Skip missing: {rule['file']}")
        continue
    body = src.read_text(encoding="utf-8").rstrip()
    text = (
        "---\n"
        f"description: {rule['desc']}\n"
        "alwaysApply: true\n"
        "---\n\n"
        f"{body}\n"
    )
    (out / rule["name"]).write_text(text, encoding="utf-8")
PY

echo "Synced Cursor Rules -> $CURSOR_RULES_DIR (dev-standards-*.mdc)"
