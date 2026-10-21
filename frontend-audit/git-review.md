# Git review comment mode

Add paste-ready review comments to the normal audit when `--git-review` is enabled. Keep the audit's coverage; apply the stricter criteria below when selecting comments to leave on a change.

## Read the change

- For a PR, resolve its actual target branch, compute its merge base with HEAD, and inspect the full diff with line numbers, not only changed filenames. Review the committed HEAD version; local uncommitted changes are outside this scope.
- For staged changes, inspect `git diff --staged` and the index versions of files. Working-tree line numbers can differ from staged lines.
- Read surrounding code and relevant callers when needed to establish a trigger, consequence, or existing convention. Context outside the selected scope does not expand the audit scope.
- Distinguish issues introduced or made worse by the change from pre-existing issues. Comment on unchanged code only when a change demonstrably makes it problematic; explain that connection.
- Verify version-sensitive API claims against the installed version, source, or authoritative documentation before turning them into comments.

## Select comments

Include verified bugs, regressions, security or accessibility issues, and meaningful improvements supported by the code. Follow an explicitly requested narrower or broader selection.

Use these labels:

- **Issue** — a demonstrated correctness problem or concrete harmful consequence. Explain when it happens and why it matters.
- **Suggestion (non-blocking)** — a useful improvement or documented project convention without a demonstrated correctness failure. Describe its specific benefit without implying it is required for correctness. Audit findings labeled **Convention** or **Suggestion** use this label.

Only **Verified** findings become comments. Findings marked **Needs verification** stay in the audit.

When the changed behavior has no test and the package has a test setup, a comment may name the specific scenario a test should cover (for example, "an older search response must not overwrite newer results"). Never leave a generic "add tests" comment, and don't raise missing tests in a package that has no test setup.

A checklist preference is not evidence of a bug. For example, preferring a Legend primitive over an equivalent working React pattern is a suggestion unless the actual code demonstrates broken reactivity or another concrete consequence. Omit cosmetic nits by default, speculative problems, and unsupported performance claims. Keep unresolved questions or verification gaps in the audit report instead of presenting them as confirmed comments. Do not manufacture comments when no finding qualifies.

Use one comment per distinct issue. Consolidate repeated instances with the same cause and fix into one comment with additional locations; keep the full instance list in the audit. The priority matrix's top-10 limit does not cap eligible comments.

## Place comments accurately

- For PR or staged scopes, anchor an inline comment to the smallest useful range visible in the reviewed diff. Identify **new/right** or **old/left** and use line numbers from that version. Deleted-code comments may use the old/left side.
- Prefer an added or changed line that shows the issue. Do not attach a comment to an unrelated changed line just to obtain an inline anchor.
- When a finding belongs to the change but has no suitable inline anchor, draft a **general review comment** and include the relevant path and symbol in its body.
- In whole-package scope, use **file comments** with verified source locations. State that these are whole-package findings and that their eligibility for inline PR placement has not been checked.
- If the reviewed diff changes before output, refresh affected anchors. Never invent paths, line numbers, or a PR URL.

## Write paste-ready bodies

Use a concise, collaborative tone: describe the concrete problem or opportunity, its consequence or benefit, and the suggested change. Usually one short paragraph is enough. Be direct about verified bugs; questions are useful only when an answer would change the recommendation.

Each body must stand alone when pasted into the review. Keep audit categories, impact/effort scores, checklist names, and references such as “see finding 3” outside the body. Do not claim checks passed unless they were run. Include a short code example only when it clarifies the fix; use a GitHub `suggestion` block only when the exact replacement and selected diff range have been verified.

## Output

Append **Git review comments** after the existing findings, priority matrix, and fix plan. State the scope and reviewed revision (and base for PR scope) once above the drafts.

For each draft, give its label and short title, the placement and verified location, and a fenced Markdown body for easy copying. Put metadata outside the copyable body. If the body contains code fences, use a longer outer fence.

Example layout (illustrative only; use actual verified locations):

**Issue — Ignore responses from an earlier search**  
**Placement:** Inline, `src/Search.tsx:42–45`, new/right

```markdown
If an earlier search finishes after a later one, this callback replaces the newer results with stale data. Please cancel the previous request or ignore its response after the query changes so the latest results stay visible.
```

**Suggestion (non-blocking) — Reuse the existing field component**  
**Placement:** Inline, `src/Profile.tsx:18`, new/right

```markdown
Consider using the existing `FormField` here. It already connects the label and error description to the input, so this form would inherit the same accessible markup as the other forms.
```

If no findings qualify, say **No review comments recommended** and briefly explain why (for example, findings were pre-existing or cosmetic). Do not invent a minimum number of comments, approve the PR, or submit a review.
