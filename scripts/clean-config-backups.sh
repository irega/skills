#!/usr/bin/env bash
set -euo pipefail

# Clean up config backups created by sync-configs.sh
# - Finds all .backup.YYYYMMDD-HHMMSS files in ~/.claude and ~/.cursor
# - Supports dry-run, keep-count, and force delete

KEEP_COUNT=${1:-0}  # Default: delete all. Use 'KEEP_COUNT=3' to keep 3 most recent
DRY_RUN=${DRY_RUN:-}  # Set DRY_RUN=1 for preview without deleting

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

error() { echo -e "${RED}error: $*${NC}" >&2; exit 1; }
success() { echo -e "${GREEN}✅ $*${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $*${NC}"; }
info() { echo -e "${BLUE}ℹ️  $*${NC}"; }

echo "Cleaning config backups..."
echo ""

if [ -n "$DRY_RUN" ]; then
  info "DRY RUN MODE (no files will be deleted)"
  echo ""
fi

total_removed=0
total_size=0

# Find all backup files in ~/.claude and ~/.cursor
backups=$(find "$HOME/.claude" "$HOME/.cursor" \
  -type f -name "*.backup.*" 2>/dev/null | sort -r || true)

if [ -z "$backups" ]; then
  info "No backups found"
  exit 0
fi

# Count backups
backup_count=$(echo "$backups" | grep -c . || true)
info "Found $backup_count backup(s)"
echo ""

# If KEEP_COUNT > 0, skip the oldest KEEP_COUNT backups
if [ "$KEEP_COUNT" -gt 0 ]; then
  backups=$(echo "$backups" | tail -n +$((KEEP_COUNT + 1)))
  if [ -z "$backups" ]; then
    info "Keeping $KEEP_COUNT most recent backup(s), nothing to delete"
    exit 0
  fi
fi

# Delete or preview
deleted=0
while IFS= read -r file; do
  size=$(du -h "$file" 2>/dev/null | cut -f1)

  if [ -n "$DRY_RUN" ]; then
    echo "  [DRY RUN] $file ($size)"
  else
    rm -f "$file"
    echo "  ✓ $file ($size)"
  fi
  ((deleted++))
done <<< "$backups"

echo ""
if [ -n "$DRY_RUN" ]; then
  success "Dry run complete: $deleted file(s) would be deleted"
  echo ""
  echo "To actually delete, run:"
  echo "  ./scripts/clean-config-backups.sh"
else
  success "Removed $deleted backup(s)"
fi

echo ""
echo "Usage:"
echo "  ./scripts/clean-config-backups.sh           # Delete all backups"
echo "  ./scripts/clean-config-backups.sh 3         # Keep 3 most recent"
echo "  DRY_RUN=1 ./scripts/clean-config-backups.sh # Preview without deleting"
