# Work Log — Examples

## Example 1 — Normal Task

### What Claude read from the branch
```
Branch: feature/user-list-pagination
Commits: 3 commits
Files changed: api/users.js, api/users.test.js, docs/api.md
```

### Interview
- **Q1**: Added cursor-based pagination to the GET /users endpoint
- **Q2**: Had to check how another endpoint handled it — spent 30 mins reading old code
- **Q3**: On time

---

### PR Description

```
## What changed
Added cursor-based pagination to the GET /users endpoint.
Returns 20 results per page by default, configurable up to 100 via `?limit=`.

## Why
The user list was timing out for accounts with 5,000+ users.
Part of the Q2 performance sprint (ticket #1204).

## How
Used cursor-based pagination (last seen user ID) rather than offset pagination
to avoid performance degradation at large offsets.

## Testing
Tested against a seeded dataset of 10,000 users.
Response time: 4.2s → 80ms. All existing tests passing.

## Impact
User list endpoint no longer times out for large accounts.
```

---

### Google Sheet Row
*(tab-separated — paste directly)*

```
2025-03-12	api-service	Pagination for user list endpoint	Feature	Normal	Added cursor-based pagination to GET /users	—	—	—	On time	Endpoint no longer times out for large accounts	—
```

---

---

## Example 2 — Special Task

### What Claude read from the branch
```
Branch: fix/checkout-race-condition
Commits: 11 commits
Files changed: services/checkout.js, services/lock.js (new), infra/redis.js, tests/load/checkout.k6.js (new)
```

### Interview
- **Q1**: Debugged and fixed a race condition in checkout that was creating duplicate orders under concurrent load
- **Q2**: The bug only reproduced under concurrent requests — completely invisible in local dev
- **Q3**: Added distributed locking using Redis SET NX EX before the order creation step, scoped per cart ID
- **Q4**: Learned how Redis atomic locking works and how to use k6 to reproduce concurrency bugs in staging
- **Q5**: Delayed by 3 days — most of it spent building the load test infra to reproduce the bug reliably
- **Q6**: Would instrument the checkout flow with distributed tracing from day one — would have found this in an hour not three days
- **Q7**: Duplicate orders dropped to zero. Saved roughly ₹2L/month in manual refunds.

---

### PR Description

```
## What changed
Fixed a race condition in the checkout flow that was generating duplicate orders
under concurrent load.

## Why
Customers were occasionally seeing two order confirmations for a single checkout.
Happening ~15 times/day during peak traffic. Each duplicate required manual
intervention from support.

## How
Added distributed locking via Redis SET NX EX before the order creation step.
Lock is scoped per cart ID and expires after 5s to prevent deadlocks on failures.

## Challenges
The bug was invisible in local dev — only reproduced under concurrent requests.
Had to build a k6 load testing setup from scratch to reproduce it reliably in
staging before I could even start debugging the root cause.

## Testing
500 concurrent checkout requests in staging: 0 duplicate orders.
Previously: ~8% duplication rate at that concurrency level.

## Impact
Duplicate orders dropped to zero in production.
Estimated ₹2L/month in refund processing costs eliminated.
Support team no longer manually resolving duplicate order tickets.
```

---

### Google Sheet Row
*(tab-separated — paste directly)*

```
2025-04-01	checkout-service	Fix race condition causing duplicate orders	Bug	Special	Redis distributed lock on cart ID at checkout	Bug only reproduced under concurrent load — invisible locally	Built k6 load tests to reproduce, then added Redis SET NX EX lock scoped per cart ID	How Redis atomic locking works; how to reproduce concurrency bugs with load testing	Delayed 3 days — building reproduce infra took most of the time	Duplicate orders → zero; ~₹2L/month in refund costs eliminated	See STAR story below
```

---

### STAR Story

**Situation**: Our checkout service was generating duplicate orders for roughly 15 customers per day during peak traffic. Each case required manual refund processing by the support team, costing the business an estimated ₹2L/month and eroding customer trust.

**Task**: Identify the root cause of the duplication and fix it without introducing new latency into an already performance-sensitive checkout flow.

**Action**: The bug was completely invisible in local development — it only appeared under concurrent requests. I built a k6 load testing setup from scratch to reproduce it reliably in staging. Once I could reproduce it consistently, I traced the issue to a missing lock between the cart read and order write steps. I implemented Redis distributed locking using SET NX EX, scoped per cart ID with a 5-second TTL to prevent deadlocks if a request failed mid-checkout.

**Result**: Duplicate orders dropped to zero in production immediately after the fix. The ₹2L/month in refund processing was eliminated, and the support team's duplicate order queue went from ~15 tickets/day to zero. The k6 load testing setup I built during debugging became the foundation for our checkout performance test suite.
