# Testing and Validation

This file defines required checks before considering implementation complete.

## Mandatory Commands

Run from project root:

```bash
flutter analyze
flutter test
```

## Verification Matrix

- Mode switching behavior
  - Expect animated and flat app bars to swap correctly.
  - Primary coverage: `test/widget_test.dart` mode switch test.
  - Key files: `lib/portfolio_app.dart`, `lib/portfolio_flat_page.dart`, `lib/widgets/compact_header_bar.dart`.

- Animated menu behavior
  - Expect menu open state to expose expected menu items and keys.
  - Primary coverage: animated menu open-state tests.
  - Key files: `lib/portfolio_app.dart`, `lib/widgets/kinetic_landing_view.dart`.

- Overlay open and close behavior
  - Expect section overlays to open from animated menu and close via close button.
  - Primary coverage: overlay open/close tests.
  - Key files: `lib/portfolio_app.dart`.

- Flat section menu behavior
  - Expect hamburger toggle and section tap-to-scroll behavior in flat mode.
  - Primary coverage: flat section menu tests.
  - Key files: `lib/portfolio_flat_page.dart`, `lib/widgets/section_nav_bar.dart`.

- Responsive kinetic rows behavior
  - Expect row counts and motion settings to adapt by viewport dimensions.
  - Primary coverage: responsive/motion tests.
  - Key files: `lib/portfolio_app.dart`, `lib/widgets/scrolling_text_row.dart`, `lib/widgets/kinetic_landing_view.dart`.

## Failure Triage Checklist

1. If analyze fails with type/schema errors:
   - Inspect `lib/models/portfolio_models.dart` and `lib/data/portfolio_snapshot.dart` for constructor/field mismatches.

2. If key-based widget tests fail:
   - Inspect key contracts in `lib/portfolio_app.dart`, `lib/portfolio_flat_page.dart`, and `lib/widgets/compact_header_bar.dart`.

3. If animated motion/menu tests fail:
   - Inspect animation gating and scene transitions in `lib/portfolio_app.dart`.
   - Inspect row motion/presentation in `lib/widgets/kinetic_landing_view.dart` and `lib/widgets/scrolling_text_row.dart`.

4. If section scroll/menu tests fail:
   - Inspect `_sectionKeys`, `_sectionLabels`, `_scrollToSection`, and `_updateActiveSection` in `lib/portfolio_flat_page.dart`.

5. If link action tests or runtime link behavior fail:
   - Inspect URI parsing and `launchUrl` calls in `lib/portfolio_app.dart` and `lib/portfolio_flat_page.dart`.

## Completion Gate

A change is complete only when:

- `flutter analyze` passes.
- `flutter test` passes.
- Affected workflow post-checks in `docs/agent-workflows.md` are satisfied.
