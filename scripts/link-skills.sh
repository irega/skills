#!/usr/bin/env bash
set -euo pipefail

# Links all skills in this repository to ~/.claude/skills and ~/.cursor/skills
# so they can be used by Claude Code and Cursor.

REPO="$(cd "$(dirname "$0")/.." && pwd)"

# Claude
CLAUDE_DEST="$HOME/.claude/skills"
# Cursor
CURSOR_DEST="$HOME/.cursor/skills"

echo "Linking skills from $REPO..."

for dest in "$CLAUDE_DEST" "$CURSOR_DEST"; do
  agent=$(basename "$dest" | sed 's/\/skills$//')

  # Safety: if dest is a symlink into this repo, bail
  if [ -L "$dest" ]; then
    resolved="$(readlink -f "$dest")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $dest is a symlink into this repo ($resolved)." >&2
        echo "Remove it first: rm \"$dest\"" >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$dest"

  # Find all SKILL.md files, skip deprecated
  find "$REPO/skills" -name SKILL.md -not -path '*/deprecated/*' -print0 |
  while IFS= read -r -d '' skill_md; do
    src="$(dirname "$skill_md")"
    name="$(basename "$src")"
    target="$dest/$name"

    # Replace existing, remove old dir if it was a real dir
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm -rf "$target"
    fi

    ln -sfn "$src" "$target"
    echo "  $agent: linked $name"
  done
done

# Agents (Claude Code subagents) — link each persona file to ~/.claude/agents.
# Symlink-based install doesn't go through plugin.json's `agents` field, so we
# link the persona files into the directory Claude Code scans for subagents.
AGENTS_DEST="$HOME/.claude/agents"
if [ -d "$REPO/agents" ]; then
  mkdir -p "$AGENTS_DEST"
  find "$REPO/agents" -maxdepth 1 -name '*.md' ! -name 'README.md' -print0 |
  while IFS= read -r -d '' agent_md; do
    name="$(basename "$agent_md")"
    target="$AGENTS_DEST/$name"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm -f "$target"
    fi

    ln -sfn "$agent_md" "$target"
    echo "  agents: linked $name"
  done
fi

echo "Done. Skills and agents ready in Claude Code and Cursor."
