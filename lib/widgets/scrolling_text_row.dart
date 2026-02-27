import 'dart:math' as math;

import 'package:flutter/material.dart';

enum RowMotionMode { marquee, staticHold }

enum RowTextPresentationMode { marqueeBlend, centeredBlend }

class ScrollingTextRow extends StatefulWidget {
  const ScrollingTextRow({
    super.key,
    required this.primaryText,
    required this.fontSize,
    this.secondaryText,
    this.textBlend = 0,
    this.moveLeft = true,
    this.isDimmed = false,
    this.dimOpacity = 0.15,
    this.speedPixelsPerSecond = 52.0,
    this.motionMode = RowMotionMode.marquee,
    this.textScale = 1.0,
    this.verticalPadding = 24.0,
    this.textPresentationMode = RowTextPresentationMode.marqueeBlend,
    this.centeredHorizontalPadding = 16.0,
  });

  final String primaryText;
  final String? secondaryText;
  final double textBlend;
  final double fontSize;
  final bool moveLeft;
  final bool isDimmed;
  final double dimOpacity;
  final double speedPixelsPerSecond;
  final RowMotionMode motionMode;
  final double textScale;
  final double verticalPadding;
  final RowTextPresentationMode textPresentationMode;
  final double centeredHorizontalPadding;

  @override
  State<ScrollingTextRow> createState() => _ScrollingTextRowState();
}

