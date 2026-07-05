# shadcn/ui

## Ownership & customization

- shadcn components are **owned** code in a `ui/` folder, customized for the project — not treated as an untouchable dependency.
- Flag unnecessary abstraction layers wrapping shadcn components for no added behavior.

## Theming

- All theme tokens defined in `globals.css` as CSS variables.
- **HSL format** used consistently for colors.
- Flag hardcoded hex/rgb values that should be CSS variables.

## Patterns

- **`cva`** for variants in custom components (matches shadcn's own pattern).
- Radix primitives used directly where no shadcn component exists, rather than reinventing.
- Compound components used correctly (`Dialog.Root` + `Dialog.Trigger` + `Dialog.Content`, etc.).
- **`react-hook-form`** integrated with shadcn `Form` components.
- The `Form` component used for all forms — flag raw `<input>` where a `FormField` belongs.
