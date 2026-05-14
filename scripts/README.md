# Scripts

Automation scripts for setup and config management.

## install.sh

One-time setup for fresh clone. Runs all initialization steps.

**Prerequisite:** RTK must be installed before running.
```bash
brew install rtk
```

```bash
./scripts/install.sh
```

**What it does:**
1. Symlinks all skills from `skills/` to `~/.claude/skills/` and `~/.cursor/skills/`
2. Runs `rtk init -g --auto-patch` — creates `filters.toml`, `RTK.md`, and adds `@RTK.md` to global CLAUDE.md
3. Runs `rtk init -g --agent cursor --auto-patch` — wires RTK into Cursor agent hooks
4. Optionally syncs configs from `configs/` (full overwrite — repo is source of truth)

**Order matters:** RTK init runs before `sync-configs.sh` so that `settings.json` and `hooks.json` end up with the repo versions (which already include the RTK hooks), not the ones RTK patches.

**When to use:** After cloning the repo for the first time.

---

## link-skills.sh

Create symlinks from skills in this repo to system skill directories.

```bash
./scripts/link-skills.sh
```

**What it does:**
- Symlinks `skills/irega/`, `skills/engineering/`, `skills/productivity/` → `~/.claude/skills/`
- Symlinks same dirs → `~/.cursor/skills/`
- Skips `in-progress/` and `deprecated/`

**When to use:**
- After adding a new skill to the repo
- If symlinks got broken or deleted

---

## sync-configs.sh

Sync config files from repo to your system (full overwrite).

```bash
./scripts/sync-configs.sh
```

**What it does:**
- Backs up existing files with timestamp
- Overwrites `~/.claude/settings.json` with `configs/claude/settings.json`
- Overwrites `~/.cursor/hooks.json` with `configs/cursor/hooks.json`
- Copies `configs/cursor/hooks/` → `~/.cursor/hooks/` (recursive)
- Copies `configs/cursor/rules/` → `~/.cursor/rules/` (recursive)

**Backups created:**
- `~/.claude/settings.json.backup.YYYYMMDD-HHMMSS`
- `~/.cursor/hooks.json.backup.YYYYMMDD-HHMMSS`
- `~/.cursor/hooks.backup.YYYYMMDD-HHMMSS/`
- `~/.cursor/rules.backup.YYYYMMDD-HHMMSS/`

**When to use:**
- After updating `configs/` in the repo
- Whenever repo is your source of truth for config

---

## clean-config-backups.sh

Clean up config backups created by `sync-configs.sh`.

```bash
# Preview without deleting
DRY_RUN=1 ./scripts/clean-config-backups.sh

# Delete all backups
./scripts/clean-config-backups.sh

# Keep 3 most recent, delete others
./scripts/clean-config-backups.sh 3
```

**Options:**
- `DRY_RUN=1` — Preview what would be deleted without actually deleting
- `./scripts/clean-config-backups.sh N` — Keep N most recent backups, delete others
- No args — Delete all backups

**When to use:**
- After confirming synced configs are working
- When backup directory gets too large

---

## Usage examples

**Fresh install:**
```bash
brew install rtk
git clone git@github.com:irega/skills.git ~/dev/skills
cd ~/dev/skills
./scripts/install.sh
```

**Update configs from repo:**
```bash
./scripts/sync-configs.sh
```

**Clean old backups:**
```bash
DRY_RUN=1 ./scripts/clean-config-backups.sh  # Preview
./scripts/clean-config-backups.sh 3           # Keep 3 most recent
```

**Add new skill:**
```bash
# Create skill in skills/bucket/name/
./scripts/link-skills.sh  # Symlink to system
```
