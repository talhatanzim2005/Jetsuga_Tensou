import 'package:flutter/material.dart';
import 'package:hackathon/front_end/theme.dart';

enum AppButtonVariant { primary, secondary, outline }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.isFullWidth = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool isFullWidth;
  final bool isLoading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        backgroundColor = _isHovered
            ? AppColors.accentDark
            : AppColors.accent;
        foregroundColor = AppColors.accentText;
        break;
      case AppButtonVariant.secondary:
        backgroundColor = _isHovered
            ? AppColors.tableHeaderBg
            : AppColors.contentSurface;
        foregroundColor = AppColors.contentText;
        borderSide = const BorderSide(color: AppColors.contentDivider);
        break;
      case AppButtonVariant.outline:
        backgroundColor = _isHovered
            ? AppColors.accent.withValues(alpha: 0.15)
            : Colors.transparent;
        foregroundColor = AppColors.accent;
        borderSide = const BorderSide(color: AppColors.accent, width: 1.5);
        break;
    }

    if (!isEnabled) {
      backgroundColor = AppColors.contentDivider.withValues(alpha: 0.3);
      foregroundColor = AppColors.contentTextMuted;
      borderSide = BorderSide.none;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: 18, color: foregroundColor),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(
          widget.label,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w600,
            color: foregroundColor,
          ),
        ),
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: borderSide != BorderSide.none
              ? Border.fromBorderSide(borderSide)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: InkWell(
            onTap: isEnabled ? widget.onPressed : null,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
                horizontal: AppSpacing.md,
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
