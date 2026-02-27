import 'dart:math' as math;

import 'package:flutter/material.dart';

class ScrollingTextRow extends StatefulWidget {
  const ScrollingTextRow({
    super.key,
    required this.text,
    required this.fontSize,
    this.moveLeft = true,
    this.isDimmed = false,
    this.dimOpacity = 0.15,
    this.speedPixelsPerSecond = 100.0,
  });

  final String text;
  final double fontSize;
  final bool moveLeft;
  final bool isDimmed;
  final double dimOpacity;
  final double speedPixelsPerSecond;

  @override
  State<ScrollingTextRow> createState() => _ScrollingTextRowState();
}

class _ScrollingTextRowState extends State<ScrollingTextRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _segmentWidth = 1.0;
  String _segmentText = '';
  String _marqueeText = '';
  int _cachedRepeatCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _updateTextMetrics();
    _controller.repeat();
  }

  @override
  void didUpdateWidget(ScrollingTextRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.fontSize != widget.fontSize ||
        oldWidget.speedPixelsPerSecond != widget.speedPixelsPerSecond) {
      _updateTextMetrics();
    }
  }

  TextStyle _textStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: 8,
      color: Colors.white,
    );
  }

  void _updateTextMetrics() {
    _segmentText = '${widget.text}   •   ';
    final style = TextStyle(
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: 8,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: _segmentText, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    _segmentWidth = math.max(1.0, textPainter.size.width);

    final millis = (_segmentWidth / widget.speedPixelsPerSecond * 1000).round();
    _controller.duration = Duration(milliseconds: math.max(300, millis));
    _cachedRepeatCount = 0;
  }

  String _buildMarqueeText(double viewportWidth) {
    final repeatCount = math.max(
      2,
      ((viewportWidth + _segmentWidth) / _segmentWidth).ceil() + 1,
    );

    if (repeatCount != _cachedRepeatCount) {
      _cachedRepeatCount = repeatCount;
      _marqueeText = List.filled(repeatCount, _segmentText).join();
    }
    return _marqueeText;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = _textStyle(widget.fontSize);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: widget.isDimmed ? widget.dimOpacity : 1.0,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewportWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final marqueeText = _buildMarqueeText(viewportWidth);

            return ClipRect(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final offset = widget.moveLeft
                      ? -(_controller.value * _segmentWidth)
                      : ((_controller.value - 1) * _segmentWidth);
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: child,
                  );
                },
                child: RepaintBoundary(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                    style: textStyle,
                    child: Text(
                      marqueeText,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
