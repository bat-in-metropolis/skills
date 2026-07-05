# Next.js — Pages Router

Loaded for the legacy `pages/` router (alongside `react-core.md`). If `app/` also exists, both Next modules load — flag the incomplete migration.

## Data fetching

- `getStaticProps` + `getStaticPaths` for static content; `getServerSideProps` only when per-request data is genuinely needed. Flag `getServerSideProps` used where static would do.
- `revalidate` set for ISR rather than fully static or fully dynamic by accident.
- No data fetching inside components that should run in `getStaticProps`/`getServerSideProps`.
- Client data fetching uses SWR/React Query, not bare `useEffect` waterfalls.

## Routing & API

- `_app.tsx` / `_document.tsx` used correctly (providers in `_app`, html shell in `_document` — no data fetching in `_document`).
- API routes (`pages/api/*`) validate input and set proper status codes.
- Dynamic routes typed; `fallback` strategy in `getStaticPaths` chosen deliberately.

## SEO & assets

- `next/head` for per-page metadata.
- **`next/image`** for all images — flag raw `<img>`.
- **`next/font`** — flag `@import`/`<link>` font loading.

## Migration note

- New routes should be built in the App Router. Flag new feature work added to `pages/` when `app/` exists.
