# Project Overview

## Product Goal

This project is a Flutter portfolio application with two user-facing presentation modes:

- Animated kinetic landing mode.
- Flat long-form section mode.

The app displays one typed content snapshot (`portfolioSnapshot`) across both modes.

## Runtime Platforms

This repository targets standard Flutter multi-platform outputs:

- Android
- iOS
- Web
- macOS
- Linux
- Windows

## Deployment Endpoints

- Live site: `https://portfolio-agent-61729.web.app`
- Firebase hosting target from `.firebaserc`: `portfolio-agent-61729`
- Hosting config (`firebase.json`) serves `build/web` with SPA rewrite to `/index.html`

## Core Dependencies

The app currently relies on the following direct runtime packages in `pubspec.yaml`:

- `google_fonts`: typography and text theme wiring.
- `url_launcher`: external link launching for contact and resume actions.
- `cupertino_icons`: icon support.

## Assets and Fonts

- Custom font family `BuiltTitlingRgBold` is declared in `pubspec.yaml`.
- Font file path: `assets/built-titling.rg-bold.otf`.
- Web app manifest and icons are under `web/`.

## High-Level Directory Map

```text
lib/
  main.dart                       # App entry and theme wiring
  portfolio_app.dart              # Root state machine (animated vs flat)
  portfolio_flat_page.dart        # Flat mode scroll sections and section tracking
  data/portfolio_snapshot.dart    # Canonical content data source
  models/portfolio_models.dart    # Typed content schema
  widgets/                        # Reusable UI components

test/
  widget_test.dart                # Behavioral widget coverage

docs/
  README.md                       # Agent docs index and routing
  *.md                            # Strict agent guidance

android/ ios/ web/ macos/ linux/ windows/
  Platform runner/config artifacts
```

## Non-Goals for This Docs Suite

- This suite does not define Stac implementation workflows for this app.
- This suite does not replace runtime code or tests as source of behavioral truth.
