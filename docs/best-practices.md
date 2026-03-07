# Best Practices (Mandatory)

## Data and Models

- Agents MUST keep portfolio content in `lib/data/portfolio_snapshot.dart`.
- Agents MUST preserve typed contracts in `lib/models/portfolio_models.dart`.
- Agents MUST update model definitions before snapshot data when schema changes are needed.
- Agents MUST keep snapshot fields internally consistent (no dangling or missing required values).

## UI Structure and Reuse

- Agents MUST prefer reusable components under `lib/widgets` instead of duplicating UI blocks.
- Agents MUST keep section composition in `lib/portfolio_flat_page.dart` clear and ordered.
- Agents SHOULD use `SectionContainer`, `ExperienceCard`, `KeyValueBlock`, and `CompactHeaderBar` when the use case matches existing behavior.

## Theme and Typography

- Agents MUST keep theme and typography centralized in `lib/main.dart` unless there is a strong architectural reason to move them.
- Agents MUST preserve font family wiring (`BuiltTitlingRgBold`, `google_fonts`) when modifying kinetic typography behavior.

## Keys and Section Contracts

- Agents MUST maintain stable key identifiers used by tests unless behavior changes intentionally require updates.
- Agents MUST keep `PortfolioSectionId` mappings synchronized with UI navigation labels and key anchors.

## Link Handling

- Agents MUST keep URL launch behavior null-safe and parse-safe.
- Agents MUST validate `Uri.tryParse` usage before calling `launchUrl`.

## Change Discipline

- Agents MUST run `flutter analyze` and `flutter test` after behavior-affecting changes.
- Agents MUST keep docs aligned with current implementation when architecture or workflow changes.
