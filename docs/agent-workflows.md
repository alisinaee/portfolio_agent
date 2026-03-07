# Agent Workflows

Each workflow is decision-complete. Follow steps in order and do not skip validation gates.

## Workflow A: Update Profile or Content Data

Use when changing names, links, resume URL, profile fields, skills, achievements, packages, or current focus.

1. Edit `lib/data/portfolio_snapshot.dart` only.
2. If data shape changes are required, first update `lib/models/portfolio_models.dart`.
3. Ensure every required model field remains populated in `portfolioSnapshot`.
4. Confirm no UI literals duplicate the changed content unnecessarily.
5. Run validation:
   - `flutter analyze`
   - `flutter test`

Post-checks:

- About and Contact values appear in flat mode tests.
- No model constructor mismatch errors.

## Workflow B: Add or Edit Flat Mode Sections

Use when modifying the long-form `FlatPortfolioView` layout.

1. Edit `lib/portfolio_flat_page.dart`.
2. If adding a new section:
   - Add section enum value to `PortfolioSectionId` in `lib/models/portfolio_models.dart`.
   - Add section label in `_sectionLabels` map.
   - Add corresponding key usage in `_sectionKeys` flow.
   - Add section widget block in the main column.
3. Keep section order intentional and stable.
4. Keep `SectionContainer` usage consistent for visual/system coherence.
5. Run validation:
   - `flutter analyze`
   - `flutter test`

Post-checks:

- Flat menu opens and closes correctly.
- Section tap scroll behavior still works.

## Workflow C: Change Animated Menu or Overlay Behavior

Use when altering kinetic rows, menu transition timing, menu items, or overlay rendering.

1. Edit state/transition logic in `lib/portfolio_app.dart`.
2. Edit row rendering mechanics in `lib/widgets/kinetic_landing_view.dart` and/or `lib/widgets/scrolling_text_row.dart` only if required.
3. Keep menu label-to-section mapping coherent with `_animatedMenuToSection`.
4. Preserve gating logic that prevents premature taps when menu is not fully interactive.
5. Preserve overlay close behavior and scene motion rules.
6. Run validation:
   - `flutter analyze`
   - `flutter test`

Post-checks:

- Animated menu item keys remain valid.
- Overlay panel keys and close button behavior remain valid.
- Motion expectations in tests remain true.

## Workflow D: Add or Modify Reusable Widgets

Use when creating/refactoring components under `lib/widgets`.

1. Prefer adding or updating a dedicated widget file in `lib/widgets/`.
2. Keep widget APIs typed and minimal.
3. Avoid embedding large data constants in widgets.
4. Integrate widget from `portfolio_app.dart` or `portfolio_flat_page.dart`.
5. Add stable `Key` values only when needed for behavior/testing.
6. Run validation:
   - `flutter analyze`
   - `flutter test`

Post-checks:

- Existing UI contract keys still pass tests.
- New widget does not duplicate existing component responsibilities.

## Workflow E: Update Keys and Test Expectations After UI Behavior Changes

Use when intentional UI behavior changes require test updates.

1. Implement UI behavior change in target file(s).
2. Update affected tests in `test/widget_test.dart` only for intentional behavior deltas.
3. Keep test names behavior-oriented and specific.
4. Preserve coverage for:
   - mode switching
   - animated menu behavior
   - overlay open/close
   - flat section menu behavior
   - responsive kinetic rows
5. Run validation:
   - `flutter analyze`
   - `flutter test`

Post-checks:

- No key lookup failures.
- Assertions match updated intended behavior, not incidental timing artifacts.
