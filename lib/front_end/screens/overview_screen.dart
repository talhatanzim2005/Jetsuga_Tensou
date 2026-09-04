import 'package:flutter/material.dart';
import 'package:hackathon/back_end/mock_data.dart';
import 'package:hackathon/front_end/theme.dart';
import 'package:hackathon/widget/stat_card.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathon/back_end/auth_service.dart';

/// Overview dashboard — greeting, stat cards, today's schedule, quick actions.
class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key, this.onNavigateKey});

  final ValueChanged<String>? onNavigateKey;

  @override
  Widget build(BuildContext context) {
    final repo = CampusDataRepository();
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName;
    final email = user?.email;
    final userName = (displayName != null && displayName.isNotEmpty)
        ? displayName.split(' ').first
        : (email != null ? AuthService.emailToName(email).split(' ').first : 'Student');

    // Count today's classes by weekday name
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final today = weekdays[DateTime.now().weekday - 1];
    final todayClasses = repo.schedules.where((s) => s.day == today).toList();
    final availableRooms = repo.rooms.where((r) => r.status == 'available').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Tag ──
          Row(
            children: [
              Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'DASHBOARD',
                style: AppTypography.caption.copyWith(letterSpacing: 1.5, color: AppColors.contentTextMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          // ── Greeting ──
          Text(
            'Good ${_getTimeOfDay()}, $userName.',
            style: AppTypography.h1.copyWith(fontSize: 40),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s what\'s happening on campus today.',
            style: AppTypography.body.copyWith(color: AppColors.contentTextMuted),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Stat Cards Row ──
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            if (isMobile) {
              return Column(
                children: _buildStatCards(repo, todayClasses.length, availableRooms)
                    .map((c) => Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: c))
                    .toList(),
              );
            }
            return Row(
              children: _buildStatCards(repo, todayClasses.length, availableRooms)
                  .map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: AppSpacing.sm), child: c)))
                  .toList(),
            );
          }),

          const SizedBox(height: AppSpacing.lg),

          // ── Today's Schedule ──
          _buildTodaySchedule(todayClasses, today),

          const SizedBox(height: AppSpacing.lg),

          // ── Recent Announcements ──
          _buildRecentAnnouncements(repo),
        ],
      ),
    );
  }

  List<Widget> _buildStatCards(CampusDataRepository repo, int todayCount, int availableRooms) {
    return [
      StatCard(
        label: 'Classes Today',
        value: '$todayCount',
        icon: Icons.calendar_today_rounded,
        backgroundColor: AppColors.accentBg,
        foregroundColor: AppColors.contentText,
        subtitle: 'Check your timetable',
        onTap: () => onNavigateKey?.call('schedule'),
      ),
      StatCard(
        label: 'Pending Assignments',
        value: '${repo.assignments.length}',
        icon: Icons.assignment_rounded,
        backgroundColor: AppColors.contentSurface,
        foregroundColor: AppColors.contentText,
        subtitle: 'Due this week',
        onTap: () => onNavigateKey?.call('assignments'),
      ),
      StatCard(
        label: 'Upcoming Events',
        value: '${repo.events.length}',
        icon: Icons.event_rounded,
        backgroundColor: AppColors.statCoral,
        foregroundColor: AppColors.contentText,
        subtitle: 'On campus',
        onTap: () => onNavigateKey?.call('events'),
      ),
      StatCard(
        label: 'Available Rooms',
        value: '$availableRooms',
        icon: Icons.meeting_room_rounded,
        backgroundColor: AppColors.statTeal,
        foregroundColor: AppColors.contentText,
        subtitle: 'Right now',
        onTap: () => onNavigateKey?.call('rooms'),
      ),
    ];
  }

  Widget _buildTodaySchedule(List todayClasses, String today) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.contentSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.contentDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => onNavigateKey?.call('schedule'),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.today_rounded, size: 20, color: AppColors.accent),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Today\'s Schedule — $today',
                    style: AppTypography.h6,
                  ),
                  const Spacer(),
                  Text(
                    'View Schedule →',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.accentDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.contentDivider),
          if (todayClasses.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Text(
                  'No classes scheduled for today. Enjoy your free day! 🎉',
                  style: AppTypography.body.copyWith(color: AppColors.contentTextMuted),
                ),
              ),
            )
          else
            ...todayClasses.map((cls) {
              return InkWell(
                onTap: () => onNavigateKey?.call('schedule'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.tableRowBorder, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${cls.course} — ${cls.title}',
                              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${cls.startTime} – ${cls.endTime} · Room ${cls.room} · ${cls.instructor}',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildRecentAnnouncements(CampusDataRepository repo) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.contentSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.contentDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => onNavigateKey?.call('announcements'),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.campaign_rounded, size: 20, color: AppColors.warning),
                  const SizedBox(width: AppSpacing.xs),
                  Text('Recent Announcements', style: AppTypography.h6),
                  const Spacer(),
                  Text(
                    'View All →',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.accentDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.contentDivider),
          ...repo.announcements.map((ann) {
            return InkWell(
              onTap: () => onNavigateKey?.call('announcements'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.tableRowBorder, width: 1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: ann.priority == 'high' ? AppColors.errorBg : AppColors.warningBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ann.priority.toUpperCase(),
                        style: AppTypography.caption.copyWith(
                          color: ann.priority == 'high' ? AppColors.error : AppColors.warning,
                          fontSize: 9,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ann.title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                          Text(
                            '${ann.postedBy} · Expires ${ann.expires}',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}
