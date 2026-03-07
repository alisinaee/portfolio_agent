# Architecture

## Module Boundaries

- `lib/main.dart`
  - Creates `MaterialApp` and theme.
  - Sets `PortfolioApp` as `home`.
- `lib/portfolio_app.dart`
  - Owns top-level app mode state.
  - Controls animated menu morphing and animated section overlays.
  - Delegates flat rendering to `FlatPortfolioView`.
- `lib/portfolio_flat_page.dart`
  - Owns flat-mode scroll controller and active section tracking.
  - Renders hero/about/contact/experience/skills/achievements/packages/focus sections.
- `lib/models/portfolio_models.dart`
  - Defines immutable typed data contracts.
- `lib/data/portfolio_snapshot.dart`
  - Instantiates `const portfolioSnapshot` used by all views.
- `lib/widgets/*`
  - Reusable presentation pieces (`CompactHeaderBar`, `ExperienceCard`, `KeyValueBlock`, `KineticLandingView`, etc.).

## Data Flow

1. `portfolioSnapshot` is declared in `lib/data/portfolio_snapshot.dart`.
2. `PortfolioApp` reads the snapshot and maps data into both mode-specific views.
3. `FlatPortfolioView` and animated overlays render typed model fields.
4. Interaction callbacks (menu taps, section taps, link opens) update local widget state or launch URLs.

## Mode and State Model

`PortfolioApp` contains the root state machine:

- `_PortfolioMode.animated`
- `_PortfolioMode.flat`

Animated mode specific state:

- `_menuMorphController` + `_menuMorphCurve` control row morph timing.
- `_animatedActiveSection` determines whether overlay panel is visible.
- `_pendingAnimatedSection` coordinates menu-close transition before showing overlay.
- `_animatedExpandedExperienceIndex` tracks expanded experience card in overlay.

Flat mode specific state:

- `_isFlatMenuOpen` controls section menu visibility in flat mode.
- In `FlatPortfolioView`, `_activeSection` + `_sectionKeys` drive section highlighting and scroll targeting.

## Behavioral Invariants

- App boot always starts in animated mode.
- Switching modes resets mode-specific transient state.
- Animated menu interaction is gated; menu taps are ignored until menu is sufficiently open.
- In animated overlay scene, row motion must be static (no marquee motion).
- Flat section navigation relies on `PortfolioSectionId` and matching `GlobalKey` mapping.
- Link launching must parse URI safely before `launchUrl`.

## UI Contract Anchors (Test-Sensitive)

The following keys are part of behavioral test contracts and must be treated as stable unless tests are updated intentionally:

- `shared_app_bar`
- `flat_sliver_app_bar`
- `flat_mode_content`
- `animated_mode_content`
- `hamburger_menu_button`
- `flat_section_menu`
- `animated_menu_item_<index>`
- `animated_section_panel_<section>`
- `animated_section_close_button`
- `header_avatar`

## Out-of-Scope Architecture

- Stac-specific `.agents/skills/stac-*` assets are not runtime architecture for this current app implementation.
