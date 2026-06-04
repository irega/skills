---
name: planning
description: Specification-driven feature planning with OpenSpec. Use when starting a non-trivial feature, designing a system change, or when "what to build" isn't settled yet. Triggers on phrases like "plan this", "let's spec this out", "before we build", or when the scope is unclear.
---

# Feature Planning

Thin orchestration layer over [OpenSpec](https://github.com/Fission-AI/OpenSpec/) that ties proposal, design, implementation, and review into a single workflow using the existing engineering skills.

## When to use

- New feature with non-obvious design decisions
- Refactor touching multiple components
- Any work where alignment before building prevents rework

Skip planning for small, well-defined tasks — jump straight to `/tdd`.

## Workflow

### 1. Propose
```
/opsx:propose <feature description>
```
OpenSpec creates a `changes/` folder with `proposal.md`, `specs/`, `design.md`, and `tasks.md`.

Review and edit `design.md` before moving on. This is the cheapest point to change direction.

### 2. Validate the design
Run `/staff-review` on `design.md` to catch architectural issues before any code is written.

Fix `design.md` based on feedback, then confirm with the user.

### 3. Implement
Work through `tasks.md` using `/tdd` — one task at a time, vertically. Each task becomes a tracer bullet.

```
/opsx:apply   # OpenSpec generates task checklist in context
```

### 4. Review before merge
When all tasks in `tasks.md` are checked off:
- Run `/irega-code-review` on the full diff
- Run `/security-audit` if the change touches auth, data handling, or external APIs

Address all Critical/Important findings before proceeding.

### 5. Generate PR and archive
```
/pr-description   # generates PR from template + git changes
/opsx:archive     # moves change to history
```

## Commands reference

| Command | Phase | Purpose |
|---|---|---|
| `/opsx:propose <idea>` | Plan | Create change proposal |
| `/opsx:apply` | Implement | Generate task checklist from spec |
| `/opsx:verify` | Review | Check implementation against spec |
| `/opsx:archive` | Close | Move completed change to history |

## First-time setup

OpenSpec must be installed globally once per machine (handled by `install.sh`):
```bash
npm install -g @fission-ai/openspec@latest
```

Initialize OpenSpec in each project where you want planning:
```bash
cd your-project
openspec init
openspec config profile   # select workflow profile
```
