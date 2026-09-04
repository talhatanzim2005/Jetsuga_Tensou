import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathon/back_end/auth_service.dart';
import 'package:hackathon/front_end/theme.dart';

/// Navigation item definition for the sidebar.
class SidebarItem {
  final String label;
  final IconData icon;
  final String key;

  const SidebarItem({
    required this.label,
    required this.icon,
    required this.key,
  });
}

/// Fixed left sidebar with CampusOS branding, nav items, and live-status footer.
class CampusSidebar extends StatelessWidget {
  const CampusSidebar({
    super.key,
    required this.activeKey,
    required this.onItemTap,
    required this.items,
  });

  final String activeKey;
  final ValueChanged<String> onItemTap;
  final List<SidebarItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          // ── Logo Section ──
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onItemTap('overview'),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: AppColors.sidebarBg,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'CampusOS',
                      style: AppTypography.h5.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Tagline ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'YOUR CAMPUS, SORTED',
                style: AppTypography.caption.copyWith(
                  color: AppColors.sidebarTextMuted,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Nav Items ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isActive = item.key == activeKey;
                return _SidebarNavItem(
                  item: item,
                  isActive: isActive,
                  onTap: () => onItemTap(item.key),
                );
              },
            ),
          ),

          // ── Footer: user info & sign out ──
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: AppColors.sidebarDivider, height: 1),
                const SizedBox(height: AppSpacing.sm),
                Builder(builder: (context) {
                  final user = FirebaseAuth.instance.currentUser;
                  final email = user?.email ?? 'Logged in';
                  const badge = 'Firebase Authenticated';

                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.sidebarText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              badge,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.sidebarTextMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => AuthService().signOut(),
                        icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.sidebarTextMuted),
                        tooltip: 'Sign Out',
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  const _SidebarNavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final SidebarItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.accent
                  : (_isHovered ? AppColors.sidebarSurface : Colors.transparent),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                Icon(
                  widget.item.icon,
                  size: 20,
                  color: isActive
                      ? AppColors.sidebarBg
                      : (_isHovered ? AppColors.sidebarText : AppColors.sidebarTextMuted),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item.label,
                    style: AppTypography.body.copyWith(
                      color: isActive
                          ? AppColors.sidebarBg
                          : (_isHovered ? AppColors.sidebarText : AppColors.sidebarText),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isActive)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.sidebarBg,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
