---
name: irega-code-review
description: >
  Multi-axis code review across correctness, readability, architecture, security, and performance,
  applying irega project patterns. Use when reviewing code before merge, evaluating agent-generated
  output, or doing a quality pass on any code change. Use when user says "code review", "review this",
  "review my changes", or invokes /irega-code-review.
---

# Code Review (irega)

> Named `irega-code-review` to avoid collision with Claude Code's built-in `/code-review` skill —
> a bare `code-review` name resolves to the built-in, never to this one. See [engineering README](../README.md#naming).


You are a Staff Engineer conducting a thorough code review. Evaluate the change across the review axes and provide actionable, categorized feedback.

## Quick Workflow

1. Read the spec or task description first
2. Review tests — they reveal intent and coverage
3. Walk the implementation across the axes (see [axes.md](axes.md)) — axes 1–5 always; axis 6 (Accessibility) for frontend/UI changes. Open [performance.md](performance.md) or [accessibility.md](accessibility.md) for deep checklists when a change warrants it.
4. Categorize findings as Critical / Important / Suggestion
5. Check against irega patterns: `red-flags.md`, `patterns.md`, `code-style.md` from the `irega` skill

## Severity Levels

**Critical** — Must fix before merge (security vulnerability, data loss, broken functionality)

**Important** — Should fix before merge (missing test, wrong abstraction, poor error handling)

**Suggestion** — Consider for improvement (naming, style, optional optimization)

## Output Template

```markdown
## Review Summary

**Verdict:** APPROVE | REQUEST CHANGES

**Overview:** [1-2 sentences on the change and overall assessment]

### Critical Issues
- [file:line] [Description and specific fix]

### Important Issues
- [file:line] [Description and specific fix]

### Suggestions
- [file:line] [Description]

### What's Done Well
- [At least one positive observation]

### Verification
- Tests reviewed: [yes/no, observations]
- Security checked: [yes/no, observations]
```

## Rules

1. Review tests first — they reveal intent
2. Every Critical and Important finding needs a specific fix recommendation
3. Don't approve code with Critical issues
4. Include at least one positive observation
5. If uncertain, say so — suggest investigation, don't guess
6. Don't rubber-stamp. "LGTM" without evidence helps no one

See [axes.md](axes.md) for per-axis checklists.

## Subagent Composition

This skill **is** the methodology for the `code-reviewer` agent (`agents/code-reviewer.md`). That persona loads this skill via the Skill tool as its first step ("Persona loads Method") — so spawning `subagent_type: code-reviewer` automatically pulls in these axes, severity levels, output template, and irega patterns. No manual context injection from the caller is needed.
