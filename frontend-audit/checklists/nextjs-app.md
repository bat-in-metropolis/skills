# Next.js — App Router

## Server vs Client boundary

- **`'use client'` overuse** — list every file using it and whether it's justified. A component that only renders data needs no client directive.
- **Data passed server→client as props** when the client component could be a server component, or when a server component could fetch directly.
- **Client components at the leaves** — push `'use client'` down the tree; keep layouts/pages as server components.

## Data fetching

- Server components use `async`/`await` directly.
- **`Promise.all()`** for independent fetches — flag sequential `await` waterfalls.
- **`cache()`** (React `cache`) to dedupe fetches across the render tree.
- `fetch()` uses explicit caching: `next: { revalidate }` or tags, not accidental defaults.

## Mutations

- **Server Actions** for forms and mutations.
- **`/api/*` routes that could be Server Actions** — flag them.
- `useFormStatus` / `useActionState` for pending and error states.

## Streaming & Suspense

- `<Suspense>` around async sections so data doesn't block the whole page.
- `loading.tsx` per route for automatic Suspense boundaries.
- `error.tsx` per route for error boundaries.
- `not-found.tsx` where applicable.

## SEO & metadata

- `generateMetadata()` for dynamic per-page metadata; `metadata` export for static.
- **`next/image`** for all images — flag every raw `<img>`.
- **`next/font`** — flag `@import` or `<link>` font loading.

## Routing

- **Route Groups** `(folder)` to organize layouts without affecting URLs.
- **Parallel / Intercepting Routes** where they'd help (modals, dashboards).
- **`middleware.ts`** for auth guards, redirects, locale.

## Performance

- `generateStaticParams` for dynamic static routes.
- `dynamic = 'force-static' | 'force-dynamic'` set where the default is wrong.
