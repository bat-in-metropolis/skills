# React core

Language-level React, identical across Next.js, Vite, webpack/CRA, and React Native. Bundler-specific build concerns live in `react-spa.md`; this module is about how components and hooks are written.

> If `legend-state.md` is also loaded, this org prefers Legend's reactive primitives over the plain-React patterns below. Defer state/memoization findings to `legend-state.md` and audit here only what Legend does not cover (composition, keys, accessibility, prop design).

## Hooks

- **Effect dependency arrays** — flag missing deps, lying deps (`// eslint-disable`), and effects that should not be effects at all (deriving state, transforming props → compute during render instead).
- **Effects that should be event handlers** — logic reacting to a user action belongs in the handler, not an effect watching the result.
- **`useState` for derived values** — values computable from props/other state should be computed during render, not stored and synced.
- **Stable identities** — `useCallback`/`useMemo` only where identity actually matters (deps of other hooks, memoized children). Flag both missing-where-needed and cargo-cult-everywhere.
- **Custom hooks** — repeated hook sequences extracted into a named `useX` hook.

## Rendering & re-renders

- **`key` props** — lists keyed by stable IDs, never array index when the list reorders/filters. Flag index keys on dynamic lists.
- **Derived-during-render vs stored** — prefer computing in render over `useEffect` + `setState`.
- **Context value identity** — provider `value` memoized so consumers don't re-render on every parent render.
- **Component-in-component** — components defined inside another component's body remount every render. Flag and hoist.

## Composition

- **Lift state only as far as needed**; push it back down when one subtree owns it.
- **Children-as-composition** over prop drilling — pass `children`/render props instead of threading data through many layers.
- **Controlled vs uncontrolled** inputs chosen deliberately, not mixed on one field.

## Correctness

- **No state mutation** — arrays/objects in state updated immutably.
- **Error boundaries** around risky subtrees.
- **Keys for fragments** in lists.
- **Accessibility** — interactive elements are real buttons/links, labels tied to inputs, images have alt text.
