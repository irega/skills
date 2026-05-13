#!/usr/bin/env bash
set -euo pipefail

# Sync configs from repo to ~/.claude and ~/.cursor with smart merge
# - Reads from configs/
# - Merges (not overwrites) with existing settings
# - Backs up before changes
# - Cross-platform safe

REPO="$(cd "$(dirname "$0")/.." && pwd)"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

error() { echo -e "${RED}error: $*${NC}" >&2; exit 1; }
success() { echo -e "${GREEN}✅ $*${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $*${NC}"; }
info() { echo -e "ℹ️  $*"; }

# Check jq available
command -v jq >/dev/null || error "jq required. Install: brew install jq"

echo "Syncing configs from $REPO..."
echo ""

# ============================================================================
# Claude Code settings.json
# ============================================================================

CLAUDE_SRC="$REPO/configs/claude/settings.json"
CLAUDE_DEST="$HOME/.claude/settings.json"

if [ -f "$CLAUDE_SRC" ]; then
  info "Merging Claude Code settings..."

  # Backup existing
  if [ -f "$CLAUDE_DEST" ]; then
    cp "$CLAUDE_DEST" "$CLAUDE_DEST.backup.$TIMESTAMP"
    info "Backed up to settings.json.backup.$TIMESTAMP"
  fi

  # Merge: repo config wins for model/effortLevel, but preserve hooks/plugins user added
  if [ -f "$CLAUDE_DEST" ]; then
    # Merge strategy: take repo's model/effortLevel, keep user's hooks/plugins
    merged=$(jq -n \
      "$(cat "$CLAUDE_DEST") * $(cat "$CLAUDE_SRC")")
    echo "$merged" | jq . > "$CLAUDE_DEST"
    success "Merged settings (repo config + user hooks/plugins preserved)"
  else
    cp "$CLAUDE_SRC" "$CLAUDE_DEST"
    success "Created new settings.json"
  fi
else
  warn "configs/claude/settings.json not found, skipping"
fi

echo ""

# ============================================================================
# Cursor hooks (hooks.json merge + hooks/ symlink)
# ============================================================================

CURSOR_HOOKS_JSON_SRC="$REPO/configs/cursor/hooks.json"
CURSOR_HOOKS_JSON_DEST="$HOME/.cursor/hooks.json"
CURSOR_HOOKS_SRC="$REPO/configs/cursor/hooks"
CURSOR_HOOKS_DEST="$HOME/.cursor/hooks"

if [ -f "$CURSOR_HOOKS_JSON_SRC" ]; then
  info "Merging Cursor hooks.json..."

  if [ -f "$CURSOR_HOOKS_JSON_DEST" ]; then
    cp "$CURSOR_HOOKS_JSON_DEST" "$CURSOR_HOOKS_JSON_DEST.backup.$TIMESTAMP"
    merged=$(jq -n \
      "$(cat "$CURSOR_HOOKS_JSON_DEST") * $(cat "$CURSOR_HOOKS_JSON_SRC")")
    echo "$merged" | jq . > "$CURSOR_HOOKS_JSON_DEST"
    success "Merged hooks.json (repo hooks win, user hooks preserved)"
  else
    cp "$CURSOR_HOOKS_JSON_SRC" "$CURSOR_HOOKS_JSON_DEST"
    success "Created hooks.json"
  fi
else
  warn "configs/cursor/hooks.json not found, skipping"
fi

if [ -d "$CURSOR_HOOKS_SRC" ]; then
  info "Setting up Cursor hook scripts..."

  if [ -L "$CURSOR_HOOKS_DEST" ]; then
    resolved="$(readlink -f "$CURSOR_HOOKS_DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        success "Hook scripts already symlinked"
        ;;
      *)
        warn "$CURSOR_HOOKS_DEST is a symlink outside this repo, skipping"
        ;;
    esac
  elif [ -d "$CURSOR_HOOKS_DEST" ] && [ ! -L "$CURSOR_HOOKS_DEST" ]; then
    warn "$CURSOR_HOOKS_DEST is a real directory (not symlink)"
    warn "Skipping — to use repo hooks, manually merge or:"
    warn "  mv $CURSOR_HOOKS_DEST $CURSOR_HOOKS_DEST.local"
    warn "  ln -s $CURSOR_HOOKS_SRC $CURSOR_HOOKS_DEST"
  else
    rm -f "$CURSOR_HOOKS_DEST" 2>/dev/null || true
    ln -s "$CURSOR_HOOKS_SRC" "$CURSOR_HOOKS_DEST"
    success "Symlinked Cursor hook scripts"
  fi

  chmod +x "$CURSOR_HOOKS_SRC"/*.sh 2>/dev/null || true
else
  warn "configs/cursor/hooks/ not found, skipping"
fi

echo ""

# ============================================================================
# Cursor rules (symlink entire rules/ dir)
# ============================================================================

CURSOR_RULES_SRC="$REPO/configs/cursor/rules"
CURSOR_RULES_DEST="$HOME/.cursor/rules"

if [ -d "$CURSOR_RULES_SRC" ]; then
  info "Setting up Cursor rules..."

  # If dest is a symlink into this repo, bail (would create loop)
  if [ -L "$CURSOR_RULES_DEST" ]; then
    resolved="$(readlink -f "$CURSOR_RULES_DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        success "Cursor rules already symlinked"
        ;;
      *)
        error "$CURSOR_RULES_DEST is a symlink outside this repo"
        ;;
    esac
  elif [ -d "$CURSOR_RULES_DEST" ] && [ ! -L "$CURSOR_RULES_DEST" ]; then
    warn "$CURSOR_RULES_DEST is a real directory (not symlink)"
    warn "Skipping — to use repo rules, manually merge or:"
    warn "  mv $CURSOR_RULES_DEST $CURSOR_RULES_DEST.local"
    warn "  ln -s $CURSOR_RULES_SRC $CURSOR_RULES_DEST"
  else
    rm -f "$CURSOR_RULES_DEST" 2>/dev/null || true
    ln -s "$CURSOR_RULES_SRC" "$CURSOR_RULES_DEST"
    success "Symlinked Cursor rules"
  fi
else
  warn "configs/cursor/rules/ not found, skipping"
fi

echo ""
success "Config sync complete"
echo ""
echo "Next:"
echo "  - Review ~/.claude/settings.json if needed"
echo "  - Review ~/.cursor/hooks.json if needed"
echo "  - Review ~/.cursor/rules/ if needed"
echo ""
