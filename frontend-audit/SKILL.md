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

**Every finding earns its place.** A checklist item tells you what to look for; it is not a verdict. A finding needs evidence from the code (see **Finding format**). No demonstrated consequence → it is at most a Suggestion. No evidence at all → it is not reported.

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

For each package also record:

- **Installed versions** of the detected libraries — from the lockfile or `node_modules/<pkg>/package.json`, not the `package.json` range. Checklist rules marked with a version apply only to that version.
- **Project conventions** — lint/format tool and its scripts, data-fetching layer, existing shared helpers (`cn()`, API client, form components), and whether a test runner and test files exist. A pattern the repo uses consistently and deliberately is a convention, not a finding, unless it causes a concrete problem.

**Done when:** every package has a fingerprint — detected axis values with versions, each mapped to its checklist module(s), plus its conventions.

### Step 2 — Confirm only what is ambiguous

Print the fingerprint:

> Detected in `apps/web`: **Next.js 15 (App Router)**, **Tailwind 4**, **shadcn/ui**, **Legend State 3**. Auditing these.

Then **proceed without asking** when it is a single package with unambiguous signals, or the invocation already names the package, module, or scope. Stop and ask only when the answer would change the review:

- several packages and none named — list them and ask which to audit;
- conflicting signals — App and Pages routers together, two component libraries, a dependency with no usage, a named module whose axis was not detected.

**Done when:** the package(s) and modules are fixed, by detection or by the user.

### Step 3 — Pick scope

Ask which slice of the chosen package(s) to audit:

- **Current PR** — resolve the target branch as described below, then use `git diff "$audit_base"...HEAD --name-only` with `audit_base` set to that ref
- **Staged changes** — `git diff --staged --name-only`
- **Whole package** — all source files under the package, ignoring `node_modules`, `.next`, `dist`, `build`, `.git`, `public`, generated/lockfiles

Honor a scope already supplied by the user without asking again. With `--git-review`, default to **Current PR** unless the user explicitly chooses another scope. Resolve the actual PR target branch from available PR metadata or the user's supplied base; use `origin/HEAD` only as a fallback when no target is known. If the base cannot be resolved, ask for it instead of guessing. Record the base and reviewed HEAD. For staged changes, record that the index is the reviewed version.

**Done when:** the in-scope file list is fixed.

### Step 4 — Load the matched modules

Always read [checklists/correctness.md](checklists/correctness.md) — it is stack-agnostic, even when a module arg narrows the rest. Then read only the checklist files the fingerprint matched (see [detection.md](detection.md) for the map). Skip every module whose axis is absent — a repo with no Legend State never opens `legend-state.md`.

### Step 5 — Review

Apply every check in the loaded modules to the in-scope files. **Read actual file contents — never guess.** Cite exact `file:line`. If a pattern is not in the code, do not report it. Flag every instance, not just the first.

- **Trace beyond the lines.** When a finding or a changed line touches an exported component, hook, type, or API call, read its callers and consumers and the contract it relies on (props, types, response shape). A locally fine change that breaks another screen is an Issue on the change.
- **Check version and convention** before reporting a rule (Step 1). A rule written for another major version does not apply.
- **Unverified ≠ reported as fact.** If a potentially serious problem cannot be confirmed from the code (needs runtime data, backend behavior, or a version you couldn't read), report it with **Confidence: Needs verification** and say what would confirm it.

With `--git-review`, also inspect the actual diff and relevant surrounding code using [git-review.md](git-review.md). A changed-file list alone cannot establish whether a finding belongs in a PR comment.

**Done when:** every loaded module's checks have been applied to every in-scope file.

### Step 6 — Plan, then wait for approval

Report findings in the **Output format** below, then the **Priority matrix**, then a concrete fix plan. Present the plan and **wait for explicit approval** before editing anything.

Each fix in the plan names how it will be checked:

- **Tests exist** for the area → the specific scenario a test should cover, e.g. "an older search response cannot overwrite newer results". Never a generic "add tests".
- **No tests** (the common case) → the same scenario as a manual check: the steps to reproduce the bug before the fix and confirm it is gone after.

With `--git-review`, append **Git review comments** after the fix plan, using [git-review.md](git-review.md). Produce the complete report and comment drafts before waiting for approval to fix anything.

### Step 7 — Fix, then verify

After approval, apply the fixes. Before changing the props, types, or behavior of anything exported, find every consumer and update or confirm each one.

Then verify per package: run its typecheck / lint / build (e.g. `tsc --noEmit`, the lint script, `next build`) and confirm the changes hold. Use the **non-writing** form of lint/format commands — drop `--write`/`--fix` (e.g. `biome check` not `biome check --write`) so verification doesn't rewrite unrelated files. Typecheck/lint/build don't catch behavior bugs: list the manual checks from the plan for the user to run, or run the named tests if they exist. Report what passed and what didn't — do not claim done on an unverified fix.

## Finding format

Every finding carries:

- **Label**
  - **Issue** — a demonstrated problem: a bug, regression, security or accessibility failure, or a measurable performance cost. Add **Severity**: High / Medium / Low.
  - **Convention** — this org's or this repo's stated policy (e.g. Legend State's "use both pillars") is not followed, with no demonstrated failure. Becomes an Issue only when the code shows a concrete consequence.
  - **Suggestion** — an architectural or maintainability improvement. Never presented as required.
- **Confidence** — **Verified** (traced in the code) or **Needs verification** (what would confirm it). Kept separate from severity: a High-severity issue can still need verification.
- **Evidence** — `file:line`, then:
  - **Trigger** — when it happens (user action, data shape, network timing, version).
  - **Observed** — what the code does now (quote the pattern).
  - **Consequence** — what goes wrong or what is lost. Suggestions state the specific benefit instead.
  - **Fix** — the corrected pattern, side by side with the current one.

"Missing `useMemo`" without a consumer whose re-render is shown to matter is not a finding.

## Output format

Group findings **per stack module** (correctness first), and within each module by label: **Issues** (by severity), then **Conventions**, then **Suggestions**. List **Needs verification** findings under their label but mark them clearly. Consolidate identical instances (same cause, same fix) into one finding with all locations.

## Priority matrix

Close with a table ranking the top 10 findings by impact ÷ effort, and mark the top 3 "fix these first". Verified Issues rank above Conventions and Suggestions of similar effort:

| # | Issue | Label | Confidence | File | Impact | Effort | Fix |
|---|-------|-------|------------|------|--------|--------|-----|
| 1 | … | Issue (High) | Verified | `path:line` | High | Low | … |
