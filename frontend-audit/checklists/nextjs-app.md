# Next.js — App Router

## Server vs Client boundary

- **`'use client'` overuse** — list every file using it and whether it's justified. A component that only renders data needs no client directive.
- **Data passed server→client as props** when the client component could be a server component, or when a server component could fetch directly.
- **Client components at the leaves** — push `'use client'` down the tree; keep layouts/pages as server components.

## Data fetching

- Server components use `async`/`await` directly.
- **`Promise.all()`** for independent fetches — flag sequential `await` waterfalls.
- **`cache()`** (React `cache`) to dedupe fetches across the render tree.
- `fetch()` caching is deliberate: `next: { revalidate }`, tags, or `cache` set where the default is wrong. Defaults differ by version — Next 14 caches `fetch` by default, Next 15+ does not. Check the installed version before claiming data is stale or uncached.

## Mutations

- **Server Actions** for forms and mutations — a **Suggestion**, not a requirement.
- **`/api/*` routes** — suggest a Server Action only when the route is called solely by this app's own forms/components. Routes used by external clients, webhooks, mobile apps, file downloads, or a separate backend are correct as routes; don't report them.
- `useFormStatus` / `useActionState` for pending and error states. A mutation with no pending/error handling at all is a correctness finding (`correctness.md`), not a Server Actions finding.

## Streaming & Suspense

- `<Suspense>` around async sections so data doesn't block the whole page.
- `loading.tsx` per route for automatic Suspense boundaries.
- `error.tsx` per route for error boundaries.
- `not-found.tsx` where applicable.

## SEO & metadata

- `generateMetadata()` for dynamic per-page metadata; `metadata` export for static.
- **`next/image`** — a raw `<img>` is an **Issue** only with a consequence: an above-the-fold/LCP image, a large unoptimized asset, or no dimensions causing layout shift. Otherwise a Suggestion. Skip small icons/SVGs, data/blob URLs, and remote hosts not configured in `images.remotePatterns` where adding them isn't wanted.
- **`next/font`** — flag `@import` or `<link>` font loading.

## Routing

- **Route Groups** `(folder)` to organize layouts without affecting URLs — Suggestion.
- **Parallel / Intercepting Routes** where they'd help (modals, dashboards) — Suggestion.
- **`middleware.ts`** (`proxy.ts` on Next 16+) for auth guards, redirects, locale. An unguarded protected route is an Issue; where the guard lives is a Suggestion.

## Performance

- `generateStaticParams` for dynamic static routes.
- `dynamic = 'force-static' | 'force-dynamic'` set where the default is wrong.
