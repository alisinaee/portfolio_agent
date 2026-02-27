import 'package:flutter/material.dart';
import 'scrolling_text_row.dart';

class KineticLandingView extends StatelessWidget {
  final bool isMenuOpen;

  const KineticLandingView({super.key, this.isMenuOpen = false});

  final List<String> landingTexts = const [
    "HELLO WORLD",
    "ALI SINAEE",
    "SENIOR FLUTTER DEVELOPER",
    "MINIMALIST DESIGN",
    "CREATIVE CODER",
    "GITHUB.COM/ALISINAEE",
    "UI / UX ENTHUSIAST",
    "LINKEDIN.COM/IN/ALISINAEE",
    "MOBILE APPLICATIONS",
    "EMAIL@EXAMPLE.COM",
    "KINETIC TYPOGRAPHY",
    "PHONE +123 456 7890",
    "DARK MODE ONLY",
    "AVANT-GARDE PORTFOLIOS",
    "AVAILABLE FOR WORK",
  ];

  final List<String> menuItems = const [
    "WORK",
    "ABOUT",
    "SKILLS",
    "CONTACT",
    "RESUME",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Hug content vertically
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(15, (index) {
        // determine if row is one of the 5 center rows (indices 5, 6, 7, 8, 9)
        final isCenterRow = index >= 5 && index <= 9;

        // Determine the text for this row
        String rowText = landingTexts[index];
        if (isMenuOpen && isCenterRow) {
          rowText = menuItems[index - 5];
        }

        // Determine font size
        // Normal row: every second row is bigger.
        final isBigger = index % 2 != 0;
        double fontSize = isBigger ? 50.0 : 25.0;

        // If menu is open and it's a center row, scale it up massively
        if (isMenuOpen && isCenterRow) {
          fontSize = 70.0;
        }

        // Determine dimming
        // If menu is open, outer rows dim out
        final isDimmed = isMenuOpen && !isCenterRow;

        final moveLeft = index % 2 == 0;

        return TickerMode(
          enabled: !isDimmed,
          child: ScrollingTextRow(
            text: rowText,
            fontSize: fontSize,
            moveLeft: moveLeft,
            isDimmed: isDimmed,
          ),
        );
      }),
    );
  }
}
