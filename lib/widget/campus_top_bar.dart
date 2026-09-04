import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathon/back_end/auth_service.dart';
import 'package:hackathon/front_end/theme.dart';

/// Top bar spanning the content area with breadcrumb, search, and user avatar.
class CampusTopBar extends StatelessWidget {
  const CampusTopBar({super.key, this.onSearchTap, this.onAiTap});

  final VoidCallback? onSearchTap;
  final VoidCallback? onAiTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.topBarBg,
        border: Border(
          bottom: BorderSide(color: AppColors.topBarBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          // ── Left: Breadcrumb ──
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.onlineGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Northbridge University',
                style: AppTypography.body.copyWith(
                  color: AppColors.contentText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  '·',
                  style: AppTypography.body.copyWith(
                    color: AppColors.contentTextMuted,
                  ),
                ),
              ),
              Text(
                'Fall term',
                style: AppTypography.body.copyWith(
                  color: AppColors.contentTextMuted,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ── Right: Search + AI + Avatar ──
          IconButton(
            onPressed: onSearchTap,
            icon: const Icon(Icons.search_rounded, color: AppColors.contentTextMuted, size: 22),
            tooltip: 'Search',
          ),
          if (onAiTap != null) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: onAiTap,
              icon: const Icon(Icons.smart_toy_rounded, color: AppColors.accent, size: 22),
              tooltip: 'AI Assistant',
            ),
          ],
          const SizedBox(width: AppSpacing.sm),
          _UserAvatarChip(),
        ],
      ),
    );
  }
}

class _UserAvatarChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName;
    final userEmail = user?.email;
    final name = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : (userEmail != null && userEmail.isNotEmpty ? AuthService.emailToName(userEmail) : 'Student');
    final email = userEmail ?? '';

    final initials = name.trim().split(' ').map((p) => p.isEmpty ? '' : p[0]).take(2).join('').toUpperCase();

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          AuthService().signOut();
        }
      },
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: AppTypography.bodySmall.copyWith(color: AppColors.contentTextMuted),
              ),
              const Divider(height: 16),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, size: 18, color: Colors.redAccent),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Sign Out',
                style: AppTypography.body.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.only(left: 4, right: 12, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.contentSurface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.contentDivider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accent,
              child: Text(
                initials.isEmpty ? 'U' : initials,
                style: AppTypography.caption.copyWith(
                  color: AppColors.sidebarBg,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.contentText,
                  ),
                ),
                Text(
                  'Student',
                  style: AppTypography.bodySmall.copyWith(fontSize: 10),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down_rounded, size: 18, color: AppColors.contentTextMuted),
          ],
        ),
      ),
    );
  }
}
