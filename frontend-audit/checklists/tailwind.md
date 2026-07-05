# Tailwind CSS

## Utility setup

- **`cn()` helper** (clsx + tailwind-merge) exists and is used in every component with conditional classes. Flag manual string concatenation of classes.
- **Arbitrary values** (`mt-[13px]`, `text-[#3b82f6]`) — list every occurrence; each should map to a scale token.
- **Inline `style={{}}`** that should be Tailwind classes.

## Design tokens

- `tailwind.config.*` defines custom colors, spacing, typography, radius — not ad-hoc values scattered in markup.
- shadcn CSS variables (`--primary`, `--muted`, `--radius`, …) wired into the config so utilities resolve to them.
- A consistent spacing/sizing scale, not random one-off values.

## Component patterns

- **`cva`** (class-variance-authority) for component variants instead of conditional class soup.
- Repeated class combinations extracted into a component or `@layer` utility.
- Flag the same long `className` string copy-pasted across files.

## Responsive & dark mode

- Dark mode configured (`class` or `media`).
- Responsive variants (`sm:`/`md:`/`lg:`) used consistently, not one breakpoint everywhere.
- Flag hardcoded light-mode colors that break in dark mode (use semantic tokens).
