---
name: ivan
description: How Iván likes to code — stack, patterns, conventions, testing approach. Use when starting new work or need style guidance.
---

# How I Code

*Personal conventions and preferences for development.*

## Stack

- **Languages**: TypeScript, Go, Python, React/Next.js
- **Testing**: Integration tests first, unit tests for business logic
- **Git**: Conventional commits, squash + rebase workflow, PRs reviewed before merge
- **Code org**: Modules > components > functions (deep modules preferred)

## Principles

### Testability

- Test behavior, not implementation
- Prefer integration tests over mocks
- One test = one behavior
- Tests survive refactors

### Code style

- Explicit > implicit
- Names matter (say what it does)
- Duplication > premature abstraction
- No speculative features

### Workflows

- Read code before changing it
- Plan before coding (get alignment)
- One PR = one logical change
- Commits are breadcrumbs, not novels

## When to ask me

- Stack choice (which library/framework?)
- Architecture (folder structure, patterns?)
- Testing strategy (what to test, how?)
- Refactoring (safe to change?)
- Performance (where to optimize?)

## When NOT to ask me

- Style/linting (auto-format solves this)
- Docstring/comment tone (be clear, that's all)
- Renaming unused vars (just delete if unused)

---

## Expand this skill

Add docs as needed:
- `testing.md` — detailed testing approach
- `typescript.md` — TS patterns I prefer
- `go.md` — Go conventions
- `patterns.md` — design patterns I use
- `git-workflow.md` — PR process details
