import 'package:flutter/material.dart';
import 'package:hackathon/front_end/theme.dart';

/// Overview stat summary card widget (for the overview dashboard).
class StatCard extends StatefulWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.subtitle,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? AppColors.contentSurface;
    final fg = widget.foregroundColor ?? AppColors.contentText;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        transform: _isHovered
            ? Matrix4.translationValues(0.0, -2.0, 0.0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: _isHovered ? AppColors.accent : AppColors.contentDivider,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(widget.icon, size: 24, color: fg.withValues(alpha: 0.7)),
                Text(
                  widget.value,
                  style: AppTypography.h3.copyWith(
                    color: fg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.label,
              style: AppTypography.body.copyWith(
                color: fg.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.subtitle!,
                style: AppTypography.bodySmall.copyWith(
                  color: fg.withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
}
