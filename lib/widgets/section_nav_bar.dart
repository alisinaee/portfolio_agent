import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';

class SectionNavBar extends StatelessWidget {
  const SectionNavBar({
    super.key,
    required this.labels,
    required this.activeSection,
    required this.onTap,
  });

  final Map<PortfolioSectionId, String> labels;
  final PortfolioSectionId activeSection;
  final ValueChanged<PortfolioSectionId> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline, width: 1),
          bottom: BorderSide(color: theme.colorScheme.outline, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: labels.entries.map((entry) {
            final isActive = entry.key == activeSection;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: OutlinedButton(
                onPressed: () => onTap(entry.key),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isActive
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.outline,
                    width: 1,
                  ),
                  backgroundColor: isActive
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.08)
                      : Colors.transparent,
                  foregroundColor: theme.colorScheme.onSurface,
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: const RoundedRectangleBorder(),
                ),
                child: Text(
                  entry.value,
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
