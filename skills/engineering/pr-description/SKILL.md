---
name: pr-description
description: Generate PR description from template and git changes. Use when creating a PR and want to auto-generate description based on .github template, commits, and diffs. Extracts Jira tickets from commit messages.
---

# PR Description Generator

Reads `.github/pull_request_template.md` (or uses sensible defaults), analyzes your branch changes vs main, and generates a PR description with:

- Extracted Jira ticket (PROJ-123 format)
- Concise change summary from commits
- Test instructions placeholder
- PR checklist
- Any other sections from the template

Output goes directly to clipboard.

## Quick start

```bash
/pr-description
```

Analyzes current branch vs `main`, generates description, copies to clipboard.

To specify different base branch:

```bash
/pr-description --base develop
```

## How it works

1. **Reads template** — Looks for `.github/pull_request_template.md` in repo root
2. **Parses commits** — Extracts from `git log <base>...HEAD`
   - Jira ticket (first match of `PROJ-123` or `[PROJ-123]`)
   - Commit messages for description
3. **Analyzes diff** — `git diff <base>...HEAD` to understand scope
4. **Generates content**:
   - **Ticket**: From commits (if found)
   - **Summary**: Concise description of changes (not verbose)
   - **Testing**: Template placeholder for user to fill
   - **Checklist**: Standard PR items
5. **Copies to clipboard** — Ready to paste into PR

## Default template (if none in repo)

```markdown
## Description
{summary}

## How to test
{placeholder}

## Ticket
{jira_ticket}

## Checklist
- [ ] Tests pass
- [ ] No breaking changes
- [ ] Docs updated (if needed)
```

## Notes

- If `.github/pull_request_template.md` exists, it's used instead of default
- Jira ticket extracted from commit messages (first match)
- Change summary is generated from commit titles, not verbose
- Modify output in PR UI before submitting — this is a starting point
