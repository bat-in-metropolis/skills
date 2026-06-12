---
name: work-log
description: Interview an engineer about work they just completed on the current git branch, then generate a structured PR description and a Google Sheet career log entry including STAR-format stories for significant tasks. Use when the user types /work-log, finishes a feature branch, or wants to document their engineering work for career memory and interview prep.
---

# Work Log

## Quick Start

Run `/work-log` when your branch is ready to raise as a PR.
Claude reads the branch diff automatically — no link pasting needed.

Optional flags:
- `/work-log quick` — skip routing, go straight to 3-question mode
- `/work-log deep` — skip routing, go straight to 7-question mode

## Workflow

### Step 1 — Read the branch context

Run these commands silently before saying anything:

```bash
git branch --show-current
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null || echo "refs/remotes/origin/main"
git log $(git symbolic-ref refs/remotes/origin/HEAD | sed 's|refs/remotes/origin/||')...HEAD --oneline
git diff $(git symbolic-ref refs/remotes/origin/HEAD | sed 's|refs/remotes/origin/||')...HEAD --stat
```

### Step 2 — Route the session

Unless a flag was passed, ask exactly this question first:

> "Was this a **routine task** (normal dev work) or did it involve **significant challenge, learning, or a story worth remembering**?"

- Routine → **Normal mode** (3 questions)
- Significant → **Special mode** (7 questions)

See [REFERENCE.md](REFERENCE.md) for the full question sets.

### Step 3 — Run the interview

Ask questions **one at a time**. Wait for each answer before asking the next.
Do not ask all questions at once.

### Step 4 — Generate both outputs

Once the interview is complete, generate:

1. **PR Description** — formatted, ready to paste into GitHub
2. **Google Sheet Row** — tab-separated, ready to paste into career log

For Special mode, also generate a **STAR story** as the last column.

See [REFERENCE.md](REFERENCE.md) for templates and column definitions.
See [EXAMPLES.md](EXAMPLES.md) for complete finished examples.
