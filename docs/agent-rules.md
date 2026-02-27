# AI Agent Rules & Change Memory

## Project Snapshot
- Entry point `lib/main.dart` starts `MaterialApp` (`Ali Sinaee Portfolio`) with `PortfolioApp` as home.
- UI flow has two modes in `lib/portfolio_app.dart`: animated kinetic landing and flat scrollable sections.
- `lib/portfolio_flat_page.dart` renders the long-form section layout with in-page navigation and section tracking.
- Data model is typed in `lib/models/portfolio_models.dart` and populated by `const portfolioSnapshot` in `lib/data/portfolio_snapshot.dart`.
- Reusable UI widgets live in `lib/widgets` (7 files): `compact_header_bar.dart`, `experience_card.dart`, `key_value_block.dart`, `kinetic_landing_view.dart`, +3 more.
- Primary package dependencies include `cupertino_icons`, `google_fonts`, `url_launcher`.
- Widget tests in `test/widget_test.dart` validate animated menu behavior, flat-mode section menu.
- Repository targets Flutter multi-platform builds: `android`, `ios`, `web`, `macos`, `linux`, `windows`.

## Behavior Rules
- Keep this file concise and clear for AI agents.
- Update this file after assistant turns that edit repo-tracked files.
- Capture new user behavior instructions as short imperative rules.
- Skip updates when there are no file edits and no new behavior instructions.
- Retain only the latest 20 change entries.
- Run after each assistant change in chat for this repository.
- Use one Markdown rules file and evolve it from user behavior instructions.

## Recent Changes (Last 20)
### 2026-02-27T19:04:07+03:30
- Changed files: `.agents/skills/auto-docs/agents/openai.yaml`, `.agents/skills/auto-docs/agents/interface.yaml`, `.agents/skills/auto-docs/assets/auto-docs-small.png`, `.agents/skills/auto-docs/SKILL.md`
- Summary: Fixed Auto Docs icon rendering by switching to PNG icons and added interface metadata compatibility; installed skill globally in ~/.codex/skills/auto-docs.
- Behavior impact: Recorded code-level deltas for future AI context.
<!-- fingerprint:f563ceeec3fb -->

### 2026-02-27T18:51:31+03:30
- Changed files: `.agents/skills/auto-docs/SKILL.md`, `.agents/skills/auto-docs/agents/openai.yaml`, `.agents/skills/auto-docs/assets/auto-docs-small.svg`, `.agents/skills/auto-docs/assets/auto-docs-large.svg`, `.agents/skills/auto-docs/assets/auto-docs-large.png`, `.agents/skills/auto-docs/scripts/update_docs.py`, `AGENTS.md`, `docs/agent-rules.md`
- Summary: Finalized Auto Docs skill implementation, logos, updater logic, and repository policy integration.
- Behavior impact: Recorded code-level deltas for future AI context.
<!-- fingerprint:a59d2e579f18 -->

### 2026-02-27T18:48:13+03:30
- Changed files: `lib/data/portfolio_snapshot.dart`, `lib/models/portfolio_models.dart`, `lib/portfolio_app.dart`, `lib/portfolio_flat_page.dart`, `lib/widgets/kinetic_landing_view.dart`, `lib/widgets/scrolling_text_row.dart`, `test/widget_test.dart`
- Summary: Implemented Auto Docs skill, assets, updater script, and repository policy wiring.
- Behavior impact: Added or refreshed 3 behavior rule(s) from user instructions.
<!-- fingerprint:754c92d74f23 -->

## Last Updated
- 2026-02-27T19:04:07+03:30
