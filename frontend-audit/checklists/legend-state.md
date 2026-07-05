# Legend State

**Stance — both pillars.** Legend State has two pillars, and this org's policy is: if it is present, use *both*.

- **Pillar A — state**: observables, `computed()`, `batch()`, persistence.
- **Pillar B — reactive rendering / memoization**: `observer()`, `<Show>`/`<For>`/`<Switch>`/`<Memo>`, reactive props, two-way `$value`, and on native the reactive RN components.

The strongest finding here is **partial adoption** — paying for the library while behaving like it's not installed:

- Observables exist, but components use `useState` / plain `.map()` / `{cond && …}` → **Pillar B missing.** The state is reactive; the rendering is not.
- Reactive components used, but state lives in Redux/Zustand/Context alongside → **split-brain state.** Consolidate on Legend.

Report partial adoption first; the micro-checks below are how you find it.

## Reactive components (Pillar B)

- **`observer()`** — every component that reads an observable must be wrapped. An unwrapped component reading `.get()` will not re-render reactively.
- **`<Show>`** — `{obs.cond.get() && <X/>}` re-renders the parent on every change. Use `<Show if={obs.cond}><X/></Show>` — it isolates the toggle. Flag every `&&`/ternary gated on an observable.
- **`<For>`** — `obs.list.get().map(...)` re-renders the whole list on any change. Use `<For each={obs.list}>{item => …}</For>` — it re-renders only changed rows. Flag every `.map()` over an observable array.
- **`<Switch>`** — if/else or ternary chains on an observable → `<Switch value={obs}><Match .../></Switch>`.
- **`<Memo>`** — expensive subsections not isolated → wrap in `<Memo>` to freeze them from parent re-renders.

## Reactive props & two-way binding

- Prefer reactive props over reading inside the component body: `<div className={obs.cls}>` over reading `.get()` then rendering.
- Two-way inputs: `<input $value={obs.name} />` over `value={obs.name.get()} onChange={e => obs.name.set(e.target.value)}`. Flag the verbose form.

## Reading observables correctly

- **Granular reads.** `obs.get()` at the top re-renders the whole component on any nested change. Read deep — `obs.user.name.get()` — to re-render only on that field.
- **`.peek()` for non-reactive reads.** In event handlers and effects use `.peek()`, not `.get()` — `.get()` there creates needless tracking.
- **No spreading.** `{ ...obs.get() }` snapshots and loses reactivity entirely. Flag it.

## Derived state (Pillar A)

- `computed()` for **all** derived state. Flag any value recalculated inline in a component that should be a `computed()`.
- `linked()` for two-way derived state.

## Side effects

- `observe()` for reactive side effects, not `useEffect` + `.get()`.
- `when()` for one-time reactive triggers.
- Flag any `useEffect` whose dep is an observable read — it should be `observe()`.

## Batching

- `batch()` whenever 2+ observables are set together (especially in one event handler). Flag multi-set handlers without it.

## State structure

- Observables split by domain (`uiState$`, `authState$`, `dataState$`), not one flat blob.
- Observable arrays instead of `useState` arrays.
- Flatten deeply nested observable state where possible.

## Persistence

- `synced`/`persistObservable` for state that should survive refresh.
- Flag any `localStorage.getItem/setItem` (or `AsyncStorage` on native) that should be Legend persistence.

## Native section — activate only when `react-native.md` is also loaded

On React Native, Pillar B uses Legend's reactive RN components from `@legendapp/state/react-native`:

- Use `$View`, `$Text`, `$TextInput`, etc. (reactive RN primitives) instead of plain RN components wrapped in `observer` for fine-grained updates.
- Two-way text input: `<$TextInput $value={obs.name} />` over `value={obs.name.get()} onChangeText={t => obs.name.set(t)}`.
- `<For>` over `FlatList`/`.map()` for observable lists where row-level reactivity matters.
- Flag plain RN components rendering observable values without reactive wrapping — the RN app depends on Legend for memoization, so this is a re-render regression.
