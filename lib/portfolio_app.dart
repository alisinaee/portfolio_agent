import 'dart:math' as math;

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

class _PortfolioAppState extends State<PortfolioApp>
    with SingleTickerProviderStateMixin {
  _PortfolioMode _mode = _PortfolioMode.animated;
  bool _isFlatMenuOpen = false;

  late final AnimationController _menuMorphController;
  late final Animation<double> _menuMorphCurve;

  PortfolioSectionId? _animatedActiveSection;
  PortfolioSectionId? _pendingAnimatedSection;
  int? _animatedExpandedExperienceIndex;

  List<String> get _landingInfoSeed {
    final phone = _contactValue('phone', fallback: '+989162363723');
    final github = _contactValue('github', fallback: 'github.com/alisinaee');
    final linkedIn = _contactValue(
      'linkedin',
      fallback: 'linkedin.com/in/alisinaee',
    );
    final email = _contactValue('email', fallback: 'alisinaiasl@gmail.com');

    return [
      portfolioSnapshot.fullName.toUpperCase(),
      portfolioSnapshot.headline.toUpperCase(),
      portfolioSnapshot.location.toUpperCase(),
      'STACK • DART • FLUTTER',
      'STACK • CLEAN ARCHITECTURE • BLOC • GETX • RIVERPOD',
      'PHONE • ${phone.toUpperCase()}',
      'GITHUB • ${github.toUpperCase()}',
      'LINKEDIN • ${linkedIn.toUpperCase()}',
      'EMAIL • ${email.toUpperCase()}',
      'MOBILE APP ENGINEERING • ANDROID • IOS • WEB',
    ];
  }

  static const List<String> _animatedMenuItems = [
    'EXPERIENCE',
    'ABOUT',
    'SKILLS',
    'CONTACT',
  ];

  static const Map<String, PortfolioSectionId> _animatedMenuToSection = {
    'EXPERIENCE': PortfolioSectionId.experience,
    'ABOUT': PortfolioSectionId.about,
    'SKILLS': PortfolioSectionId.skills,
    'CONTACT': PortfolioSectionId.contact,
  };

  @override
  void initState() {
    super.initState();
    _menuMorphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _menuMorphCurve = CurvedAnimation(
      parent: _menuMorphController,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
    _menuMorphController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed &&
          _pendingAnimatedSection != null &&
          mounted) {
        setState(() {
          _animatedActiveSection = _pendingAnimatedSection;
          _animatedExpandedExperienceIndex = null;
          _pendingAnimatedSection = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _menuMorphController.dispose();
    super.dispose();
  }

  double get _menuProgress => _menuMorphCurve.value;
  bool get _isAnimatedMenuOpen => _menuMorphController.value > 0.001;
  bool get _isAnimatedMenuInteractive =>
      _animatedSceneState == KineticSceneState.menu && _menuProgress >= 0.75;

  KineticSceneState get _animatedSceneState {
    if (_animatedActiveSection != null) {
      return KineticSceneState.overlay;
    }

    if (_menuProgress >= 0.02) {
      return KineticSceneState.menu;
    }

    return KineticSceneState.landing;
  }

  String _contactValue(String label, {required String fallback}) {
    for (final link in portfolioSnapshot.contactLinks) {
      if (link.label.toLowerCase() == label.toLowerCase()) {
        return link.value;
      }
    }
    return fallback;
  }

  List<String> _buildLandingRows(int rowCount) {
    final seed = _landingInfoSeed;
    if (seed.isEmpty) {
      return List<String>.filled(
        rowCount,
        portfolioSnapshot.fullName.toUpperCase(),
      );
    }

    return List<String>.generate(
      rowCount,
      (index) => seed[index % seed.length],
    );
  }

  KineticLayoutConfig _resolveKineticLayout(Size viewportSize) {
    final width = viewportSize.width;
    final height = viewportSize.height;

    final KineticWidthTier widthTier;
    final int baseRows;
    final int baseMovingRows;
    final int minRows;
    final int maxRows;
    final double baseSmallFont;
    final double baseLargeFont;
    final double menuTargetFont;
    final double baseRowPadding;
    final double expandedMenuRowPadding;
    final double menuHorizontalPadding;

    if (width < 600) {
      widthTier = KineticWidthTier.mobile;
      baseRows = 11;
      baseMovingRows = 6;
      minRows = 9;
      maxRows = 13;
      baseSmallFont = 18;
      baseLargeFont = 30;
      menuTargetFont = 40;
      baseRowPadding = 8;
      expandedMenuRowPadding = 14;
      menuHorizontalPadding = 14;
    } else if (width < 1100) {
      widthTier = KineticWidthTier.tablet;
      baseRows = 15;
      baseMovingRows = 8;
      minRows = 13;
      maxRows = 17;
      baseSmallFont = 20;
      baseLargeFont = 34;
      menuTargetFont = 46;
      baseRowPadding = 10;
      expandedMenuRowPadding = 16;
      menuHorizontalPadding = 18;
    } else {
      widthTier = KineticWidthTier.desktop;
      baseRows = 19;
      baseMovingRows = 10;
      minRows = 17;
      maxRows = 21;
      baseSmallFont = 22;
      baseLargeFont = 40;
      menuTargetFont = 56;
      baseRowPadding = 12;
      expandedMenuRowPadding = 20;
      menuHorizontalPadding = 20;
    }

    var heightAdjustment = 0;
    if (height < 640) {
      heightAdjustment = -2;
    } else if (height < 760) {
      heightAdjustment = -1;
    } else if (height > 1080) {
      heightAdjustment = 2;
    } else if (height > 920) {
      heightAdjustment = 1;
    }

    var rowCount = (baseRows + heightAdjustment).clamp(minRows, maxRows);
    if (rowCount.isEven) {
      rowCount += rowCount < maxRows ? 1 : -1;
    }

    var movingRows = (baseMovingRows + heightAdjustment).clamp(4, rowCount - 1);
    if (movingRows.isOdd) {
      movingRows += movingRows < rowCount - 1 ? 1 : -1;
    }
    movingRows = movingRows.clamp(4, rowCount - 1);

    return KineticLayoutConfig(
      widthTier: widthTier,
      rowCount: rowCount,
      movingCenterRowCount: movingRows,
      baseSmallFontSize: baseSmallFont,
      baseLargeFontSize: baseLargeFont,
      menuTargetFontSize: menuTargetFont,
      baseRowPadding: baseRowPadding,
      expandedMenuRowPadding: expandedMenuRowPadding,
      menuHorizontalPadding: menuHorizontalPadding,
      speedPixelsPerSecond: 45,
    );
  }

  void _setMode(_PortfolioMode mode) {
    if (_mode == mode) {
      return;
    }

    setState(() {
      _mode = mode;
      _isFlatMenuOpen = false;
      _animatedActiveSection = null;
      _pendingAnimatedSection = null;
      _animatedExpandedExperienceIndex = null;
    });
    _menuMorphController.value = 0;
  }

  Future<void> _toggleHamburger() async {
    if (_mode == _PortfolioMode.flat) {
      setState(() {
        _isFlatMenuOpen = !_isFlatMenuOpen;
      });
      return;
    }

    if (_menuMorphController.isAnimating) {
      return;
    }

    if (_isAnimatedMenuOpen) {
      _pendingAnimatedSection = null;
      await _menuMorphController.reverse();
      return;
    }

    if (_animatedActiveSection != null) {
      setState(() {
        _animatedActiveSection = null;
        _animatedExpandedExperienceIndex = null;
      });
    }

    await _menuMorphController.forward();
  }

  Future<void> _openAnimatedSectionFromMenu(String label) async {
    if (!_isAnimatedMenuInteractive) {
      return;
    }

    final section = _animatedMenuToSection[label];
    if (section == null) {
      return;
    }

    _pendingAnimatedSection = section;

    if (_menuMorphController.isAnimating) {
      return;
    }

    await _menuMorphController.reverse();
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
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isCompact = viewportWidth < 760;
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
              overflow: TextOverflow.ellipsis,
            ),
          ),
          OutlinedButton(
            key: const Key('animated_mode_button'),
            onPressed: () => _setMode(_PortfolioMode.animated),
            style: OutlinedButton.styleFrom(
              backgroundColor: _mode == _PortfolioMode.animated
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.transparent,
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 8 : 14,
                vertical: 10,
              ),
              minimumSize: Size(0, isCompact ? 34 : 40),
            ),
            child: Text(isCompact ? 'ANIM' : 'ANIMATED'),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            key: const Key('flat_mode_button'),
            onPressed: () => _setMode(_PortfolioMode.flat),
            style: OutlinedButton.styleFrom(
              backgroundColor: _mode == _PortfolioMode.flat
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.transparent,
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 8 : 14,
                vertical: 10,
              ),
              minimumSize: Size(0, isCompact ? 34 : 40),
            ),
            child: Text(isCompact ? 'FLAT' : 'FALT VERSION'),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: _menuMorphController,
            builder: (context, child) {
              final animatedMenuOpen =
                  _mode == _PortfolioMode.animated && _isAnimatedMenuOpen;
              return IconButton(
                key: const Key('hamburger_menu_button'),
                iconSize: 34,
                icon: Icon(
                  isFlat
                      ? (isMenuOpen ? Icons.close : Icons.menu)
                      : (animatedMenuOpen ? Icons.close : Icons.menu),
                  color: Colors.white,
                ),
                onPressed: _toggleHamburger,
              );
            },
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

    return LayoutBuilder(
      key: const Key('animated_mode_content'),
      builder: (context, constraints) {
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
        final layoutConfig = _resolveKineticLayout(viewportSize);
        final landingRows = _buildLandingRows(layoutConfig.rowCount);
        final diagonal = math.sqrt(
          (viewportSize.width * viewportSize.width) +
              (viewportSize.height * viewportSize.height),
        );
        final rotatedExtent = diagonal + 320;

        return Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Transform.rotate(
                  angle: -15 * 3.1415926535 / 180,
                  child: OverflowBox(
                    maxWidth: rotatedExtent,
                    maxHeight: rotatedExtent,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 160),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: SizedBox(
                        key: ValueKey(layoutConfig.signature),
                        width: rotatedExtent,
                        child: AnimatedBuilder(
                          animation: _menuMorphController,
                          builder: (context, _) {
                            return KineticLandingView(
                              menuProgress: _menuProgress,
                              sceneState: _animatedSceneState,
                              layoutConfig: layoutConfig,
                              isMenuInteractive: _isAnimatedMenuInteractive,
                              landingTexts: landingRows,
                              menuItems: _animatedMenuItems,
                              onMenuItemTap: _openAnimatedSectionFromMenu,
                            );
                          },
                        ),
                      ),
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
