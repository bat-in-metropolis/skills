# skills

Personal Claude Code skills. Each skill solves a specific friction point in my engineering workflow.

## Install

Clone the repo and run `make install`:

```bash
git clone https://github.com/bat-in-metropolis/skills.git ~/.skills
cd ~/.skills
make install
```

This symlinks each skill directory into `~/.claude/skills/` — the location Claude Code auto-discovers user-level slash commands. The skills become available immediately as `/git-commit-message` and `/work-log` across every repo on your machine.

To update all skills:

```bash
cd ~/.skills && make update
```

To remove:

```bash
cd ~/.skills && make uninstall
```

---

## Skills

### `/frontend-audit`

Audits a frontend codebase for stack-specific best-practice violations, then fixes
them after you approve a plan. It fingerprints the repo along orthogonal axes
(platform, framework/build, styling, component lib, state) and audits **only what's
present** — so the same skill covers Next.js (App + Pages Router), React on Vite or
webpack/CRA, React Native/Expo, and plain HTML/CSS/JS, plus Tailwind, NativeWind,
shadcn/ui, and Legend State.

**When to use**: Before raising a PR, or when onboarding to / cleaning up a codebase.

```
/frontend-audit                # detect stack, confirm, pick scope (PR/staged/repo), review → plan → fix
/frontend-audit legend-state   # scope the audit to one module
```

The flow: detect (per package, monorepo-aware) → confirm the fingerprint → pick scope
→ review → present plan → **wait for approval** → fix → verify. Checklist modules live
in `frontend-audit/checklists/` and load on demand; detection rules are in
`frontend-audit/detection.md`.

---

### `/work-log`

Interviews you about the branch you just finished, then generates:
- A structured PR description (ready to paste into GitHub)
- A Google Sheet row for your career log (with STAR stories for significant tasks)

**When to use**: Right before raising a PR, while context is fresh.

```
/work-log          # Claude asks if it's a routine or significant task
/work-log quick    # Skip routing — 3 questions only
/work-log deep     # Skip routing — full 7-question interview
```

---

### `/git-commit-message`

Generates a conventional commit message from your staged diff.
Works across all stacks: React, Node, Go, Python, Terraform, Docker, K8s, and more.

**When to use**: After staging changes, before running `git commit`.

```
/git-commit-message        # full output with 2 alternates
/git-commit-message short  # subject line only
```

---

## Philosophy

Each skill here solves something I hit repeatedly. Small, composable, easy to adapt.
Inspired by [mattpocock/skills](https://github.com/mattpocock/skills).
