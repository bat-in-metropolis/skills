# React SPA (Vite / webpack / CRA)

Loaded alongside `react-core.md`. This module is **build & SPA concerns only** — React itself is identical across bundlers, so it lives in `react-core.md`.

## Code splitting

- **Route-level `React.lazy` + `Suspense`** so the initial bundle isn't the whole app. Flag a single eager import of every route.
- Heavy/rarely-used components (editors, charts, modals) lazy-loaded.
- Dynamic `import()` for large optional dependencies.

## Bundle hygiene

- No barrel-file imports that pull a whole library when one function is needed (`import { x } from 'lib'` vs deep import where the lib isn't tree-shakeable).
- Bundle analyzer available (`rollup-plugin-visualizer` / `webpack-bundle-analyzer`) and obvious bloat addressed.
- Source maps configured for prod debugging without shipping to users.

## Environment & config

- Env vars via the bundler's mechanism (`import.meta.env.VITE_*` / `process.env.REACT_APP_*`), never hardcoded secrets, and only public values exposed to the client.
- Production build minifies and drops dev-only code (`process.env.NODE_ENV`).

## Routing & data (client-side)

- A data-fetching layer (React Query/SWR) for caching/dedupe, not raw `useEffect` + `fetch` repeated per component.
- Loading and error states handled per route, not silent.
- Client router (React Router) uses lazy routes and a sensible 404.

## Assets

- Images imported through the bundler (hashed, optimized), not referenced by raw public paths where optimization is wanted.
- Fonts self-hosted/preloaded rather than render-blocking `@import`.
