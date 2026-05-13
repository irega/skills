# irega/skills

Personal skills, configs, and conventions for Claude Code and Cursor.

## Quick Install

```bash
# Clone and install
git clone git@github-personal:irega/skills.git ~/dev/skills
cd ~/dev/skills
./scripts/install.sh
```

Skills auto-available in Claude Code + Cursor.

## Skills

### Engineering
- **ivan** — How I like to code (stack, patterns, testing approach)

### Productivity
- (coming soon)

## Structure

```
skills/
├── ivan/              # Personal skill: my dev approach
├── engineering/       # Reusable technical skills
└── productivity/      # Workflow / non-code skills

configs/
├── claude/            # Claude Code templates
└── cursor/            # Cursor rule templates
```

## What's a skill?

Markdown file with YAML frontmatter. Loaded by `/ivan`, `/commit`, etc. in Claude Code and Cursor.

See `skills/ivan/SKILL.md` for structure.

## Dev notes

- Update `CLAUDE.md` when rules change
- Plugin registered in `.claude-plugin/plugin.json`
- Symlinks created by `scripts/link-skills.sh`
