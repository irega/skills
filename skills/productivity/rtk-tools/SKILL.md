---
name: rtk-tools
description: >
  Route all file reading and searching through RTK (Rust Token Killer) to maximize token savings.
  RTK hooks only into Bash tool calls — built-in Claude Code tools (Read, Grep, Glob) bypass it.
  Use when RTK is installed, token efficiency matters, or user invokes /rtk-tools.
  Replaces: Read → rtk cat / cat, Grep → rtk grep / rg, Glob → rtk find / find.
---

# RTK Tools

**Prerequisite:** `brew install rtk`

RTK proxy only intercepts Bash tool calls. Built-in tools (Read, Grep, Glob) bypass the hook — no token savings.

**Rule: never use Read, Grep, or Glob built-in tools. Use shell or RTK equivalents instead.**

## Replacements

| Built-in | Use instead |
|----------|-------------|
| `Read` | `rtk cat <file>` or `cat <file>` |
| `Grep` | `rtk grep <pattern> <path>` or `rg <pattern> <path>` |
| `Glob` | `rtk find <path> -name <pattern>` or `find <path> -name <pattern>` |

## RTK commands

```bash
rtk cat <file>              # Read file (token-optimized output)
rtk grep <pattern> <path>   # Search content
rtk find <path> -name <pat> # Find files
rtk gain                    # Show token savings
```

## Persistence

Active every response. No revert unless user says "stop rtk-tools" or "use built-in tools".
