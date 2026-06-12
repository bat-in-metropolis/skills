# Git Commit Message Examples by Stack

Reference examples for stack-specific commit phrasing. See `SKILL.md` for the rules.

---

**React / Frontend**
```
feat(auth): add OTP verification screen

- add OTP input component with auto-focus
- wire to /auth/verify endpoint
- handle invalid/expired code error states
```

**Next.js**
```
feat(checkout): add address autocomplete with Google Places

- integrate Places API in AddressForm component
- debounce input to reduce API calls
- handle API quota error gracefully
```

**Node / NestJS**
```
feat(api): add invoice export endpoint

- add GET /invoices/:id/export route
- generate PDF using pdfkit
- restrict to admin and owner roles
```

**Java / Spring Boot**
```
feat(auth): add password reset endpoint

- add POST /auth/reset-password route
- send reset link via email service
- expire token after 15 minutes
```

```
fix(user): prevent null pointer in profile update

- guard against null displayName in UserService
- add unit test for empty profile payload
```

**Go**
```
fix(payment): handle retry on gateway timeout

- catch timeout error from Stripe client
- retry up to 3 times with exponential backoff
```

```
refactor(server): simplify middleware registration

- extract middleware chain into dedicated builder
- remove duplicated auth middleware calls
```

**Python**
```
refactor(worker): simplify queue retry logic

- replace manual retry loop with tenacity decorator
- reduce retry boilerplate across 4 worker functions
```

**Terraform**
```
feat(infra): add ALB target group for api service

- define aws_lb_target_group for ECS api tasks
- attach to existing ALB listener on port 443
```

**Docker**
```
build(docker): optimize multi-stage image

- switch to alpine base in final stage
- remove dev dependencies from production image
- reduce image size by ~180MB
```

**GitHub Actions**
```
ci: add deployment workflow for staging

- trigger on push to main
- deploy to ECS via aws-actions/amazon-ecs-deploy-task-definition
- notify Slack on failure
```

**Kubernetes**
```
fix(k8s): update readiness probe for payments service

- increase initialDelaySeconds from 5 to 15
- fixes premature pod termination under cold start
```

**Cybersecurity**
```
fix(auth): enforce token expiry validation

- add expiry check before processing refresh tokens
- return 401 on expired tokens instead of silently ignoring
```

```
fix(security): sanitize user-supplied headers

- strip X-Forwarded-For before passing to logger
- prevent log injection via crafted header values
```

```
fix(deps): upgrade openssl to patched version

- resolves CVE-2024-XXXX
- update lockfile
```

```
chore(security): rotate IAM policy permissions

- remove wildcard s3:* from lambda execution role
- scope to specific bucket ARNs
```

**Bash / Scripting**
```
feat(script): add backup cleanup automation

- delete backups older than 30 days
- log deleted files to /var/log/backup-cleanup.log
```

**Docs**
```
docs(readme): update local setup instructions

- add missing .env.example setup step
- fix outdated Docker Compose command
```

**Monorepo**
```
feat(api): add invoice export endpoint

- scoped to services/api changes only
```

If diff spans multiple apps with no clear primary:
> "Changes span multiple packages. Consider splitting by package."
