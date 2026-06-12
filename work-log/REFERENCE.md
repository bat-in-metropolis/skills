# Work Log — Reference

## Interview Question Sets

### Normal Mode (3 questions)

Ask in order, one at a time:

1. What did you build, fix, or change in this branch?
2. Were there any blockers — even small ones?
3. Did you complete this on time, early, or was there a delay?

---

### Special Mode (7 questions)

Ask in order, one at a time:

1. What did you build, fix, or change in this branch?
2. What was the core challenge?
3. How did you solve it — walk me through your thinking.
4. What did you learn or discover that you didn't know before?
5. Was there a delay or did you finish early — and why?
6. What would you do differently if you did this again?
7. What was the impact — what's better now because of this?

---

## PR Description Templates

### Normal Task

```
## What changed
[2–3 line summary of what the PR does]

## Why
[Context — ticket, bug report, or product reason]

## How
[Key technical decisions. Non-obvious choices only. Skip the obvious.]

## Testing
[How you verified this works]

## Impact
[What's better now because of this]
```

### Special Task (adds Challenges section)

```
## What changed
[2–3 line summary of what the PR does]

## Why
[Context — ticket, bug report, or product reason]

## How
[Key technical decisions. Non-obvious choices only.]

## Challenges
[What was hard. What you had to figure out. What broke first.]

## Testing
[How you verified this works]

## Impact
[What's better now because of this]
```

---

## Google Sheet Column Definitions

Generate a tab-separated row in this exact column order:

| # | Column | Normal | Special |
|---|--------|--------|---------|
| 1 | Date | Date PR was raised (YYYY-MM-DD) | Same |
| 2 | Project / Repo | Repository or project name | Same |
| 3 | Task Title | One-line summary of the task | Same |
| 4 | Type | Feature / Bug / Refactor / Infra | Same |
| 5 | Mode | Normal | Special |
| 6 | What I Built | Answer to Q1 | Same |
| 7 | Core Challenge | — | Answer to Q2 |
| 8 | How I Solved It | — | Answer to Q3 |
| 9 | Learning | — | Answer to Q4 |
| 10 | Timeline | On time / Early / Delayed + why (Q3) | Same from Q5 |
| 11 | Impact | What changed because of this (Q3) | Answer to Q7 |
| 12 | STAR Story | — | Full STAR story (see below) |

---

## STAR Story Format (Special mode only)

Build from interview answers in this exact structure:

**Situation**: [Context of the problem — from Q1 + Q5. What was broken, missing, or needed?]

**Task**: [What you were specifically responsible for solving — from Q1]

**Action**: [How you diagnosed and solved it, step by step — from Q3. Be specific: tools, decisions, trade-offs.]

**Result**: [What improved, by how much, who benefited — from Q4 + Q7. Use numbers where possible.]

---

## Output Format Instructions

After the interview, output in this exact order:

1. A heading: `## PR Description`
2. The formatted PR description block
3. A divider: `---`
4. A heading: `## Google Sheet Row`
5. A note: `Copy the row below and paste directly into your sheet:`
6. The tab-separated row
7. For Special mode only — a heading `## STAR Story` followed by the story
