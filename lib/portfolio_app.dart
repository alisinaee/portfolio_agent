import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/portfolio_snapshot.dart';
import 'models/portfolio_models.dart';
import 'portfolio_flat_page.dart';
import 'widgets/experience_card.dart';
import 'widgets/key_value_block.dart';
import 'widgets/kinetic_landing_view.dart';

enum _PortfolioMode { animated, flat }

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  _PortfolioMode _mode = _PortfolioMode.animated;
  bool _isAnimatedMenuOpen = false;
  bool _isAnimatedMenuTextVisible = false;
  bool _isAnimatedMenuTransitioning = false;
  bool _isFlatMenuOpen = false;

  PortfolioSectionId? _animatedActiveSection;
  int? _animatedExpandedExperienceIndex;

  List<String> get _landingTexts => [
    portfolioSnapshot.fullName.toUpperCase(),
    portfolioSnapshot.headline.toUpperCase(),
    portfolioSnapshot.location.toUpperCase(),
    'DART • FLUTTER • CLEAN ARCHITECTURE',
    'BLOC • GETX • PROVIDER • RIVERPOD',
    'HOME PALETTE • AI DECOR & DESIGN',
    'TOBANK • DIGITAL BANKING PLATFORM',
    'DUSK VPN • MULTI PLATFORM',
    'HAMKELASI • EDUCATIONAL SUPER APP',
    'ABAN VPN • GLOBAL NETWORK',
    'RADAR GPS • TRACKING & IOT',
    '100K+ DOWNLOADS • MILLIONS OF USERS',
    'GITHUB.COM/ALISINAEE',
    'LINKEDIN.COM/IN/ALISINAEE',
    'ALISINAIASL@GMAIL.COM',
  ];

  static const List<String> _animatedMenuItems = [
    'EXPERIENCE',
    'ABOUT',
    'SKILLS',
    'CONTACT',
    'CLOSE',
  ];

  static const Map<String, PortfolioSectionId> _animatedMenuToSection = {
    'EXPERIENCE': PortfolioSectionId.experience,
    'ABOUT': PortfolioSectionId.about,
    'SKILLS': PortfolioSectionId.skills,
    'CONTACT': PortfolioSectionId.contact,
  };

  void _setMode(_PortfolioMode mode) {
    if (_mode == mode) {
      return;
    }

    setState(() {
      _mode = mode;
      _isAnimatedMenuOpen = false;
      _isAnimatedMenuTextVisible = false;
      _isAnimatedMenuTransitioning = false;
      _isFlatMenuOpen = false;
      _animatedActiveSection = null;
      _animatedExpandedExperienceIndex = null;
    });
  }

  Future<void> _setAnimatedMenuOpen(bool open) async {
    if (_isAnimatedMenuTransitioning || !mounted) {
      return;
    }

    setState(() {
      _isAnimatedMenuTransitioning = true;
    });

    if (open) {
      setState(() {
        _isAnimatedMenuOpen = true;
      });

      await Future<void>.delayed(const Duration(milliseconds: 240));
      if (!mounted) {
        return;
      }

      setState(() {
        _isAnimatedMenuTextVisible = true;
        _isAnimatedMenuTransitioning = false;
      });
      return;
    }

    setState(() {
      _isAnimatedMenuTextVisible = false;
    });

    await Future<void>.delayed(const Duration(milliseconds: 240));
    if (!mounted) {
      return;
    }

    setState(() {
      _isAnimatedMenuOpen = false;
      _isAnimatedMenuTransitioning = false;
    });
  }

  Future<void> _toggleHamburger() async {
    if (_mode == _PortfolioMode.flat) {
      setState(() {
        _isFlatMenuOpen = !_isFlatMenuOpen;
      });
      return;
    }

    await _setAnimatedMenuOpen(!_isAnimatedMenuOpen);
  }

  Future<void> _openAnimatedSectionFromMenu(String label) async {
    if (label == 'CLOSE') {
      await _setAnimatedMenuOpen(false);
      return;
    }

    final section = _animatedMenuToSection[label];
    if (section == null) {
      return;
    }

    await _setAnimatedMenuOpen(false);
    if (!mounted) {
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) {
      return;
    }

    setState(() {
      _animatedActiveSection = section;
      _animatedExpandedExperienceIndex = null;
    });
  }

  void _closeAnimatedSectionOverlay() {
    setState(() {
      _animatedActiveSection = null;
      _animatedExpandedExperienceIndex = null;
    });
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }

    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  String _animatedSectionTitle(PortfolioSectionId section) {
    switch (section) {
      case PortfolioSectionId.about:
        return 'About';
      case PortfolioSectionId.contact:
        return 'Contact';
      case PortfolioSectionId.experience:
        return 'Experience';
      case PortfolioSectionId.skills:
        return 'Skills';
      case PortfolioSectionId.achievements:
      case PortfolioSectionId.packages:
      case PortfolioSectionId.focus:
        return 'Section';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildSharedAppBar(context),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _mode == _PortfolioMode.animated
                    ? _buildAnimatedMode(context)
                    : _buildFlatMode(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isFlat = _mode == _PortfolioMode.flat;
    final isMenuOpen = isFlat ? _isFlatMenuOpen : _isAnimatedMenuOpen;

    return Container(
      key: const Key('shared_app_bar'),
      height: 72,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              portfolioSnapshot.fullName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
          OutlinedButton(
            key: const Key('animated_mode_button'),
            onPressed: () => _setMode(_PortfolioMode.animated),
            style: OutlinedButton.styleFrom(
              backgroundColor: _mode == _PortfolioMode.animated
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.transparent,
            ),
            child: const Text('ANIMATED'),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            key: const Key('flat_mode_button'),
            onPressed: () => _setMode(_PortfolioMode.flat),
            style: OutlinedButton.styleFrom(
              backgroundColor: _mode == _PortfolioMode.flat
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.transparent,
            ),
            child: const Text('FALT VERSION'),
          ),
          const SizedBox(width: 8),
          IconButton(
            key: const Key('hamburger_menu_button'),
            iconSize: 34,
            icon: Icon(
              isMenuOpen ? Icons.close : Icons.menu,
              color: Colors.white,
            ),
            onPressed: _toggleHamburger,
          ),
        ],
      ),
    );
  }

  Widget _buildFlatMode() {
    return FlatPortfolioView(
      key: const Key('flat_mode_content'),
      isMenuOpen: _isFlatMenuOpen,
      onCloseMenu: () {
        setState(() {
          _isFlatMenuOpen = false;
        });
      },
    );
  }

  Widget _buildAnimatedMode(BuildContext context) {
    final theme = Theme.of(context);
    final isBackgroundMode = _animatedActiveSection != null;

    return LayoutBuilder(
      key: const Key('animated_mode_content'),
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Transform.rotate(
                  angle: -15 * 3.1415926535 / 180,
                  child: OverflowBox(
                    maxWidth: constraints.maxWidth * 2 + 1000,
                    maxHeight: double.infinity,
                    child: KineticLandingView(
                      isMenuOpen: _isAnimatedMenuOpen,
                      showMenuText: _isAnimatedMenuTextVisible,
                      isBackgroundMode: isBackgroundMode,
                      landingTexts: _landingTexts,
                      menuItems: _animatedMenuItems,
                      onMenuItemTap: _openAnimatedSectionFromMenu,
                    ),
                  ),
                ),
              ),
            ),
            if (_animatedActiveSection != null)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 1020,
                        maxHeight: constraints.maxHeight - 32,
                      ),
                      child: Container(
                        key: Key(
                          'animated_section_panel_${_animatedActiveSection!.name}',
                        ),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.9,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _animatedSectionTitle(
                                      _animatedActiveSection!,
                                    ),
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                OutlinedButton(
                                  key: const Key(
                                    'animated_section_close_button',
                                  ),
                                  onPressed: _closeAnimatedSectionOverlay,
                                  child: const Text('CLOSE'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Expanded(
                              child: SingleChildScrollView(
                                child: _buildAnimatedSectionContent(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedSectionContent(BuildContext context) {
    final section = _animatedActiveSection;
    if (section == null) {
      return const SizedBox.shrink();
    }

    switch (section) {
      case PortfolioSectionId.about:
        return KeyValueBlock(fields: portfolioSnapshot.profile.fields);
      case PortfolioSectionId.contact:
        return _buildAnimatedContactContent(context);
      case PortfolioSectionId.experience:
        return _buildAnimatedExperienceContent();
      case PortfolioSectionId.skills:
        return _buildAnimatedSkillsContent(context);
      case PortfolioSectionId.achievements:
      case PortfolioSectionId.packages:
      case PortfolioSectionId.focus:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAnimatedContactContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: portfolioSnapshot.contactLinks.map((link) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline, width: 1),
            borderRadius: BorderRadius.circular(14),
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
                child: const Text('Open'),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnimatedExperienceContent() {
    return Column(
      children: [
        for (var i = 0; i < portfolioSnapshot.experiences.length; i++)
          ExperienceCard(
            item: portfolioSnapshot.experiences[i],
            isExpanded: _animatedExpandedExperienceIndex == i,
            onToggle: () {
              setState(() {
                _animatedExpandedExperienceIndex =
                    _animatedExpandedExperienceIndex == i ? null : i;
              });
            },
            onOpenLink: _openLink,
          ),
      ],
    );
  }

  Widget _buildAnimatedSkillsContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: portfolioSnapshot.skillGroups.map((group) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline, width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(item, style: theme.textTheme.bodySmall),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
