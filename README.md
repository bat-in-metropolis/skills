# skills

Personal Claude Code skills. Each skill solves a specific friction point in my engineering workflow.

## Install

```bash
git clone https://github.com/bat-in-metropolis/skills.git ~/.skills
ln -s ~/.skills ~/.claude/commands
```

That's it. All skills become available as slash commands in Claude Code across every repo on your machine.

To update:
```bash
cd ~/.skills && git pull
```

---

## Skills

### `/work-log`

Interviews you about the branch you just finished, then generates:
- A structured PR description (ready to paste into GitHub)
- A Google Sheet row for your career log (with STAR stories for significant tasks)

**When to use**: Right before raising a PR, while context is fresh.

```
/work-log          # Claude asks if it's a routine or significant task
/work-log quick    # Skip routing — 3 questions only
/work-log deep     # Skip routing — full 7-question interview
```

---

### `/git-commit`
*(coming soon — migrating from separate repo)*

Generates detailed, descriptive commit messages from your staged diff.

---

## Philosophy

Each skill here solves something I hit repeatedly. Small, composable, easy to adapt.
Inspired by [mattpocock/skills](https://github.com/mattpocock/skills).