class _ScrollingTextRowState extends State<ScrollingTextRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  double _primarySegmentWidth = 1.0;
  double _secondarySegmentWidth = 1.0;

  String _primarySegmentText = '';
  String _secondarySegmentText = '';

  String _primaryMarqueeText = '';
  String _secondaryMarqueeText = '';

  int _primaryCachedRepeatCount = 0;
  int _secondaryCachedRepeatCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _updateTextMetrics();
    _syncAnimationState();
  }

  @override
  void didUpdateWidget(ScrollingTextRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.primaryText != widget.primaryText ||
        oldWidget.secondaryText != widget.secondaryText ||
        oldWidget.fontSize != widget.fontSize ||
        oldWidget.speedPixelsPerSecond != widget.speedPixelsPerSecond ||
        oldWidget.textPresentationMode != widget.textPresentationMode) {
      _updateTextMetrics();
    }

    if (oldWidget.motionMode != widget.motionMode) {
      _syncAnimationState();
    }
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: 8,
      color: Colors.white,
    );
  }

  double _measureSegmentWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return math.max(1.0, textPainter.size.width);
  }

  void _syncAnimationState() {
    if (widget.motionMode == RowMotionMode.staticHold) {
      if (_controller.isAnimating) {
        _controller.stop(canceled: false);
      }
      return;
    }

    if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  void _updateTextMetrics() {
    final style = _textStyle();

    final primarySegment = '${widget.primaryText}   •   ';
    final secondaryRaw = widget.secondaryText;
    final secondarySegment = secondaryRaw == null ? '' : '$secondaryRaw   •   ';

    final primaryWidth = _measureSegmentWidth(primarySegment, style);
    final secondaryWidth = secondaryRaw == null
        ? primaryWidth
        : _measureSegmentWidth(secondarySegment, style);

    final activeWidth = math.max(primaryWidth, secondaryWidth);

    final millis =
        (activeWidth / widget.speedPixelsPerSecond.clamp(1, 1000) * 1000)
            .round();
    final duration = Duration(milliseconds: math.max(450, millis));

    _primarySegmentText = primarySegment;
    _secondarySegmentText = secondarySegment;
    _primarySegmentWidth = primaryWidth;
    _secondarySegmentWidth = secondaryWidth;

    _primaryCachedRepeatCount = 0;
    _secondaryCachedRepeatCount = 0;

    if (_controller.duration != duration) {
      _controller.duration = duration;
    }
  }

  String _buildPrimaryMarqueeText(double viewportWidth, double segmentWidth) {
    final repeatCount = math.max(
      2,
      ((viewportWidth + segmentWidth) / segmentWidth).ceil() + 1,
    );

    if (repeatCount != _primaryCachedRepeatCount) {
      _primaryCachedRepeatCount = repeatCount;
      _primaryMarqueeText = List.filled(
        repeatCount,
        _primarySegmentText,
      ).join();
    }

    return _primaryMarqueeText;
  }

  String _buildSecondaryMarqueeText(double viewportWidth, double segmentWidth) {
    if (widget.secondaryText == null) {
      return '';
    }

    final repeatCount = math.max(
      2,
      ((viewportWidth + segmentWidth) / segmentWidth).ceil() + 1,
    );

    if (repeatCount != _secondaryCachedRepeatCount) {
      _secondaryCachedRepeatCount = repeatCount;
      _secondaryMarqueeText = List.filled(
        repeatCount,
        _secondarySegmentText,
      ).join();
    }

    return _secondaryMarqueeText;
  }

  Widget _buildMarqueeBlendText({
    required TextStyle style,
    required String primary,
    required String secondary,
    required double blend,
  }) {
    if (widget.secondaryText == null || blend <= 0.0) {
      return Text(
        primary,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
        style: style,
      );
    }

    if (blend >= 1.0) {
      return Text(
        secondary,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
        style: style,
      );
    }

    return Stack(
      children: [
        Opacity(
          opacity: 1.0 - blend,
          child: Text(
            primary,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: style,
          ),
        ),
        Opacity(
          opacity: blend,
          child: Text(
            secondary,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: style,
          ),
        ),
      ],
    );
  }

  Widget _buildCenteredLabel({required String text, required TextStyle style}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.centeredHorizontalPadding.clamp(0.0, 96.0),
      ),
      child: SizedBox(
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            text,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: style,
          ),
        ),
      ),
    );
  }

  Widget _buildCenteredBlendText({
    required TextStyle style,
    required double blend,
  }) {
    final primary = widget.primaryText;
    final secondary = widget.secondaryText ?? widget.primaryText;

    if (blend <= 0.0 || widget.secondaryText == null) {
      return _buildCenteredLabel(text: primary, style: style);
    }

    if (blend >= 1.0) {
      return _buildCenteredLabel(text: secondary, style: style);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 1.0 - blend,
          child: _buildCenteredLabel(text: primary, style: style),
        ),
        Opacity(
          opacity: blend,
          child: _buildCenteredLabel(text: secondary, style: style),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _textStyle();
    final textBlend = widget.secondaryText == null
        ? 0.0
        : widget.textBlend.clamp(0.0, 1.0);
    final textScale = widget.textScale.clamp(0.25, 4.0);
    final rowOpacity = widget.isDimmed
        ? widget.dimOpacity.clamp(0.0, 1.0)
        : 1.0;

    return Opacity(
      opacity: rowOpacity,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
        ),
        padding: EdgeInsets.symmetric(
          vertical: widget.verticalPadding.clamp(8.0, 80.0),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (widget.textPresentationMode ==
                RowTextPresentationMode.centeredBlend) {
              final centeredStyle = style.copyWith(
                fontSize: (style.fontSize ?? 16) * textScale,
                letterSpacing: ((style.letterSpacing ?? 8) * 0.55),
              );
              final centered = _buildCenteredBlendText(
                style: centeredStyle,
                blend: textBlend,
              );
              return ClipRect(child: RepaintBoundary(child: centered));
            }

            final viewportWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;

            final scaledPrimarySegmentWidth = _primarySegmentWidth * textScale;
            final scaledSecondarySegmentWidth =
                _secondarySegmentWidth * textScale;
            final primaryMarquee = _buildPrimaryMarqueeText(
              viewportWidth,
              scaledPrimarySegmentWidth,
            );
            final secondaryMarquee =
                textBlend <= 0 || widget.secondaryText == null
                ? ''
                : _buildSecondaryMarqueeText(
                    viewportWidth,
                    scaledSecondarySegmentWidth,
                  );
            final activeSegmentWidth = math.max(
              scaledPrimarySegmentWidth,
              scaledSecondarySegmentWidth,
            );

            Widget textLayer = _buildMarqueeBlendText(
              style: style,
              primary: primaryMarquee,
              secondary: secondaryMarquee,
              blend: textBlend,
            );

            if (textScale != 1.0) {
              textLayer = Transform.scale(
                scale: textScale,
                alignment: Alignment.centerLeft,
                child: textLayer,
              );
            }

            if (widget.motionMode == RowMotionMode.marquee) {
              textLayer = AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final offset = widget.moveLeft
                      ? -(_controller.value * activeSegmentWidth)
                      : ((_controller.value - 1) * activeSegmentWidth);
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  );
                },
                child: textLayer,
              );
            }

            return ClipRect(child: RepaintBoundary(child: textLayer));
          },
        ),
      ),
    );
  }
}
