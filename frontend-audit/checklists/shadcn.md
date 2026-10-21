# shadcn/ui

## Ownership & customization

- shadcn components are **owned** code in a `ui/` folder, customized for the project — not treated as an untouchable dependency.
- Flag unnecessary abstraction layers wrapping shadcn components for no added behavior.

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
