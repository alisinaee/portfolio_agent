# Repository Agent Rules

## Auto Docs Policy

- Invoke `$auto-docs` after any assistant turn that edits repo-tracked files in this repository.
- Update `docs/agent-rules.md` in the same turn when the skill runs.
- Skip the update only when there are no file edits and no new user behavior instructions.
- Keep `docs/agent-rules.md` short, clear, and focused on AI-agent context.
