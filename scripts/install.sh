#!/usr/bin/env bash
set -euo pipefail

# Full install: symlinks + optional config merge

REPO="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing irega/skills..."
echo ""

# 1. Symlinks
bash "$REPO/scripts/link-skills.sh"

echo ""

# 2. RTK setup (creates filters.toml + RTK.md + @RTK.md in global CLAUDE.md)
#    Must run before sync-configs.sh so settings.json gets the repo version afterward.
if command -v rtk &>/dev/null; then
  echo "Setting up RTK..."
  rtk init -g --auto-patch
  rtk init -g --agent cursor --auto-patch
  echo "RTK configured."
else
  echo "WARNING: RTK not found. Install it first, then re-run this script."
  echo "    See: https://github.com/rtk-ai/rtk"
fi

echo ""

# 3. Config sync (optional, ask user)
#    Overwrites ~/.claude/settings.json and ~/.cursor/hooks.json with repo versions,
#    which already include the RTK hooks.
read -p "Sync configs (Claude/Cursor)? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  bash "$REPO/scripts/sync-configs.sh"
fi

echo ""
echo "Installation complete."
echo ""
echo "Next steps:"
echo "1. In Claude Code: use /irega and other skills"
echo "2. In Cursor: skills auto-available"
echo ""
if [ ! -f "$HOME/.claude/settings.json" ] || [ ! -L "$HOME/.cursor/rules" ]; then
  echo "To sync configs later, run:"
  echo "  $REPO/scripts/sync-configs.sh"
  echo ""
fi
