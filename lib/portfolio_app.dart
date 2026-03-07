import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/portfolio_snapshot.dart';
import 'models/portfolio_models.dart';
import 'portfolio_flat_page.dart';
import 'widgets/compact_header_bar.dart';
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
      duration: const Duration(milliseconds: 680),
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
      _animatedSceneState == KineticSceneState.menu && _menuProgress >= 0.82;

  KineticSceneState get _animatedSceneState {
    if (_animatedActiveSection != null) {
      return KineticSceneState.overlay;
    }

    if (_menuProgress >= 0.24) {
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
        rowCount + 6,
        portfolioSnapshot.fullName.toUpperCase(),
      );
    }

    final requiredCount = rowCount + 6;
    return List<String>.generate(requiredCount, (index) {
      final steppedIndex = (index * 3 + (index ~/ seed.length)) % seed.length;
      return seed[steppedIndex];
    });
  }

  KineticLayoutConfig _resolveKineticLayout(Size viewportSize) {
    final width = viewportSize.width;
    final height = viewportSize.height;

    final KineticWidthTier widthTier;
    final double baseSmallFont;
    final double menuTargetFont;
    final double baseRowPadding;
    final double expandedMenuRowPadding;
    final double menuHorizontalPadding;
    final double motionFadeThreshold;

    if (width < 600) {
      widthTier = KineticWidthTier.mobile;
      baseSmallFont = 11.0;
      menuTargetFont = 42.0;
      baseRowPadding = 6.0;
      expandedMenuRowPadding = 12.0;
      menuHorizontalPadding = 14.0;
      motionFadeThreshold = 0.30;
    } else if (width < 1100) {
      widthTier = KineticWidthTier.tablet;
      baseSmallFont = 12.5;
      menuTargetFont = 50.0;
      baseRowPadding = 7.0;
      expandedMenuRowPadding = 14.0;
      menuHorizontalPadding = 18.0;
      motionFadeThreshold = 0.28;
    } else {
      widthTier = KineticWidthTier.desktop;
      baseSmallFont = 14.0;
      menuTargetFont = 58.0;
      baseRowPadding = 8.0;
      expandedMenuRowPadding = 16.0;
      menuHorizontalPadding = 22.0;
      motionFadeThreshold = 0.26;
    }

    const largeToSmallRatio = 3.0;
    const rowCount = 10;
    const movingRows = 6;
    const landingRotationDegrees = 15.0;

    final diagonal = math.sqrt((width * width) + (height * height));
    final targetExtent = (diagonal * 1.08) + 96;
    final theta = landingRotationDegrees * math.pi / 180.0;
    final cosTheta = math.cos(theta).abs();
    final sinTheta = math.sin(theta).abs();
    final verticalBudget =
        ((height * 1.03) - (targetExtent * sinTheta)) /
        math.max(cosTheta, 0.0001);
    final rowFitExtent = verticalBudget.clamp(240.0, targetExtent).toDouble();

    return KineticLayoutConfig(
      widthTier: widthTier,
      rowCount: rowCount,
      movingRowCount: movingRows,
      baseSmallFontSize: baseSmallFont,
      largeToSmallRatio: largeToSmallRatio,
      menuTargetFontSize: menuTargetFont,
      baseRowPadding: baseRowPadding,
      expandedMenuRowPadding: expandedMenuRowPadding,
      menuHorizontalPadding: menuHorizontalPadding,
      speedPixelsPerSecond: 22.5,
      targetExtent: targetExtent,
      rowFitExtent: rowFitExtent,
      dividerColor: const Color(0xFF5A5E66),
      motionFadeThreshold: motionFadeThreshold,
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

    if (mode == _PortfolioMode.flat) {
      _menuMorphController.value = 0;
    }
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
        child: _mode == _PortfolioMode.animated
            ? Column(
                children: [
                  _buildSharedAppBar(context),
                  Expanded(child: ClipRect(child: _buildAnimatedMode(context))),
                ],
              )
            : _buildFlatMode(),
      ),
    );
  }

  Widget _buildSharedAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isCompact = viewportWidth < 760;

    return Container(
      key: const Key('shared_app_bar'),
      height: 72,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.7),
            width: 1,
          ),
        ),
      ),
      child: CompactHeaderBar(
        fullName: portfolioSnapshot.fullName,
        avatarImageUrl: portfolioSnapshot.avatarImageUrl,
        isCompact: isCompact,
        isAnimatedSelected: true,
        isFlatSelected: false,
        isMenuOpen: _isAnimatedMenuOpen,
        onAnimatedTap: () => _setMode(_PortfolioMode.animated),
        onFlatTap: () => _setMode(_PortfolioMode.flat),
        onMenuTap: () {
          _toggleHamburger();
        },
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
      onToggleMenu: () {
        _toggleHamburger();
      },
      onSwitchToAnimated: () => _setMode(_PortfolioMode.animated),
      onSwitchToFlat: () => _setMode(_PortfolioMode.flat),
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
        final rotatedExtent = layoutConfig.targetExtent;

        final staticRowTextStyle = GoogleFonts.inter(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 4,
            color: Colors.white,
          ),
        );

        final movingRowTextStyle = const TextStyle(
          fontFamily: 'BuiltTitlingRgBold',
          fontWeight: FontWeight.w800,
          letterSpacing: 8,
          color: Colors.white,
        );

        return Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Transform.rotate(
                  angle: -15 * 3.1415926535 / 180,
                  child: OverflowBox(
                    maxWidth: rotatedExtent,
                    maxHeight: rotatedExtent,
                    child: SizedBox(
                      width: rotatedExtent,
                      height: rotatedExtent,
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
                            staticRowTextStyle: staticRowTextStyle,
                            movingRowTextStyle: movingRowTextStyle,
                            onMenuItemTap: _openAnimatedSectionFromMenu,
                          );
                        },
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
