# Correctness (all stacks)

Always loaded. These are behavior bugs, not style — they apply whatever the framework, styling, or state library. Most findings here are **Issues** when the trigger is reachable in the code; state the trigger (what the user does, or what the network does) and the visible consequence.

If the project uses a data layer that already handles a concern (React Query/SWR keys and cancellation, Legend `synced`, Server Actions with `useActionState`), check that it is actually used on the path in question before flagging — and do not flag the concern where it is handled.

## Async races

- **Out-of-order responses** — search, filters, pagination, tab or route switches that fire overlapping requests. An older response that resolves last overwrites newer results. Look for latest-wins handling: `AbortController`, a request id/ref check, or a query library keyed on the inputs.
- **Responses after unmount or after the inputs changed** — the effect starts a request but has no cleanup that aborts it or ignores its result.

## Stale closures

- Intervals, timeouts, event listeners, and subscriptions that capture state or props from the render that created them and keep reading old values.
- State updates computed from the previous value written as `setX(x + 1)` inside async code or repeated calls — use the updater form `setX(prev => …)`.
- Callbacks memoized with missing deps (`useCallback`/`useMemo`/`useEffect`) that read stale values. Lint suppressions (`eslint-disable`, `biome-ignore`) on hook deps are a lead, not proof — confirm a stale read.

## Cleanup

- Every effect that subscribes, listens, polls, opens a socket, or starts an observer returns a cleanup that undoes it.
- Object URLs (`URL.createObjectURL`) revoked; timers cleared.

## Failed requests

- Rejected promises are caught somewhere the user can see — no silent `catch {}`, no unhandled rejection.
- Loading flags reset in `finally` (or equivalent) — a failed request must not leave a spinner running forever.
- Non-2xx responses handled: `fetch` does **not** throw on 4xx/5xx; axios does. Check which one is in use.
- Auth expiry (401/403) routed to the app's existing handling, not swallowed as a generic error.

## Duplicate submissions

- Submit buttons and mutation triggers disabled or guarded while a request is in flight — including Enter-key and double-click paths.
- Retries of non-idempotent mutations don't create duplicates.

## Loading, error, and empty states

- Every view backed by async data renders all three, and keeps them distinct — an error must not render as "No results".
- Falsy-number rendering: `{count && <X/>}` renders `0`. Use `count > 0`.

## Optimistic updates

- Optimistic UI rolls back (or refetches) when the mutation fails, and reconciles with the server response when it succeeds.

## Derived UI state

- Changing a filter or search resets pagination/selection that no longer applies.
- Selection or form state keyed to an id is cleared or re-validated when the underlying list changes.
