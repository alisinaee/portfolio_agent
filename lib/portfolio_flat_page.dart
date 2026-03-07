import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/portfolio_snapshot.dart';
import 'models/portfolio_models.dart';
import 'widgets/compact_header_bar.dart';
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
    this.onToggleMenu,
    this.onSwitchToAnimated,
    this.onSwitchToFlat,
  });

  final PortfolioSectionId? initialSection;
  final bool isMenuOpen;
  final VoidCallback? onCloseMenu;
  final VoidCallback? onToggleMenu;
  final VoidCallback? onSwitchToAnimated;
  final VoidCallback? onSwitchToFlat;

  @override
  State<FlatPortfolioView> createState() => _FlatPortfolioViewState();
}

class _FlatPortfolioViewState extends State<FlatPortfolioView> {
  static const double _flatExpandedAppBarHeight = 236;
  static const double _flatToolbarHeight = 72;

  final ScrollController _scrollController = ScrollController();
  int? _expandedExperienceIndex;
  PortfolioSectionId _activeSection = PortfolioSectionId.about;
  bool _showCompactHeader = false;

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
      duration: const Duration(milliseconds: 180),
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
    final collapseThreshold = _flatExpandedAppBarHeight - _flatToolbarHeight;
    final shouldShowCompact =
        _scrollController.hasClients &&
        _scrollController.offset > (collapseThreshold - 12);

    const threshold = 210.0;
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
      if (topOffset > threshold + 80) {
        continue;
      }

      final distance = (threshold - topOffset).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        candidate = entry.key;
      }
    }

    if (!mounted) {
      return;
    }

    final shouldUpdateSection =
        candidate != null && candidate != _activeSection;
    final shouldUpdateHeader = shouldShowCompact != _showCompactHeader;
    if (!shouldUpdateSection && !shouldUpdateHeader) {
      return;
    }

    setState(() {
      if (shouldUpdateSection) {
        _activeSection = candidate!;
      }
      if (shouldUpdateHeader) {
        _showCompactHeader = shouldShowCompact;
      }
    });
  }

  Widget _buildSliverFlexibleBackground(BuildContext context) {
    final collapseRange = _flatExpandedAppBarHeight - _flatToolbarHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        final currentHeight = constraints.biggest.height;
        final t = ((currentHeight - _flatToolbarHeight) / collapseRange).clamp(
          0.0,
          1.0,
        );

        return Opacity(opacity: t, child: _buildExpandedHeader(context));
      },
    );
  }

  Widget _buildCollapsedHeader(BuildContext context, bool isCompact) {
    return AnimatedOpacity(
      opacity: _showCompactHeader ? 1 : 0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: IgnorePointer(
        ignoring: !_showCompactHeader,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CompactHeaderBar(
            fullName: portfolioSnapshot.fullName,
            avatarImageUrl: portfolioSnapshot.avatarImageUrl,
            isCompact: isCompact,
            isAnimatedSelected: false,
            isFlatSelected: true,
            isMenuOpen: widget.isMenuOpen,
            onAnimatedTap: () {
              widget.onSwitchToAnimated?.call();
            },
            onFlatTap: () {
              widget.onSwitchToFlat?.call();
            },
            onMenuTap: () {
              widget.onToggleMenu?.call();
            },
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_scrollController.hasClients && _scrollController.offset <= 1) {
        setState(() {
          _showCompactHeader = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant FlatPortfolioView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMenuOpen != widget.isMenuOpen && mounted) {
      if (widget.isMenuOpen && _scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      }
      setState(() {});
    }
  }

  Widget _buildExpandedHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: const Key('flat_expanded_header'),
      color: Colors.black.withValues(alpha: 0.50),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ClipRect(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                            onPressed: widget.onSwitchToAnimated,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              minimumSize: const Size(0, 40),
                            ),
                            child: const Text('ANIM'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: widget.onSwitchToFlat,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.08,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              minimumSize: const Size(0, 40),
                            ),
                            child: const Text('FLAT'),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            iconSize: 34,
                            icon: Icon(
                              widget.isMenuOpen ? Icons.close : Icons.menu,
                              color: Colors.white,
                            ),
                            onPressed: widget.onToggleMenu,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        PortfolioAvatar(
                          key: const Key('flat_expanded_avatar'),
                          fullName: portfolioSnapshot.fullName,
                          imageUrl: portfolioSnapshot.avatarImageUrl,
                          radius: 46,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                portfolioSnapshot.fullName,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                portfolioSnapshot.headline,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.86),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                portfolioSnapshot.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  letterSpacing: 0.6,
                                  color: Colors.white.withValues(alpha: 0.72),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: theme.colorScheme.outline.withValues(alpha: 0.8),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'MENU',
                      style: theme.textTheme.labelLarge?.copyWith(
                        letterSpacing: 1.4,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isCompact = viewportWidth < 760;

    return CustomScrollView(
      key: const Key('portfolio_scroll_view'),
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          key: const Key('flat_sliver_app_bar'),
          pinned: true,
          floating: false,
          expandedHeight: _flatExpandedAppBarHeight,
          toolbarHeight: _flatToolbarHeight,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _buildSliverFlexibleBackground(context),
          ),
          title: _buildCollapsedHeader(context, isCompact),
        ),
        if (widget.isMenuOpen)
          SliverToBoxAdapter(
            child: Padding(
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
          ),
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
