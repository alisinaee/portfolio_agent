import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'scrolling_text_row.dart';

class KineticLandingView extends StatelessWidget {
  const KineticLandingView({
    super.key,
    required this.menuProgress,
    required this.isMenuInteractive,
    this.isBackgroundMode = false,
    required this.landingTexts,
    required this.menuItems,
    this.onMenuItemTap,
  });

  final double menuProgress;
  final bool isMenuInteractive;
  final bool isBackgroundMode;
  final List<String> landingTexts;
  final List<String> menuItems;
  final ValueChanged<String>? onMenuItemTap;

  @override
  Widget build(BuildContext context) {
    final safeLandingTexts = landingTexts.isEmpty
        ? const ['ALI SINAEE', 'FLUTTER', 'PORTFOLIO', 'FALT VERSION', 'MENU']
        : landingTexts;

    final rowCount = safeLandingTexts.length;
    final centerStart = (rowCount ~/ 2) - (menuItems.length ~/ 2);
    final centerEnd = centerStart + menuItems.length;

    final normalizedMenuProgress = menuProgress.clamp(0.0, 1.0);
    final sizeProgress = (normalizedMenuProgress / 0.55).clamp(0.0, 1.0);
    final textBlend = ((normalizedMenuProgress - 0.35) / 0.65).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(rowCount, (index) {
        final isCenterRow = index >= centerStart && index < centerEnd;
        final menuIndex = index - centerStart;
        final menuText =
            (isCenterRow && menuIndex >= 0 && menuIndex < menuItems.length)
            ? menuItems[menuIndex]
            : null;

        final isBigger = index % 2 != 0;
        final baseFontSize = isBigger ? 50.0 : 25.0;
        final targetMenuFontSize = 70.0;
        final fontSize = isCenterRow
            ? lerpDouble(baseFontSize, targetMenuFontSize, sizeProgress)!
            : baseFontSize;

        final shouldDimOuterRows =
            !isBackgroundMode && normalizedMenuProgress > 0;
        final isDimmed =
            isBackgroundMode || (shouldDimOuterRows && !isCenterRow);
        final dimOpacity = isBackgroundMode
            ? 0.08
            : lerpDouble(1.0, 0.18, normalizedMenuProgress)!;

        final row = TickerMode(
          enabled: true,
          child: ScrollingTextRow(
            primaryText: safeLandingTexts[index],
            secondaryText: menuText,
            textBlend: isCenterRow ? textBlend : 0,
            fontSize: fontSize,
            moveLeft: index % 2 == 0,
            isDimmed: isDimmed,
            dimOpacity: dimOpacity,
            speedPixelsPerSecond: 52,
            isStatic: index == 0 || index == rowCount - 1,
          ),
        );

        if (menuText != null && isMenuInteractive && !isBackgroundMode) {
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
  }
}
