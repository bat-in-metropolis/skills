# Vanilla HTML / CSS / JS

No framework. Loaded when the project is plain `.html`/`.css`/`.js` with no React/Next/Vite dependency.

## HTML

- Semantic elements (`<header>`, `<nav>`, `<main>`, `<button>`, `<a>`) over `<div>` soup.
- One `<h1>` per page; heading levels not skipped.
- Forms: labels tied to inputs (`for`/`id`), correct `type`, native validation used before JS.
- Accessibility: `alt` on images, `aria-*` only where native semantics fall short, visible focus states.
- `<meta viewport>`, charset, and per-page `<title>`/description present.

## CSS

- Custom properties (`:root { --color }`) for the token system instead of repeated literals.
- A consistent layout method (flexbox/grid) rather than floats/absolute hacks.
- No deeply specific selectors or `!important` wars — flag specificity that's hard to override.
- Responsive via relative units and media queries; no fixed-pixel layouts that break on mobile.

## JavaScript

- `const`/`let`, never `var`; modules (`import`/`export`) over global script soup.
- Event delegation over per-element listeners on large lists.
- DOM reads/writes batched to avoid layout thrash; no work in tight scroll/resize handlers without throttle/`requestAnimationFrame`.
- `fetch` with error handling and loading/empty states; no unhandled promise rejections.
- No blocking synchronous scripts in `<head>`; defer/async or module scripts.

## Delivery

- Assets minified; images sized and lazy-loaded (`loading="lazy"`).
- No render-blocking `@import` for fonts; preload critical assets.
