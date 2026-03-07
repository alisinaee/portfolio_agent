import 'package:flutter/material.dart';

class PortfolioAvatar extends StatelessWidget {
  const PortfolioAvatar({
    super.key,
    required this.fullName,
    required this.imageUrl,
    this.radius = 18,
    this.borderColor = const Color(0xFF3D414A),
  });

  final String fullName;
  final String imageUrl;
  final double radius;
  final Color borderColor;

  String _initials() {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return 'A';
    }

    final initials = parts
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    return initials.isEmpty ? 'A' : initials;
  }

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return ColoredBox(
              color: const Color(0xFF191B1F),
              child: Center(
                child: Text(
                  _initials(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: radius * 0.8,
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

class CompactHeaderBar extends StatelessWidget {
  const CompactHeaderBar({
    super.key,
    required this.fullName,
    required this.avatarImageUrl,
    required this.isCompact,
    required this.isAnimatedSelected,
    required this.isFlatSelected,
    required this.isMenuOpen,
    required this.onAnimatedTap,
    required this.onFlatTap,
    required this.onMenuTap,
  });

  final String fullName;
  final String avatarImageUrl;
  final bool isCompact;
  final bool isAnimatedSelected;
  final bool isFlatSelected;
  final bool isMenuOpen;
  final VoidCallback onAnimatedTap;
  final VoidCallback onFlatTap;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              PortfolioAvatar(
                key: const Key('header_avatar'),
                fullName: fullName,
                imageUrl: avatarImageUrl,
                radius: isCompact ? 16 : 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  fullName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          key: const Key('animated_mode_button'),
          onPressed: onAnimatedTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: isAnimatedSelected
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
          onPressed: onFlatTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: isFlatSelected
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 8 : 14,
              vertical: 10,
            ),
            minimumSize: Size(0, isCompact ? 34 : 40),
          ),
          child: Text(isCompact ? 'FLAT' : 'FLAT VERSION'),
        ),
        const SizedBox(width: 8),
        IconButton(
          key: const Key('hamburger_menu_button'),
          iconSize: 34,
          icon: Icon(
            isMenuOpen ? Icons.close : Icons.menu,
            color: Colors.white,
          ),
          onPressed: onMenuTap,
        ),
      ],
    );
  }
}
