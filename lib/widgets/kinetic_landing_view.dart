import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'scrolling_text_row.dart';

enum KineticSceneState { landing, menu, overlay }

enum KineticWidthTier { mobile, tablet, desktop }

@immutable
class KineticLayoutConfig {
  const KineticLayoutConfig({
    required this.widthTier,
    required this.rowCount,
    required this.movingRowCount,
    required this.baseSmallFontSize,
    required this.largeToSmallRatio,
    required this.menuTargetFontSize,
    required this.baseRowPadding,
    required this.expandedMenuRowPadding,
    required this.menuHorizontalPadding,
    required this.speedPixelsPerSecond,
    required this.targetExtent,
    required this.rowFitExtent,
    required this.dividerColor,
    required this.motionFadeThreshold,
  });

  final KineticWidthTier widthTier;
  final int rowCount;
  final int movingRowCount;
  final double baseSmallFontSize;
  final double largeToSmallRatio;
  final double menuTargetFontSize;
  final double baseRowPadding;
  final double expandedMenuRowPadding;
  final double menuHorizontalPadding;
  final double speedPixelsPerSecond;
  final double targetExtent;
  final double rowFitExtent;
  final Color dividerColor;
  final double motionFadeThreshold;

  String get signature =>
      '${widthTier.name}_${rowCount}_${movingRowCount}_${targetExtent.round()}_${rowFitExtent.round()}';
}

class KineticLandingView extends StatefulWidget {
  const KineticLandingView({
    super.key,
    required this.menuProgress,
    required this.sceneState,
    required this.layoutConfig,
    required this.isMenuInteractive,
    required this.landingTexts,
    required this.menuItems,
    required this.staticRowTextStyle,
    required this.movingRowTextStyle,
    this.onMenuItemTap,
  });

  final double menuProgress;
  final KineticSceneState sceneState;
  final KineticLayoutConfig layoutConfig;
  final bool isMenuInteractive;
  final List<String> landingTexts;
  final List<String> menuItems;
  final TextStyle staticRowTextStyle;
  final TextStyle movingRowTextStyle;
  final ValueChanged<String>? onMenuItemTap;

  @override
  State<KineticLandingView> createState() => _KineticLandingViewState();
}

