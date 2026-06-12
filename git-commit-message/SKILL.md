---
name: git-commit-message
description: >
  Generate conventional git commit messages from staged changes.
  Trigger when user runs /git-commit-message, or says "commit message",
  "commit msg", "suggest commit", or "what should I commit".
  Designed for Claude Code — automatically runs git diff --staged.
  Always use this skill for any commit message generation task.
compatibility: "Requires bash tool. Designed for Claude Code and terminal agents."
---

# Git Commit Message

Generate conventional commit messages from staged diffs.
Works across all stacks: frontend, backend, infra, security, mobile, data, scripting.

---

## Trigger

```
/git-commit-message
```

Also activates on: "commit message", "commit msg", "suggest commit", "what should I commit"

---

## Diff Source

**Preferred:** Run automatically:
```bash
git diff --staged
```

**Fallback (in order):**
1. Diff pasted by user
2. List of staged files provided by user

**If diff is empty:**
> "No staged changes found. Run `git add <files>` first, then try again."
Stop. Do not proceed.

**Platform compatibility:** Claude Code · Codex CLI · terminal agents · IDE AI assistants

---

## Type Rules

| Type | Use when |
|---|---|
| `feat` | New functionality added |
| `fix` | Bug fixed |
| `refactor` | Internal restructuring, no behavior change |
| `perf` | Performance improvement |
| `docs` | Documentation only |
| `test` | Tests only |
| `build` | Build tooling, package manager |
| `ci` | CI/CD changes |
| `style` | Formatting only, no logic |
| `chore` | Maintenance, no production code |

**Priority when overlap exists:**
```
fix > refactor
feat > refactor
perf > refactor
```

If a change both fixes a bug AND refactors — use `fix`.
If a change adds a feature AND refactors — use `feat`.

---

## Scope Detection

Infer scope from changed file paths:

| File path pattern | Scope |
|---|---|
| `src/components/`, `*.tsx`, `*.vue` | `ui` |
| `src/screens/`, `pages/` | `auth`, `dashboard`, `cart` (by screen name) |
| `api/`, `controllers/`, `routes/` | `api` |
| `services/`, `src/services/` | service name (e.g. `payment`) |
| `.github/workflows/` | `ci` |
| `package.json`, `pnpm-lock`, `yarn.lock` | `build` or `deps` |
| `Dockerfile`, `docker-compose*` | `docker` |
| `*.tf`, `infra/` | `infra` |
| `k8s/`, `*.yaml` in deploy dirs | `k8s` |
| `migrations/`, `schema.prisma`, `*.sql` | `db` |
| `auth/`, `middleware/`, `guards/` | `auth` |
| `iam/`, `certs/`, `*.pem` | `security` |
| `docs/`, `*.md`, `README*` | `docs` |
| `scripts/`, `*.sh`, `Makefile` | `script` or `cli` |
| `apps/web/` (monorepo) | `web` |
| `services/api/` (monorepo) | `api` |

**If multiple unrelated scopes:** omit scope entirely.

**Examples:**
```
feat(auth):
fix(ui):
ci:
chore(deps):
```

---

## Breaking Changes

If the diff changes a public API, renames an endpoint, removes an export, or requires a migration:

```
feat(api)!: rename customer endpoint

BREAKING CHANGE: `/customer` replaced with `/customers`
Update all API consumers before deploying.
```

Signals to look for in diff:
- Renamed or removed exported functions/classes
- Changed HTTP method or route path
- Removed or renamed env variables
- Schema column renames or deletions
- Changed function signatures in shared packages

---

## Mixed Changes

If diff contains multiple concerns:

| Mixed types | Use |
|---|---|
| feature + docs | `feat` |
| fix + formatting | `fix` |
| refactor + tests | `refactor` |
| fix + tests | `fix` |

If changes are **truly unrelated** (e.g. auth logic + unrelated UI styling):
> "These changes touch unrelated concerns. Consider splitting into separate commits:"
> 1. `fix(auth): ...`
> 2. `style(ui): ...`
> Run `git add -p` to stage selectively.

**Monorepo rule:** If diff spans multiple packages/apps, prefer the most user-facing change as the scope. If infra-only, use `ci`, `build`, or `infra`.

---

## Ask Questions Only If

Ask the user **only** when:
- `fix` vs `refactor` is genuinely unclear from the diff
- Multiple truly unrelated changes present (suggest split)
- Breaking change is uncertain

**Otherwise infer automatically.** Do not ask for confirmation on obvious changes.

---

## Output Format

Return **exactly** in this order:

```
<type>(<scope>): <imperative summary, max 72 chars>

- bullet explaining major change 1
- bullet explaining major change 2
- bullet explaining major change 3 (if needed)
```

**Rules:**
- Subject line: imperative mood (`add`, `fix`, `remove` — not `added`, `fixed`)
- No period at end of subject line
- Blank line between subject and bullets
- Bullets: specific, not vague ("add retry logic" not "update stuff")
- Breaking change: append `!` to type/scope + `BREAKING CHANGE:` after bullets

**Short mode** — if user says `"short"` or `"one line"`:
```
fix(auth): prevent duplicate login requests
```
No bullets. Subject line only.

---

## Quality Check (run internally before output)

- [ ] Subject line ≤ 72 characters
- [ ] Imperative mood used
- [ ] Scope reflects actual area changed, not generic label
- [ ] Type is accurate — not everything is `feat`
- [ ] Bullets are specific
- [ ] Breaking change marked if applicable
- [ ] Scope matches domain (infra → `ci`/`docker`/`k8s`, not `api`)

---

## Alternates

Always offer **2 alternates** after the primary:

```
Alternates:
1. fix(auth): handle token expiry edge case
2. refactor(auth): simplify token validation flow
```

---

## Language + Domain Support

Works across all of:

**Frontend:** React · Next.js · Vue · Angular · Svelte  
**Backend:** Node.js · NestJS · Java/Spring Boot · Go · Python · Ruby · PHP  
**Infra/DevOps:** Docker · Terraform · Kubernetes · GitHub Actions · GitLab CI  
**Security:** auth hardening · dependency patches · IAM · TLS · input sanitization  
**Scripting:** Bash · Python automation · CLI tools · Makefiles  
**Mobile:** React Native · Flutter · Swift · Kotlin  
**Data/ML:** pipelines · ETL · model training · notebooks  

Use file paths and diff intent to infer scope.
Never assume language-specific conventions unless visible in staged changes.

---

## Examples

Per-stack commit examples (React, Next.js, Node, Go, Python, Terraform, Docker,
K8s, GitHub Actions, Security, Bash, Docs, Monorepo) live in `EXAMPLES.md`.

Consult `EXAMPLES.md` only if the diff's stack-specific phrasing is unclear from
the rules above. The rules cover 95% of cases — examples are reference material,
not required reading.
