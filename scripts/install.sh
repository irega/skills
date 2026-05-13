#!/usr/bin/env bash
set -euo pipefail

# Full install: symlinks + optional config merge

REPO="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing irega/skills..."
echo ""

# 1. Symlinks
bash "$REPO/scripts/link-skills.sh"

echo ""
echo "✅ Skills installed."
echo ""
echo "Next steps:"
echo "1. In Claude Code: use /ivan and other skills"
echo "2. In Cursor: skills auto-available"
echo ""
echo "To customize settings, see:"
echo "  - configs/claude/settings.json (Claude Code template)"
echo "  - configs/cursor/rules/ (Cursor rules template)"