class _KineticLandingViewState extends State<KineticLandingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _syncController;

  @override
  void initState() {
    super.initState();
    _syncController = AnimationController(
      vsync: this,
      duration: _syncDuration(widget.layoutConfig),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant KineticLandingView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.layoutConfig.targetExtent !=
            widget.layoutConfig.targetExtent ||
        oldWidget.layoutConfig.speedPixelsPerSecond !=
            widget.layoutConfig.speedPixelsPerSecond) {
      _syncController.duration = _syncDuration(widget.layoutConfig);
    }

    if (!_syncController.isAnimating) {
      _syncController.repeat(reverse: true);
    }
  }

  Duration _syncDuration(KineticLayoutConfig config) {
    final pxPerSec = config.speedPixelsPerSecond.clamp(1.0, 500.0);
    final millis = ((config.targetExtent / pxPerSec) * 1000).round();
    return Duration(milliseconds: millis.clamp(6000, 22000));
  }

  double _fontHeightFactor(TextStyle style) {
    final baseFontSize = ((style.fontSize ?? 16.0).clamp(
      8.0,
      220.0,
    )).toDouble();
    final painter = TextPainter(
      text: TextSpan(
        text: 'Hg',
        style: style.copyWith(fontSize: baseFontSize),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return (painter.height / baseFontSize).clamp(0.6, 2.8);
  }

  @override
  void dispose() {
    _syncController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeLandingTexts = widget.landingTexts.isEmpty
        ? const ['ALI SINAEE', 'FLUTTER', 'PORTFOLIO', 'FLAT VERSION', 'MENU']
        : widget.landingTexts;

    final rowCount = widget.layoutConfig.rowCount;
    final menuRowCount = widget.menuItems.length;

    final menuCenterStart = ((rowCount - menuRowCount) / 2).floor();
    final menuCenterEnd = menuCenterStart + menuRowCount;

    final movingCount = widget.layoutConfig.movingRowCount.clamp(2, rowCount);
    final movingCenterStart = ((rowCount - movingCount) / 2).floor();
    final movingCenterEnd = movingCenterStart + movingCount;

    final normalizedMenuProgress = widget.menuProgress.clamp(0.0, 1.0);
    final sizeProgress = (normalizedMenuProgress / 0.55).clamp(0.0, 1.0);
    final textBlend = ((normalizedMenuProgress - 0.62) / 0.38).clamp(0.0, 1.0);
    final motionBlend =
        (1.0 -
                (normalizedMenuProgress /
                    widget.layoutConfig.motionFadeThreshold))
            .clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _syncController,
      builder: (context, _) {
        final syncProgress = _syncController.value;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMenuScene = widget.sceneState == KineticSceneState.menu;

            final staticHeightFactor = _fontHeightFactor(
              widget.staticRowTextStyle,
            );
            final movingHeightFactor = _fontHeightFactor(
              widget.movingRowTextStyle,
            );

            var scalableHeight = 0.0;

            for (var index = 0; index < rowCount; index++) {
              final isMovingCenterRow =
                  index >= movingCenterStart && index < movingCenterEnd;
              final isMenuRow =
                  index >= menuCenterStart && index < menuCenterEnd;

              final baseFontSize = isMovingCenterRow
                  ? widget.layoutConfig.baseSmallFontSize *
                        widget.layoutConfig.largeToSmallRatio
                  : widget.layoutConfig.baseSmallFontSize;

              final rowTextScale = isMenuRow
                  ? lerpDouble(
                      1.0,
                      widget.layoutConfig.menuTargetFontSize / baseFontSize,
                      sizeProgress,
                    )!
                  : 1.0;

              final rowPadding = isMenuRow
                  ? lerpDouble(
                      widget.layoutConfig.baseRowPadding,
                      widget.layoutConfig.expandedMenuRowPadding,
                      sizeProgress,
                    )!
                  : widget.layoutConfig.baseRowPadding;

              final usesMovingStyle =
                  isMovingCenterRow || (isMenuScene && isMenuRow);
              final fontHeightFactor = usesMovingStyle
                  ? movingHeightFactor
                  : staticHeightFactor;

              final layoutTextScale = (isMenuScene && isMenuRow)
                  ? rowTextScale
                  : 1.0;

              final lineHeightAtScale1 =
                  (baseFontSize * layoutTextScale) * fontHeightFactor;

              scalableHeight += lineHeightAtScale1 + (rowPadding * 2);
            }

            final borderHeight = rowCount.toDouble();
            final usableExtent = math.max(
              1.0,
              widget.layoutConfig.rowFitExtent - borderHeight,
            );
            final rawFitScale =
                (usableExtent / math.max(1.0, scalableHeight)) * 0.97;
            final fitScale = rawFitScale.clamp(0.08, 2.2);

            return SizedBox(
              height: widget.layoutConfig.targetExtent,
              child: ClipRect(
                child: OverflowBox(
                  minWidth: widget.layoutConfig.targetExtent,
                  maxWidth: widget.layoutConfig.targetExtent,
                  minHeight: 0,
                  maxHeight: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(rowCount, (index) {
                      final isMenuRow =
                          index >= menuCenterStart && index < menuCenterEnd;
                      final isMovingCenterRow =
                          index >= movingCenterStart && index < movingCenterEnd;

                      final menuIndex = index - menuCenterStart;
                      final menuText =
                          (isMenuRow &&
                              menuIndex >= 0 &&
                              menuIndex < widget.menuItems.length)
                          ? widget.menuItems[menuIndex]
                          : null;

                      final baseFontSize = isMovingCenterRow
                          ? widget.layoutConfig.baseSmallFontSize *
                                widget.layoutConfig.largeToSmallRatio
                          : widget.layoutConfig.baseSmallFontSize;

                      final textScale = isMenuRow
                          ? lerpDouble(
                              1.0,
                              widget.layoutConfig.menuTargetFontSize /
                                  baseFontSize,
                              sizeProgress,
                            )!
                          : 1.0;

                      final rowPadding = isMenuRow
                          ? lerpDouble(
                              widget.layoutConfig.baseRowPadding,
                              widget.layoutConfig.expandedMenuRowPadding,
                              sizeProgress,
                            )!
                          : widget.layoutConfig.baseRowPadding;

                      final isOverlayScene =
                          widget.sceneState == KineticSceneState.overlay;

                      final rowMotionMode = isMovingCenterRow && !isOverlayScene
                          ? RowMotionMode.marquee
                          : RowMotionMode.staticHold;

                      final rowMotionBlend =
                          isMovingCenterRow && !isOverlayScene
                          ? motionBlend
                          : 0.0;

                      final textPresentationMode = isMenuScene && isMenuRow
                          ? RowTextPresentationMode.centeredBlend
                          : RowTextPresentationMode.marqueeBlend;

                      bool isDimmed = false;
                      var dimOpacity = 1.0;

                      if (isOverlayScene) {
                        isDimmed = true;
                        dimOpacity = 0.08;
                      } else if (isMenuScene && !isMenuRow) {
                        isDimmed = true;
                        dimOpacity = lerpDouble(
                          1.0,
                          0.18,
                          normalizedMenuProgress,
                        )!;
                      }

                      final rowTextStyle =
                          isMovingCenterRow || (isMenuScene && isMenuRow)
                          ? widget.movingRowTextStyle
                          : widget.staticRowTextStyle;

                      final row = ScrollingTextRow(
                        key: Key('kinetic_row_$index'),
                        primaryText:
                            safeLandingTexts[index % safeLandingTexts.length],
                        secondaryText: menuText,
                        textBlend: isMenuRow ? textBlend : 0,
                        fontSize: baseFontSize * fitScale,
                        textScale: textScale,
                        verticalPadding: rowPadding * fitScale,
                        moveLeft: index.isEven,
                        isDimmed: isDimmed,
                        dimOpacity: dimOpacity,
                        speedPixelsPerSecond:
                            widget.layoutConfig.speedPixelsPerSecond,
                        motionMode: rowMotionMode,
                        motionBlend: rowMotionBlend,
                        syncProgress: rowMotionMode == RowMotionMode.marquee
                            ? syncProgress
                            : null,
                        phaseOffset: 0,
                        textPresentationMode: textPresentationMode,
                        centeredHorizontalPadding:
                            widget.layoutConfig.menuHorizontalPadding *
                            fitScale,
                        dividerColor: widget.layoutConfig.dividerColor,
                        baseTextStyle: rowTextStyle,
                      );

                      if (menuText != null &&
                          widget.isMenuInteractive &&
                          isMenuScene) {
                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            key: Key('animated_menu_item_$menuIndex'),
                            behavior: HitTestBehavior.opaque,
                            onTap: () => widget.onMenuItemTap?.call(menuText),
                            child: row,
                          ),
                        );
                      }

                      return row;
                    }),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
