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

- **irega-code-review** — Multi-axis code review before merge
  - Six axes: correctness, readability, architecture, security, performance, accessibility (frontend)
  - Critical/Important/Suggestion severity levels
  - Checks against irega patterns from the `irega` skill
  - Deep-dive checklists: `performance.md` (Core Web Vitals, N+1, bundles), `accessibility.md` (WCAG 2.1 AA)
  - See `irega-code-review/SKILL.md` and `irega-code-review/axes.md` for details
  - Invoke with `/irega-code-review` (see [Naming](#naming) for why the prefix)

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
  - Ties `/staff-review`, `/tdd`, `/irega-code-review`, `/pr-description` into a single flow
  - Uses OpenSpec (`/opsx:*` commands) for structured change tracking
  - See `planning/SKILL.md` for details

## Agents

Specialist personas registered as Claude Code subagents. Invoke via the Agent tool with `subagent_type: <name>`.

- **code-reviewer** — Senior Staff Engineer. Loads the `irega-code-review` skill as its methodology. See `agents/code-reviewer.md`.
- **security-auditor** — Security Engineer. Loads the `security-audit` skill as its methodology. See `agents/security-auditor.md`.
- **test-engineer** — QA Engineer. Self-contained (no skill twin); optionally loads `tdd` for red-green work. See `agents/test-engineer.md`.

**Persona loads Method:** `code-reviewer` and `security-auditor` are thin personas — the *who*. As their first step they invoke their corresponding skill via the Skill tool (the *how*), so the methodology and irega patterns live in one place (the skill) and never drift from the agent. Spawning the subagent automatically pulls in the full skill.

See `agents/README.md` for the skill/persona/command layer model.

## Naming

**`irega-code-review` carries the `irega-` prefix on purpose.** Claude Code ships a built-in skill named `code-review` (the multi-agent cloud review behind `/code-review`). Skill names are resolved globally, and a bare `code-review` resolves to the built-in — our repo's version would be silently shadowed and never run. Prefixing with `irega-` guarantees `/irega-code-review` (and any agent that invokes `Skill("irega-code-review")`) loads *this* skill with its irega patterns.

The other engineering skills keep their plain names because none collide with a built-in:

| Our skill | Built-in? | Action |
|-----------|-----------|--------|
| `code-review` | **Yes** — `/code-review` | Renamed to `irega-code-review` |
| `security-audit` | No (built-in is `security-review`) | Kept as-is |
| `staff-review`, `tdd`, `pr-description`, `planning` | No | Kept as-is |

**Rule for new skills:** before naming a skill, check it against Claude Code's built-in skill list. On any collision, prefix with `irega-`.
