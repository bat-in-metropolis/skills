# NativeWind

Tailwind-on-React-Native. Loaded alongside `react-native.md`. The web `tailwind.md` rules about tokens, `cn()`, `cva`, and arbitrary values still apply — this module is the native deltas.

## Setup

- `nativewind` configured correctly (babel plugin / `metro.config.js` wired, `nativewind-env.d.ts` types present).
- `tailwind.config.js` `content` globs cover all component dirs so classes aren't purged.

## Native-specific usage

- Use `className` on RN components consistently; flag mixing `className` with large inline `style={{}}` objects that duplicate utilities.
- Only RN-supported styles used — no web-only properties (no `:hover`, no CSS grid, limited `gap` support depending on version). Flag web-only utilities that silently no-op on native.
- Platform variants (`ios:`/`android:`) and `dark:` used where behavior differs, rather than runtime `Platform.OS` branching on styles.
- Responsive/breakpoint utilities used sparingly — RN layout is flexbox-first; flag heavy reliance on web breakpoints.

## Consistency

- Theme tokens shared with the design system rather than redefined; colors reference config tokens, not arbitrary hex.
