---
name: auto-docs
description: Maintain `docs/agent-rules.md` as concise AI-facing project memory for this repository. Use when assistant turns edit repo-tracked files, when users provide new behavior constraints/preferences, or when docs are missing/stale and need bootstrap from current codebase.
---

# Auto Docs

## Overview

Keep a single concise documentation file (`docs/agent-rules.md`) current for AI agents by combining stable project snapshot bullets, behavior rules, and recent change memory.

## Workflow

1. Collect inputs from the current turn:
- Changed files (`--changed-files`) if available.
- Short summary of what changed (`--change-summary`).
- Latest user instruction text (`--user-message`) for rule extraction.
2. Run the updater script:
- `python .agents/skills/auto-docs/scripts/update_docs.py --project-root <abs-path> --docs-file docs/agent-rules.md --changed-files "<comma-separated>" --change-summary "<short text>" --user-message "<latest user text>"`
3. Keep output concise:
- Project snapshot: 6-12 bullets.
- Behavior rules: deduplicated, max 15.
- Recent changes: newest first, max 20 entries.
4. Skip updates when both conditions are true:
- No file edits detected.
- No new behavior instruction extracted from user message.

## Output Contract

- Write exactly one markdown file: `docs/agent-rules.md`.
- Keep these sections in order:
  1. `# AI Agent Rules & Change Memory`
  2. `## Project Snapshot`
  3. `## Behavior Rules`
  4. `## Recent Changes (Last 20)`
  5. `## Last Updated`
- Keep entries brief and implementation-relevant.

## Rule Extraction Guidance

- Extract rule candidates from user message segments containing terms like:
  `must`, `should`, `need`, `want`, `behavior`, `app should`, `always`, `never`.
- Normalize to short imperative rules.
- Deduplicate case-insensitively.
- Preserve existing rules and append only new ones up to cap.

## Assets

- `assets/auto-docs-small.png`: compact icon for skill lists.
- `assets/auto-docs-small.svg`: vector source for the compact icon.
- `assets/auto-docs-large.png`: wide logo for larger surfaces.
- `assets/auto-docs-large.svg`: vector source for the wide logo.
