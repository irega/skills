#!/usr/bin/env bash
set -euo pipefail

# Sync configs from repo to ~/.claude and ~/.cursor with full overwrite
# - Reads from configs/
# - Overwrites all settings (repo is source of truth)
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
success() { echo -e "${GREEN}$*${NC}"; }
warn() { echo -e "${YELLOW}WARNING: $*${NC}"; }
info() { echo "$*"; }

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
  info "Syncing Claude Code settings..."

  # Backup existing
  if [ -f "$CLAUDE_DEST" ]; then
    cp "$CLAUDE_DEST" "$CLAUDE_DEST.backup.$TIMESTAMP"
    info "Backed up to settings.json.backup.$TIMESTAMP"
  fi

  # Overwrite with repo config
  cp "$CLAUDE_SRC" "$CLAUDE_DEST"
  jq . "$CLAUDE_DEST" > /dev/null  # Validate JSON
  success "Synced settings.json (repo is source of truth)"
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
  info "Syncing Cursor hooks.json..."

  if [ -f "$CURSOR_HOOKS_JSON_DEST" ]; then
    cp "$CURSOR_HOOKS_JSON_DEST" "$CURSOR_HOOKS_JSON_DEST.backup.$TIMESTAMP"
    info "Backed up to hooks.json.backup.$TIMESTAMP"
  fi

  # Overwrite with repo config
  cp "$CURSOR_HOOKS_JSON_SRC" "$CURSOR_HOOKS_JSON_DEST"
  jq . "$CURSOR_HOOKS_JSON_DEST" > /dev/null  # Validate JSON
  success "Synced hooks.json (repo is source of truth)"
else
  warn "configs/cursor/hooks.json not found, skipping"
fi

if [ -d "$CURSOR_HOOKS_SRC" ]; then
  info "Syncing Cursor hook scripts..."

  # Backup existing
  if [ -d "$CURSOR_HOOKS_DEST" ]; then
    mv "$CURSOR_HOOKS_DEST" "$CURSOR_HOOKS_DEST.backup.$TIMESTAMP"
    info "Backed up to hooks.backup.$TIMESTAMP"
  fi

  # Copy hooks directory
  cp -r "$CURSOR_HOOKS_SRC" "$CURSOR_HOOKS_DEST"
  chmod +x "$CURSOR_HOOKS_DEST"/*.sh 2>/dev/null || true
  success "Synced Cursor hook scripts (repo is source of truth)"
else
  warn "configs/cursor/hooks/ not found, skipping"
fi

echo ""

# ============================================================================
# Cursor rules (copy entire rules/ dir)
# ============================================================================

CURSOR_RULES_SRC="$REPO/configs/cursor/rules"
CURSOR_RULES_DEST="$HOME/.cursor/rules"

if [ -d "$CURSOR_RULES_SRC" ]; then
  info "Syncing Cursor rules..."

  # Backup existing
  if [ -d "$CURSOR_RULES_DEST" ]; then
    mv "$CURSOR_RULES_DEST" "$CURSOR_RULES_DEST.backup.$TIMESTAMP"
    info "Backed up to rules.backup.$TIMESTAMP"
  fi

  # Copy rules directory
  cp -r "$CURSOR_RULES_SRC" "$CURSOR_RULES_DEST"
  success "Synced Cursor rules (repo is source of truth)"
else
  warn "configs/cursor/rules/ not found, skipping"
fi

# ============================================================================
# Cursor mcp.json + token injection
# ============================================================================

CURSOR_MCP_SRC="$REPO/configs/cursor/mcp.json"
CURSOR_MCP_DEST="$HOME/.cursor/mcp.json"
ENV_LOCAL="$REPO/.env.local"

if [ -f "$CURSOR_MCP_SRC" ]; then
  info "Syncing Cursor mcp.json..."

  if [ -f "$CURSOR_MCP_DEST" ]; then
    cp "$CURSOR_MCP_DEST" "$CURSOR_MCP_DEST.backup.$TIMESTAMP"
    info "Backed up to mcp.json.backup.$TIMESTAMP"
  fi

  cp "$CURSOR_MCP_SRC" "$CURSOR_MCP_DEST"

  # Inject Playwright token from .env.local if present
  if [ -f "$ENV_LOCAL" ]; then
    PLAYWRIGHT_TOKEN=$(grep -E "^PLAYWRIGHT_MCP_EXTENSION_TOKEN=" "$ENV_LOCAL" | cut -d'=' -f2- | tr -d ' ')
    if [ -n "$PLAYWRIGHT_TOKEN" ]; then
      # Set env.PLAYWRIGHT_MCP_EXTENSION_TOKEN in mcpServers.playwright
      jq ".mcpServers.playwright.env.PLAYWRIGHT_MCP_EXTENSION_TOKEN = \"$PLAYWRIGHT_TOKEN\"" "$CURSOR_MCP_DEST" > "$CURSOR_MCP_DEST.tmp"
      mv "$CURSOR_MCP_DEST.tmp" "$CURSOR_MCP_DEST"
      info "  Injected Playwright MCP token"
    fi
  fi

  jq . "$CURSOR_MCP_DEST" > /dev/null  # Validate JSON
  success "Synced mcp.json (repo is source of truth)"
else
  warn "configs/cursor/mcp.json not found, skipping"
fi

echo ""

# ============================================================================
# Claude Code MCP servers (registered via CLI → writes to ~/.claude.json)
# Source of truth: configs/cursor/mcp.json (shared between Claude & Cursor)
# ============================================================================

CLAUDE_MCP_SRC="$REPO/configs/cursor/mcp.json"

if [ -f "$CLAUDE_MCP_SRC" ] && command -v claude >/dev/null; then
  info "Syncing Claude Code MCP servers..."

  # Parse server names from JSON
  MCP_SERVERS=$(jq -r '.mcpServers | keys[]' "$CLAUDE_MCP_SRC")

  for SERVER in $MCP_SERVERS; do
    COMMAND=$(jq -r ".mcpServers[\"$SERVER\"].command" "$CLAUDE_MCP_SRC")
    ARGS=$(jq -r ".mcpServers[\"$SERVER\"].args[]" "$CLAUDE_MCP_SRC")

    # Remove existing registration (idempotent)
    claude mcp remove "$SERVER" --scope user 2>/dev/null || true

    # Re-add with current config
    # shellcheck disable=SC2086
    claude mcp add "$SERVER" --scope user -- $COMMAND $ARGS
    info "  Registered: $SERVER"
  done

  success "Synced Claude Code MCP servers (repo is source of truth)"
else
  [ ! -f "$CLAUDE_MCP_SRC" ] && warn "configs/cursor/mcp.json not found, skipping Claude MCP sync"
  ! command -v claude >/dev/null && warn "'claude' CLI not found, skipping Claude MCP sync"
fi

echo ""
success "Config sync complete"
echo ""
echo "Next:"
echo "  - Review ~/.claude/settings.json if needed"
echo "  - Review ~/.cursor/hooks.json if needed"
echo "  - Review ~/.cursor/mcp.json if needed"
echo "  - Review ~/.cursor/rules/ if needed"
echo "  - Restart Claude Code to pick up new MCP servers"
echo ""
