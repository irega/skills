# Engineering Skills

Reusable technical skills for code work.

## Available Skills

- **tdd** — Test-driven development with red-green-refactor loop
  - Red-Green-Refactor workflow
  - Integration testing best practices
  - Vertical slices with tracer bullets
  - See `tdd/SKILL.md` for details

- **pr-description** — Generate PR description from template and git changes
  - Auto-extracts Jira tickets from commits
  - Respects `.github/pull_request_template.md` if it exists
  - Generates concise change summary and test instructions
  - Copies to clipboard ready to paste
  - See `pr-description/SKILL.md` for details

- **code-review** — Multi-axis code review before merge
  - Five axes: correctness, readability, architecture, security, performance
  - Critical/Important/Suggestion severity levels
  - Checks against irega patterns from the `irega` skill
  - See `code-review/SKILL.md` and `code-review/axes.md` for details

- **security-audit** — Security-focused review and vulnerability detection
  - OWASP Top 10 baseline
  - Five domains: input handling, auth, data protection, infrastructure, third-party
  - Works on any artifact (files, components, diffs, architecture)
  - Proof of concept required for Critical/High findings
  - See `security-audit/SKILL.md` and `security-audit/owasp.md` for details

- **staff-review** — Technical design and architectural judgment evaluation
  - Six axes: problem decomposition, trade-offs, scalability, tech choices, operations, communication
  - Evaluates engineering reasoning, not just correctness
  - Ideal for validating design decisions before building or reviewing proposals
  - See `staff-review/SKILL.md` and `staff-review/rubric.md` for details

- **planning** — Specification-driven feature planning with OpenSpec
  - Orchestrates propose → design → implement → review lifecycle
  - Ties `/staff-review`, `/tdd`, `/code-review`, `/pr-description` into a single flow
  - Uses OpenSpec (`/opsx:*` commands) for structured change tracking
  - See `planning/SKILL.md` for details
