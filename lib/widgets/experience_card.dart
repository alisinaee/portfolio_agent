import 'package:flutter/material.dart';

import '../models/portfolio_models.dart';

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onToggle,
    required this.onOpenLink,
  });

  final ExperienceItem item;
  final bool isExpanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onOpenLink;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.role,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.company} · ${item.location}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.78,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.period,
                          style: theme.textTheme.labelLarge?.copyWith(
                            letterSpacing: 0.7,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.72,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: onToggle,
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      side: BorderSide(color: theme.colorScheme.outline),
                    ),
                    child: Text(isExpanded ? 'Hide Details' : 'View Details'),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: isExpanded
                ? Container(
                    key: ValueKey('expanded-${item.role}'),
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: theme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        _InfoBlock(
                          label: 'Project',
                          content: Text(
                            item.project,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _InfoBlock(
                          label: 'Project Summary',
                          content: Text(
                            item.projectSummary,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        _InfoBlock(
                          label: 'Responsibilities',
                          content: _BulletList(items: item.responsibilities),
                        ),
                        _InfoBlock(
                          label: 'Architecture & Tools',
                          content: _BulletList(
                            items: item.architectureAndTools,
                          ),
                        ),
                        _InfoBlock(
                          label: 'Platforms',
                          content: Text(
                            item.platforms,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        _InfoBlock(
                          label: 'Technologies',
                          content: _PillWrap(items: item.technologies),
                        ),
                        if (item.relatedLinks.isNotEmpty)
                          _InfoBlock(
                            label: 'Links',
                            content: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: item.relatedLinks.map((link) {
                                return OutlinedButton(
                                  onPressed: () {
                                    final url = link.url;
                                    if (url == null) {
                                      return;
                                    }
                                    onOpenLink(url);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(),
                                    side: BorderSide(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  child: Text(link.label),
                                );
                              }).toList(),
                            ),
                          ),
                        if (item.keyAchievements.isNotEmpty)
                          _InfoBlock(
                            label: 'Key Achievements',
                            content: _BulletList(items: item.keyAchievements),
                          ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.label, required this.content});

  final String label;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 0.7,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 6),
          content,
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text('• $item', style: theme.textTheme.bodyMedium),
        );
      }).toList(),
    );
  }
}

class _PillWrap extends StatelessWidget {
  const _PillWrap({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline, width: 1),
          ),
          child: Text(item, style: theme.textTheme.bodySmall),
        );
      }).toList(),
    );
  }
}
