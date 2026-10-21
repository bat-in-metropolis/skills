# shadcn/ui

## Ownership & customization

- shadcn components are **owned** code in a `ui/` folder, customized for the project — not treated as an untouchable dependency.
- Flag unnecessary abstraction layers wrapping shadcn components for no added behavior.

## Use the installed primitives

List the components actually present in the repo's `components/ui/` (resolve the path from `components.json` aliases). For each one, find raw HTML elements in app code that duplicate it: `<button>` → `Button`, `<input>` → `Input`, `<textarea>` → `Textarea`, `<label>` → `Label`, `<select>` → `Select`, `<input type="checkbox">` → `Checkbox`, hand-rolled modals → `Dialog`, and so on.

- Base it on what is installed, not the full shadcn catalog. If a component isn't in `components/ui/`, don't report raw usage against it — at most one Suggestion to add it when the same raw element is restyled by hand in many places.
- **Label:** Convention — the repo already owns the component. Consolidate all instances into one finding with every location, and say which variant/size each maps to (e.g. `variant="ghost" size="icon"`), so the fix is mechanical.
- **Issue** when the raw element also loses behavior the component provides: no visible focus style, a `<div onClick>` instead of a button, an icon-only button with no accessible name, a raw `<button>` inside a `<form>` with no `type` that submits by accident.
- **Skip:** files inside `components/ui/` itself; a `<a>`/`Link` rendered through `Button asChild` (that is the intended pattern); markup owned by third-party libraries; one-off elements with deliberately different behavior the component can't express — note why.

## Theming

- All theme tokens defined in `globals.css` as CSS variables.
- Color format consistent with the installed setup — HSL channels for Tailwind v3-era shadcn, OKLCH for Tailwind v4-era. Mixed formats are a Suggestion; don't demand one format over the other.
- Hardcoded hex/rgb values that should be CSS variables — an Issue when they break dark mode or a theme; otherwise a Suggestion.

## Patterns

- **`cva`** for variants in custom components (matches shadcn's own pattern).
- Radix primitives used directly where no shadcn component exists, rather than reinventing.
- Compound components used correctly (`Dialog.Root` + `Dialog.Trigger` + `Dialog.Content`, etc.).
- **`react-hook-form`** integrated with shadcn `Form` components — only when `react-hook-form` is installed.
- A raw `<input>` instead of `FormField` is an **Issue** only when its label or error message isn't associated with the input (accessibility). Otherwise a Suggestion that names the benefit (shared validation/error markup).
