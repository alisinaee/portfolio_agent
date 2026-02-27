import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'scrolling_text_row.dart';

enum KineticSceneState { landing, menu, overlay }

enum KineticWidthTier { mobile, tablet, desktop }

@immutable
class KineticLayoutConfig {
  const KineticLayoutConfig({
    required this.widthTier,
    required this.rowCount,
    required this.movingCenterRowCount,
    required this.baseSmallFontSize,
    required this.baseLargeFontSize,
    required this.menuTargetFontSize,
    required this.baseRowPadding,
    required this.expandedMenuRowPadding,
    required this.menuHorizontalPadding,
    required this.speedPixelsPerSecond,
  });

  final KineticWidthTier widthTier;
  final int rowCount;
  final int movingCenterRowCount;
  final double baseSmallFontSize;
  final double baseLargeFontSize;
  final double menuTargetFontSize;
  final double baseRowPadding;
  final double expandedMenuRowPadding;
  final double menuHorizontalPadding;
  final double speedPixelsPerSecond;

  String get signature =>
      '${widthTier.name}_${rowCount}_${movingCenterRowCount}_$menuTargetFontSize';
}

class KineticLandingView extends StatelessWidget {
  const KineticLandingView({
    super.key,
    required this.menuProgress,
    required this.sceneState,
    required this.layoutConfig,
    required this.isMenuInteractive,
    required this.landingTexts,
    required this.menuItems,
    this.onMenuItemTap,
  });

  final double menuProgress;
  final KineticSceneState sceneState;
  final KineticLayoutConfig layoutConfig;
  final bool isMenuInteractive;
  final List<String> landingTexts;
  final List<String> menuItems;
  final ValueChanged<String>? onMenuItemTap;

  @override
  Widget build(BuildContext context) {
    final safeLandingTexts = landingTexts.isEmpty
        ? const ['ALI SINAEE', 'FLUTTER', 'PORTFOLIO', 'FALT VERSION', 'MENU']
        : landingTexts;

    final rowCount = layoutConfig.rowCount;
    final menuRowCount = menuItems.length;

    final menuCenterStart = ((rowCount - menuRowCount) / 2).floor();
    final menuCenterEnd = menuCenterStart + menuRowCount;

    final movingCount = layoutConfig.movingCenterRowCount.clamp(
      menuRowCount,
      rowCount,
    );
    final movingCenterStart = ((rowCount - movingCount) / 2).floor();
    final movingCenterEnd = movingCenterStart + movingCount;

    final normalizedMenuProgress = menuProgress.clamp(0.0, 1.0);
    final sizeProgress = (normalizedMenuProgress / 0.55).clamp(0.0, 1.0);
    final textBlend = ((normalizedMenuProgress - 0.62) / 0.38).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        var estimatedHeight = 0.0;

        for (var index = 0; index < rowCount; index++) {
          final isMenuRow = index >= menuCenterStart && index < menuCenterEnd;
          final isBigger = index.isOdd;
          final baseFontSize = isBigger
              ? layoutConfig.baseLargeFontSize
              : layoutConfig.baseSmallFontSize;
          final textScale = isMenuRow
              ? lerpDouble(
                  1.0,
                  layoutConfig.menuTargetFontSize / baseFontSize,
                  sizeProgress,
                )!
              : 1.0;
          final rowPadding = isMenuRow
              ? lerpDouble(
                  layoutConfig.baseRowPadding,
                  layoutConfig.expandedMenuRowPadding,
                  sizeProgress,
                )!
              : layoutConfig.baseRowPadding;

          estimatedHeight += (baseFontSize * textScale) + (rowPadding * 2) + 1;
        }

        final maxHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : estimatedHeight;
        final fitScale = estimatedHeight <= maxHeight
            ? 1.0
            : (maxHeight / estimatedHeight).clamp(0.62, 1.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(rowCount, (index) {
            final isMenuRow = index >= menuCenterStart && index < menuCenterEnd;
            final isMovingCenterRow =
                index >= movingCenterStart && index < movingCenterEnd;

            final menuIndex = index - menuCenterStart;
            final menuText =
                (isMenuRow && menuIndex >= 0 && menuIndex < menuItems.length)
                ? menuItems[menuIndex]
                : null;

            final isBigger = index.isOdd;
            final baseFontSize = isBigger
                ? layoutConfig.baseLargeFontSize
                : layoutConfig.baseSmallFontSize;

            final textScale = isMenuRow
                ? lerpDouble(
                    1.0,
                    layoutConfig.menuTargetFontSize / baseFontSize,
                    sizeProgress,
                  )!
                : 1.0;

            final rowPadding = isMenuRow
                ? lerpDouble(
                    layoutConfig.baseRowPadding,
                    layoutConfig.expandedMenuRowPadding,
                    sizeProgress,
                  )!
                : layoutConfig.baseRowPadding;

            final isOverlayScene = sceneState == KineticSceneState.overlay;
            final isMenuScene = sceneState == KineticSceneState.menu;
            final isLandingScene = sceneState == KineticSceneState.landing;

            final motionMode = isLandingScene && isMovingCenterRow
                ? RowMotionMode.marquee
                : RowMotionMode.staticHold;

            final textPresentationMode = isMenuScene && isMenuRow
                ? RowTextPresentationMode.centeredBlend
                : RowTextPresentationMode.marqueeBlend;

            bool isDimmed = false;
            var dimOpacity = 1.0;

            if (isOverlayScene) {
              isDimmed = true;
              dimOpacity = 0.08;
            } else if (isMenuScene && !isMenuRow) {
              isDimmed = true;
              dimOpacity = lerpDouble(1.0, 0.18, normalizedMenuProgress)!;
            }

            final row = ScrollingTextRow(
              key: Key('kinetic_row_$index'),
              primaryText: safeLandingTexts[index % safeLandingTexts.length],
              secondaryText: menuText,
              textBlend: isMenuRow ? textBlend : 0,
              fontSize: baseFontSize * fitScale,
              textScale: textScale,
              verticalPadding: rowPadding * fitScale,
              moveLeft: index.isEven,
              isDimmed: isDimmed,
              dimOpacity: dimOpacity,
              speedPixelsPerSecond: layoutConfig.speedPixelsPerSecond,
              motionMode: motionMode,
              textPresentationMode: textPresentationMode,
              centeredHorizontalPadding:
                  layoutConfig.menuHorizontalPadding * fitScale,
            );

            if (menuText != null && isMenuInteractive && isMenuScene) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  key: Key('animated_menu_item_$menuIndex'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onMenuItemTap?.call(menuText),
                  child: row,
                ),
              );
            }

            return row;
          }),
        );
      },
    );
  }
}
