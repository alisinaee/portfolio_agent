import 'package:flutter/material.dart';

import 'scrolling_text_row.dart';

class KineticLandingView extends StatelessWidget {
  const KineticLandingView({
    super.key,
    required this.isMenuOpen,
    this.showMenuText = false,
    this.isBackgroundMode = false,
    required this.landingTexts,
    required this.menuItems,
    this.onMenuItemTap,
  });

  final bool isMenuOpen;
  final bool showMenuText;
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(rowCount, (index) {
        final isCenterRow = index >= centerStart && index < centerEnd;
        final menuIndex = index - centerStart;

        var rowText = safeLandingTexts[index];
        if (showMenuText &&
            !isBackgroundMode &&
            isCenterRow &&
            menuIndex >= 0 &&
            menuIndex < menuItems.length) {
          rowText = menuItems[menuIndex];
        }

        final isBigger = index % 2 != 0;
        var fontSize = isBigger ? 50.0 : 25.0;

        if (isMenuOpen && !isBackgroundMode && isCenterRow) {
          fontSize = 70.0;
        }

        final isDimmed = isBackgroundMode || (isMenuOpen && !isCenterRow);
        final moveLeft = index % 2 == 0;

        Widget row = TickerMode(
          enabled: isBackgroundMode ? true : !isDimmed,
          child: ScrollingTextRow(
            text: rowText,
            fontSize: fontSize,
            moveLeft: moveLeft,
            isDimmed: isDimmed,
            dimOpacity: isBackgroundMode ? 0.1 : 0.15,
          ),
        );

        if (showMenuText &&
            !isBackgroundMode &&
            isCenterRow &&
            menuIndex >= 0 &&
            menuIndex < menuItems.length) {
          final itemLabel = menuItems[menuIndex];
          row = MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              key: Key('animated_menu_item_$menuIndex'),
              behavior: HitTestBehavior.opaque,
              onTap: () => onMenuItemTap?.call(itemLabel),
              child: row,
            ),
          );
        }

        return row;
      }),
    );
  }
}
