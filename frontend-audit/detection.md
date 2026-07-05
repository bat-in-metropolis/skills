# Detection rules

Resolve each axis independently from the signals below, then load the union of the matched modules. Axes are orthogonal — styling does not depend on framework, state does not depend on platform — except the one interaction noted at the end.

## Axis 1 — Platform

| Value | Signal | Loads |
|---|---|---|
| native | `react-native` in deps, `metro.config.*`, `app.json` with `expo`, or `expo` dep | `react-native.md` |
| web | anything React/DOM-based that is not native | (framework module decides) |

## Axis 2 — Framework / build

Resolve to exactly one per package.

| Value | Signal | Loads |
|---|---|---|
| Next.js (App Router) | `next` dep **and** an `app/` dir with `layout.*` | `react-core.md` + `nextjs-app.md` |
| Next.js (Pages Router) | `next` dep **and** a `pages/` dir | `react-core.md` + `nextjs-pages.md` |
| React + Vite | `vite` dep, `vite.config.*` | `react-core.md` + `react-spa.md` |
| React + webpack/CRA | `react-scripts` dep, or raw `webpack` config with `react` | `react-core.md` + `react-spa.md` |
| React Native | `react-native` dep, no `next`/`vite` | `react-core.md` (platform module from Axis 1) |
| vanilla HTML/CSS/JS | `.html` files, no framework dep (often no `package.json`) | `vanilla-web.md` |

Notes:
- App and Pages routers can **coexist** during migration — load both Next modules and flag the split.
- The bundler (webpack vs Vite) does not change React's language-level concerns — those live in `react-core.md`. Only build concerns (code-splitting, lazy routes, env) live in `react-spa.md`. Do not split webpack-React from Vite-React.

## Axis 3 — Styling

Multiple may apply; load all that match.

| Value | Signal | Loads |
|---|---|---|
| Tailwind (web) | `tailwindcss` dep + `tailwind.config.*` on a web platform | `tailwind.md` |
| NativeWind | `nativewind` dep | `nativewind.md` |
| CSS modules / styled-components / plain CSS | `*.module.css`, `styled-components` dep, plain `.css` | (covered inside framework module) |

## Axis 4 — Component library

| Value | Signal | Loads |
|---|---|---|
| shadcn/ui | `components/ui/` dir + `class-variance-authority` + `components.json` | `shadcn.md` |

## Axis 5 — State

| Value | Signal | Loads |
|---|---|---|
| Legend State | `@legendapp/state` dep | `legend-state.md` |

## Axis interaction

`legend-state.md` has a **platform-conditional** section. When **both** `react-native.md` and `legend-state.md` are loaded, activate its native section (audit Legend's reactive RN components — `$View`, `$TextInput`, `$value` bindings — instead of plain RN components wrapped in `observer`). Otherwise audit the web reactive primitives only. This stays one module — do not create a `legend-state-native.md`.
