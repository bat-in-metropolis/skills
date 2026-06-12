---
name: git-commit-message
description: >
  Generate conventional git commit messages from staged changes.
  Use when user runs /git-commit-message, or says "commit message",
  "commit msg", "suggest commit", or "what should I commit".
  Always use this skill for any commit message generation task.
---

# Git Commit Message

Generate conventional commit messages from staged diffs across all stacks.

## Quick Start

Run automatically:
```bash
git diff --staged
```

If the diff is empty: `"No staged changes found. Run git add <files> first."` — stop here.

## Workflow

1. **Read staged diff** — run `git diff --staged` automatically
2. **Infer type and scope** — see [REFERENCE.md](REFERENCE.md) for rules
3. **Check for breaking changes** — renamed exports, route changes, removed env vars
4. **Output message** in the format below
5. **Always offer 2 alternates** after the primary

**Ask questions only when:** fix vs. refactor is genuinely ambiguous, changes are truly unrelated, or breaking change status is uncertain. Otherwise infer automatically.

## Output Format

```
<type>(<scope>): <imperative summary, max 72 chars>

- bullet explaining major change 1
- bullet explaining major change 2
```

- Subject line: imperative mood (`add`, `fix`, `remove`) — no period at end
- Blank line between subject and bullets
- Breaking change: append `!` to type + `BREAKING CHANGE:` footer after bullets
- **Short mode** (user says "short" or "one line"): subject line only, no bullets

## Advanced Features

See [REFERENCE.md](REFERENCE.md) for: type rules, scope detection, breaking changes, mixed changes, quality checklist, and language/domain support.

See [EXAMPLES.md](EXAMPLES.md) for per-stack examples (React, Next.js, Node, Go, Python, Terraform, Docker, K8s, and more).
