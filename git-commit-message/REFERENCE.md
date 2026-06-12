# Git Commit Message — Reference

Detailed rules for type selection, scope detection, breaking changes, and quality checks.

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

## Quality Check

Run internally before outputting:

- [ ] Subject line ≤ 72 characters
- [ ] Imperative mood used
- [ ] Scope reflects actual area changed, not generic label
- [ ] Type is accurate — not everything is `feat`
- [ ] Bullets are specific
- [ ] Breaking change marked if applicable
- [ ] Scope matches domain (infra → `ci`/`docker`/`k8s`, not `api`)

---

## Language + Domain Support

**Frontend:** React · Next.js · Vue · Angular · Svelte  
**Backend:** Node.js · NestJS · Java/Spring Boot · Go · Python · Ruby · PHP  
**Infra/DevOps:** Docker · Terraform · Kubernetes · GitHub Actions · GitLab CI  
**Security:** auth hardening · dependency patches · IAM · TLS · input sanitization  
**Scripting:** Bash · Python automation · CLI tools · Makefiles  
**Mobile:** React Native · Flutter · Swift · Kotlin  
**Data/ML:** pipelines · ETL · model training · notebooks  

Use file paths and diff intent to infer scope.
Never assume language-specific conventions unless visible in staged changes.
