import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/portfolio_snapshot.dart';
import 'models/portfolio_models.dart';
import 'widgets/experience_card.dart';
import 'widgets/key_value_block.dart';
import 'widgets/section_container.dart';
import 'widgets/section_nav_bar.dart';

class FlatPortfolioView extends StatefulWidget {
  const FlatPortfolioView({
    super.key,
    this.initialSection,
    this.isMenuOpen = false,
    this.onCloseMenu,
  });

  final PortfolioSectionId? initialSection;
  final bool isMenuOpen;
  final VoidCallback? onCloseMenu;

  @override
  State<FlatPortfolioView> createState() => _FlatPortfolioViewState();
}

class _FlatPortfolioViewState extends State<FlatPortfolioView> {
  final ScrollController _scrollController = ScrollController();
  int? _expandedExperienceIndex;
  PortfolioSectionId _activeSection = PortfolioSectionId.about;

  late final Map<PortfolioSectionId, GlobalKey> _sectionKeys = {
    for (final section in PortfolioSectionId.values) section: GlobalKey(),
  };

  static const Map<PortfolioSectionId, String> _sectionLabels = {
    PortfolioSectionId.about: 'About',
    PortfolioSectionId.contact: 'Contact',
    PortfolioSectionId.experience: 'Experience',
    PortfolioSectionId.skills: 'Skills',
    PortfolioSectionId.achievements: 'Achievements',
    PortfolioSectionId.packages: 'Packages',
    PortfolioSectionId.focus: 'Current Focus',
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveSection);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialSection = widget.initialSection;
      if (initialSection == null) {
        return;
      }
      _scrollToSection(initialSection);
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateActiveSection)
      ..dispose();
    super.dispose();
  }

  Future<void> _scrollToSection(PortfolioSectionId section) async {
    final context = _sectionKeys[section]?.currentContext;
    if (context == null) {
      return;
    }

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      alignment: 0.08,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _activeSection = section;
    });
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  void _updateActiveSection() {
    const threshold = 180.0;
    PortfolioSectionId? candidate;
    var bestDistance = double.infinity;

    for (final entry in _sectionKeys.entries) {
      final context = entry.value.currentContext;
      if (context == null) {
        continue;
      }

      final renderBox = context.findRenderObject();
      if (renderBox is! RenderBox || !renderBox.hasSize) {
        continue;
      }

      final topOffset = renderBox.localToGlobal(Offset.zero).dy;
      if (topOffset > threshold + 60) {
        continue;
      }

      final distance = (threshold - topOffset).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        candidate = entry.key;
      }
    }

    if (candidate != null && candidate != _activeSection && mounted) {
      setState(() {
        _activeSection = candidate!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('flat_view'),
      children: [
        if (widget.isMenuOpen)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SizedBox(
              key: const Key('flat_section_menu'),
              width: double.infinity,
              child: SectionNavBar(
                labels: _sectionLabels,
                activeSection: _activeSection,
                onTap: (section) {
                  _scrollToSection(section);
                  widget.onCloseMenu?.call();
                },
              ),
            ),
          ),
        Expanded(
          child: CustomScrollView(
            key: const Key('portfolio_scroll_view'),
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeroSection(context),
                          const SizedBox(height: 14),
                          _buildAboutSection(),
                          const SizedBox(height: 14),
                          _buildContactSection(),
                          const SizedBox(height: 14),
                          _buildExperienceSection(),
                          const SizedBox(height: 14),
                          _buildSkillsSection(),
                          const SizedBox(height: 14),
                          _buildAchievementsSection(),
                          const SizedBox(height: 14),
                          _buildPackagesSection(),
                          const SizedBox(height: 14),
                          _buildCurrentFocusSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final theme = Theme.of(context);

    return SectionContainer(
      title: 'Hero',
      subtitle: 'Senior Flutter portfolio snapshot',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            portfolioSnapshot.fullName,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 10),
          Text(portfolioSnapshot.headline, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            portfolioSnapshot.location,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => _openLink(portfolioSnapshot.resumeUrl),
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                ),
                child: const Text('Download Resume'),
              ),
              ...portfolioSnapshot.heroLinks.map((link) {
                return OutlinedButton(
                  onPressed: () {
                    final url = link.url;
                    if (url == null) {
                      return;
                    }
                    _openLink(url);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: Text(link.label),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      key: _sectionKeys[PortfolioSectionId.about],
      child: SectionContainer(
        title: 'About',
        child: KeyValueBlock(fields: portfolioSnapshot.profile.fields),
      ),
    );
  }

  Widget _buildContactSection() {
    final theme = Theme.of(context);

    return Container(
      key: _sectionKeys[PortfolioSectionId.contact],
      child: SectionContainer(
        title: 'Contact',
        child: Column(
          children: portfolioSnapshot.contactLinks.map((link) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          link.label,
                          style: theme.textTheme.labelLarge?.copyWith(
                            letterSpacing: 0.7,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.75,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(link.value, style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      final url = link.url;
                      if (url == null) {
                        return;
                      }
                      _openLink(url);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('Open'),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return Container(
      key: _sectionKeys[PortfolioSectionId.experience],
      child: SectionContainer(
        title: 'Experience',
        subtitle: 'Compact timeline with expandable details',
        child: Column(
          children: [
            for (var i = 0; i < portfolioSnapshot.experiences.length; i++)
              ExperienceCard(
                item: portfolioSnapshot.experiences[i],
                isExpanded: _expandedExperienceIndex == i,
                onToggle: () {
                  setState(() {
                    _expandedExperienceIndex = _expandedExperienceIndex == i
                        ? null
                        : i;
                  });
                },
                onOpenLink: _openLink,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      key: _sectionKeys[PortfolioSectionId.skills],
      child: SectionContainer(
        title: 'Technical Skills',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: portfolioSnapshot.skillGroups.map((group) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _SkillGroupView(group: group),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      key: _sectionKeys[PortfolioSectionId.achievements],
      child: SectionContainer(
        title: 'Key Achievements',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: portfolioSnapshot.achievementGroups.map((group) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AchievementGroupView(group: group),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPackagesSection() {
    return Container(
      key: _sectionKeys[PortfolioSectionId.packages],
      child: SectionContainer(
        title: portfolioSnapshot.packageGroup.title,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: portfolioSnapshot.packageGroup.groups.map((group) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _SkillGroupView(group: group),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCurrentFocusSection() {
    final theme = Theme.of(context);

    return Container(
      key: _sectionKeys[PortfolioSectionId.focus],
      child: SectionContainer(
        title: 'Current Focus',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: portfolioSnapshot.currentFocus.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('• $item', style: theme.textTheme.bodyLarge),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SkillGroupView extends StatelessWidget {
  const _SkillGroupView({required this.group});

  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.subtitle == null
              ? group.title
              : '${group.title} · ${group.subtitle}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: group.items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline, width: 1),
              ),
              child: Text(item, style: theme.textTheme.bodySmall),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AchievementGroupView extends StatelessWidget {
  const _AchievementGroupView({required this.group});

  final AchievementGroup group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...group.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('• $item', style: theme.textTheme.bodyMedium),
            );
          }),
        ],
      ),
    );
  }
}
