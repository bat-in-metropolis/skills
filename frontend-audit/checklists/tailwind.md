# Tailwind CSS

## Utility setup

- **`cn()` helper** (clsx + tailwind-merge) exists and is used in every component with conditional classes. Flag manual string concatenation of classes.
- **Arbitrary values** (`mt-[13px]`, `text-[#3b82f6]`) — report the ones that duplicate an existing token or repeat across files (Suggestion). A one-off value with no matching token is fine. A hardcoded color that breaks dark mode or a theme is an Issue.
- **Inline `style={{}}`** that should be Tailwind classes — Suggestion, unless the value is dynamic (computed at runtime), where inline style is correct.

## Design tokens

Where tokens live depends on the version: **v3** — `tailwind.config.*` (`theme.extend`); **v4** — CSS `@theme` blocks (a config file is optional, loaded via `@config`). Check the version before reporting a missing config.

- Custom colors, spacing, typography, radius defined as tokens — not ad-hoc values scattered in markup.
- shadcn CSS variables (`--primary`, `--muted`, `--radius`, …) wired in (v3 config `colors`, or v4 `@theme inline`) so utilities resolve to them.
- A consistent spacing/sizing scale, not random one-off values.

## Component patterns

- **`cva`** (class-variance-authority) for component variants instead of conditional class soup.
- Repeated class combinations extracted into a component or `@layer` utility.
- Flag the same long `className` string copy-pasted across files.

## Responsive & dark mode

- Dark mode configured — v3: `darkMode: 'class' | 'media'`; v4: `@custom-variant dark (…)` in CSS, or the default `prefers-color-scheme`. Only relevant if the app offers dark mode (e.g. `next-themes` installed).
- Responsive variants (`sm:`/`md:`/`lg:`) used consistently, not one breakpoint everywhere.
- Flag hardcoded light-mode colors that break in dark mode (use semantic tokens).
