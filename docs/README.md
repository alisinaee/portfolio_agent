# AI Agent Documentation

This folder is the canonical operating manual for AI agents working in this repository.

## Purpose

- Define project structure, safe editing rules, and mandatory validation gates.
- Reduce ambiguous edits by providing decision-complete workflows.
- Keep `docs/agent-rules.md` as machine-maintained change memory, not the full manual.

## Reading Order

1. `docs/project-overview.md`
2. `docs/architecture.md`
3. `docs/agent-workflows.md`
4. `docs/best-practices.md`
5. `docs/prohibited.md`
6. `docs/testing-validation.md`
7. `docs/agent-rules.md`

## Source of Truth Hierarchy

1. Runtime code and tests in `lib/` and `test/`.
2. This docs suite for execution rules and workflows.
3. `docs/agent-rules.md` for recent change memory and behavior rules.
4. High-level project README files for human onboarding.

## Quick Task Routing

- If task is "update profile/contact/content data": open `docs/agent-workflows.md` (Workflow A) and edit `lib/data/portfolio_snapshot.dart`.
- If task is "add/change a flat page section": open `docs/agent-workflows.md` (Workflow B) and `docs/architecture.md`.
- If task is "change animated landing/menu/overlay": open `docs/agent-workflows.md` (Workflow C) and `docs/architecture.md`.
- If task is "add or refactor a reusable widget": open `docs/agent-workflows.md` (Workflow D) and `docs/best-practices.md`.
- If task is "update UI behavior and tests": open `docs/agent-workflows.md` (Workflow E) and `docs/testing-validation.md`.
- If task is "what is forbidden": open `docs/prohibited.md`.

## Scope Boundary

- Core documentation scope is the current Flutter portfolio app.
- Stac skill content under `.agents/skills/stac-*` is out of scope for core app implementation docs.

## Maintenance Policy

- Treat this folder as repo-tracked operational documentation.
- After edits to repo-tracked files, run `$auto-docs` and update `docs/agent-rules.md` in the same turn.
- Keep docs strict, implementation-focused, and consistent with actual code paths.
- Prefer updating existing docs over adding new files unless there is a clear new responsibility.
