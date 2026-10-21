---
name: frontend-audit
description: >
  Audit a frontend codebase for stack-specific best-practice violations, then fix
  them after the user approves a plan. Detects the stack and audits only what is
  present. Use when the user runs /frontend-audit, or asks to audit, review, or
  improve their React, Next.js, React Native, Tailwind, NativeWind, shadcn/ui, or
  Legend State code for best practices. Optional arg scopes to one module, e.g.
  /frontend-audit legend-state. Add --git-review to also draft paste-ready PR
  review comments, defaulting to the current PR diff.
---

# Frontend Audit

Fingerprint the codebase, audit only the stacks actually present, then fix after the user approves a plan.

The audit is **composable**: a codebase is not one label but a combination of independent axes (platform, framework/build, styling, component lib, state). Detect each axis, load the union of matching checklist modules, and report only what is in the code.

## Invocation

```text
/frontend-audit                          # normal audit, scope picker, fix plan
/frontend-audit legend-state             # audit only this module
/frontend-audit --git-review             # audit the PR diff and draft review comments
/frontend-audit legend-state --git-review # combine module filter and comment output
/frontend-audit --git-review staged changes # explicitly override the PR scope
```

Treat `--git-review` as an output mode, not a checklist module. It adds a **Git review comments** section to the normal findings, priority matrix, and fix plan. Read [git-review.md](git-review.md) only when this flag is present or the user explicitly requests paste-ready review comments. Draft comments only; posting or submitting a review requires a separate explicit request. The flag does not authorize code edits.

## Workflow

### Step 1 — Fingerprint, per package

Find every package in the repo (each `package.json`; a repo with several is a monorepo). For each, read deps and config files and resolve its axes using the rules in [detection.md](detection.md).

A vanilla HTML/CSS/JS site has no `package.json` — detect it by `.html` files with no framework dependency.

**Done when:** every package has a fingerprint — a list of detected axis values, each mapped to its checklist module(s).

### Step 2 — Confirm the fingerprint

Print what was detected and stop for confirmation before reading any checklist:

> Detected in `apps/web`: **Next.js (App Router)**, **Tailwind**, **shadcn/ui**, **Legend State**. Auditing these. Correct? Anything to add or drop?

In a monorepo, list each package and ask which to audit. Do not proceed on a guess — a misread stack wastes the whole review.

**Done when:** the user has confirmed (or corrected) the fingerprint and chosen the package(s).

### Step 3 — Pick scope

Ask which slice of the chosen package(s) to audit:

- **Current PR** — resolve the target branch as described below, then use `git diff "$audit_base"...HEAD --name-only` with `audit_base` set to that ref
- **Staged changes** — `git diff --staged --name-only`
- **Whole package** — all source files under the package, ignoring `node_modules`, `.next`, `dist`, `build`, `.git`, `public`, generated/lockfiles

Honor a scope already supplied by the user without asking again. With `--git-review`, default to **Current PR** unless the user explicitly chooses another scope. Resolve the actual PR target branch from available PR metadata or the user's supplied base; use `origin/HEAD` only as a fallback when no target is known. If the base cannot be resolved, ask for it instead of guessing. Record the base and reviewed HEAD. For staged changes, record that the index is the reviewed version.

**Done when:** the in-scope file list is fixed.

### Step 4 — Load the matched modules

Read only the checklist files the fingerprint matched (see [detection.md](detection.md) for the map). Skip every module whose axis is absent — a repo with no Legend State never opens `legend-state.md`.

### Step 5 — Review

Apply every check in the loaded modules to the in-scope files. **Read actual file contents — never guess.** Cite exact `file:line`. If a pattern is not in the code, do not report it. Flag every instance, not just the first.

With `--git-review`, also inspect the actual diff and relevant surrounding code using [git-review.md](git-review.md). A changed-file list alone cannot establish whether a finding belongs in a PR comment.

**Done when:** every loaded module's checks have been applied to every in-scope file.

### Step 6 — Plan, then wait for approval

Report findings in the **Output format** below, then the **Priority matrix**, then a concrete fix plan. Present the plan and **wait for explicit approval** before editing anything.

With `--git-review`, append **Git review comments** after the fix plan, using [git-review.md](git-review.md). Produce the complete report and comment drafts before waiting for approval to fix anything.

### Step 7 — Fix, then verify

After approval, apply the fixes. Then verify per package: run its typecheck / lint / build (e.g. `tsc --noEmit`, the lint script, `next build`) and confirm the changes hold. Report what passed and what didn't — do not claim done on an unverified fix.

## Output format

Group findings under three headings, **per stack module**:

- **❌ Missing entirely** — a practice the stack expects that is absent
- **⚠️ Used incorrectly or suboptimally** — present but wrong
- **✅ Quick wins** — highest impact, lowest effort

For each finding: exact `file:line`, the current pattern, and the corrected pattern side by side.

## Priority matrix

Close with a table ranking the top 10 findings by impact ÷ effort, and mark the top 3 "fix these first":

| # | Issue | File | Impact | Effort | Fix |
|---|-------|------|--------|--------|-----|
| 1 | … | `path:line` | High | Low | … |
