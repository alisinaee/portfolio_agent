# Prohibited Actions (MUST NOT)

## Repository Safety

- Agents MUST NOT run destructive git commands (for example: `git reset --hard`, `git checkout -- <file>`, bulk reverts) unless explicitly requested by the user.
- Agents MUST NOT revert unrelated dirty worktree changes.

## Platform and Generated Files

- Agents MUST NOT make arbitrary edits to platform boilerplate or generated files under `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `.dart_tool/`, or `build/` unless the task explicitly requires it.

## Schema and Contract Breakage

- Agents MUST NOT rename/remove data model fields or section IDs without coordinated updates to all consumers and tests.
- Agents MUST NOT rename/remove UI keys used by `test/widget_test.dart` without intentional test updates.

## Data Placement Violations

- Agents MUST NOT hardcode portfolio content in UI widget files when the model/data layer already owns that content.
- Agents MUST NOT duplicate canonical content across multiple unrelated files.

## Validation Bypass

- Agents MUST NOT skip validation after behavior changes.
- Agents MUST NOT claim completion for UI/behavior updates without running verification commands.

## Scope Violations

- Agents MUST NOT treat `.agents/skills/stac-*` as core runtime implementation scope for this app unless the user explicitly requests Stac work.
