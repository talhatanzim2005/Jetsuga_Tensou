import 'package:flutter/material.dart';
import 'package:hackathon/back_end/mock_data.dart';
import 'package:hackathon/front_end/theme.dart';
import 'package:hackathon/front_end/screens/overview_screen.dart';
import 'package:hackathon/front_end/screens/schedule_screen.dart';
import 'package:hackathon/front_end/screens/rooms_screen.dart';
import 'package:hackathon/front_end/screens/events_screen.dart';
import 'package:hackathon/front_end/screens/announcements_screen.dart';
import 'package:hackathon/front_end/screens/assignments_screen.dart';
import 'package:hackathon/widget/campus_sidebar.dart';
import 'package:hackathon/widget/campus_top_bar.dart';

/// Root shell — sidebar navigation + top bar + routed content area.
class CampusOSDashboardScreen extends StatefulWidget {
  const CampusOSDashboardScreen({super.key});

  @override
  State<CampusOSDashboardScreen> createState() => _CampusOSDashboardScreenState();
}

class _CampusOSDashboardScreenState extends State<CampusOSDashboardScreen> {
  String _activeKey = 'overview';
  String _searchQuery = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CampusDataRepository _repo = CampusDataRepository();

  // Search & AI Chat State
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _chatMessages = [
    {
      'sender': 'agent',
      'text': 'Hello! I am your CampusOS AI Assistant. Ask me about schedules, available rooms, deadlines, or upcoming events!'
    }
  ];
  final TextEditingController _chatController = TextEditingController();

  static const List<SidebarItem> _navItems = [
    SidebarItem(label: 'Overview', icon: Icons.dashboard_rounded, key: 'overview'),
    SidebarItem(label: 'Schedule', icon: Icons.calendar_today_rounded, key: 'schedule'),
    SidebarItem(label: 'Rooms', icon: Icons.meeting_room_rounded, key: 'rooms'),
    SidebarItem(label: 'Events', icon: Icons.groups_rounded, key: 'events'),
    SidebarItem(label: 'Announcements', icon: Icons.campaign_rounded, key: 'announcements'),
    SidebarItem(label: 'Assignments', icon: Icons.assignment_rounded, key: 'assignments'),
  ];

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    _searchController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  void _onRepoChanged() => setState(() {});

  void _selectTab(String key) {
    setState(() {
      _activeKey = key;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  Widget _getActiveScreen() {
    if (_searchQuery.trim().isNotEmpty) {
      return _buildSearchResultsView(_searchQuery.trim().toLowerCase());
    }

    switch (_activeKey) {
      case 'overview':
        return OverviewScreen(onNavigateKey: (key) => _selectTab(key));
      case 'schedule':
        return const ScheduleScreen();
      case 'rooms':
        return const RoomsScreen();
      case 'events':
        return const EventsScreen();
      case 'announcements':
        return const AnnouncementsScreen();
      case 'assignments':
        return const AssignmentsScreen();
      default:
        return OverviewScreen(onNavigateKey: (key) => _selectTab(key));
    }
  }

  void _handleAgentSubmit(String text) {
    if (text.trim().isEmpty) return;
    final query = text.trim();
    _chatController.clear();

    setState(() {
      _chatMessages.add({'sender': 'user', 'text': query});
    });

    String response = '';
    final lower = query.toLowerCase();

    if (lower.contains('room') || lower.contains('available') || lower.contains('free')) {
      final availableRooms = _repo.rooms.where((r) => r.status == 'available').toList();
      final roomsList = availableRooms.map((r) => '• Room ${r.roomNumber} (${r.type}, Floor ${r.floor}, Cap: ${r.capacity})').join('\n');
      response = '🔍 Tool executed: checkRoomAvailability()\nFound ${availableRooms.length} available rooms right now:\n$roomsList';
    } else if (lower.contains('schedule') || lower.contains('class') || lower.contains('routine')) {
      final schedList = _repo.schedules.map((s) => '• ${s.course} (${s.title}) on ${s.day} ${s.startTime}-${s.endTime} in Room ${s.room}').join('\n');
      response = '📅 Tool executed: getSchedule()\nCurrent active schedules:\n$schedList';
    } else if (lower.contains('event') || lower.contains('hackathon') || lower.contains('workshop')) {
      final evtList = _repo.events.map((e) => '• ${e.name} on ${e.date} at ${e.venue} (${e.registered}/${e.capacity} registered)').join('\n');
      response = '🎉 Tool executed: getActiveEvents()\nUpcoming campus events:\n$evtList';
    } else if (lower.contains('assignment') || lower.contains('deadline') || lower.contains('report')) {
      final asgnList = _repo.assignments.map((a) => '• ${a.course}: ${a.title} due on ${a.deadline} [${a.marks} Marks]').join('\n');
      response = '📝 Tool executed: getUpcomingDeadlines()\nPending assignments:\n$asgnList';
    } else if (lower.contains('announcement') || lower.contains('notice')) {
      final annList = _repo.announcements.map((a) => '• [${a.priority.toUpperCase()}] ${a.title} (Posted by ${a.postedBy})').join('\n');
      response = '📢 Tool executed: getActiveAnnouncements()\nCurrent notices:\n$annList';
    } else if (lower.contains('book') && lower.contains('friday')) {
      response = '🛑 Tool execution refused: Polite Refusal Policy.\nUniversity calendar week runs Sunday–Thursday. Friday and Saturday are weekend hours; room bookings are not permitted.';
    } else {
      response = '🤖 Grounded Answer:\nBased on live campus data, we have ${_repo.schedules.length} scheduled classes, ${_repo.rooms.length} tracked rooms, ${_repo.events.length} upcoming events, and ${_repo.assignments.length} pending deadlines.';
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _chatMessages.add({'sender': 'agent', 'text': response});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.contentBg,
      // Mobile drawer
      drawer: isMobile
          ? Drawer(
              width: 240,
              child: CampusSidebar(
                activeKey: _activeKey,
                items: _navItems,
                onItemTap: (key) {
                  _selectTab(key);
                  Navigator.of(context).pop(); // close drawer
                },
              ),
            )
          : null,
      // AI Chat drawer (end)
      endDrawer: Drawer(
        width: 380,
        backgroundColor: AppColors.sidebarBg,
        child: _buildChatPanel(),
      ),
      body: Row(
        children: [
          // ── Desktop Sidebar ──
          if (!isMobile)
            CampusSidebar(
              activeKey: _activeKey,
              items: _navItems,
              onItemTap: (key) => _selectTab(key),
            ),

          // ── Main Content ──
          Expanded(
            child: Column(
              children: [
                // Top Bar
                CampusTopBar(
                  searchController: _searchController,
                  onSearchChanged: (q) => setState(() => _searchQuery = q),
                  onClearSearch: () => setState(() => _searchQuery = ''),
                  onAiTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                ),
                // Mobile hamburger bar
                if (isMobile)
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    color: AppColors.contentBg,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu_rounded, color: AppColors.contentText),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          _getPageTitle(),
                          style: AppTypography.h6,
                        ),
                      ],
                    ),
                  ),
                // Screen Content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _getActiveScreen(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (_activeKey) {
      case 'overview': return 'Overview';
      case 'schedule': return 'Schedule';
      case 'rooms': return 'Rooms';
      case 'events': return 'Events';
      case 'announcements': return 'Announcements';
      case 'assignments': return 'Assignments';
      default: return 'CampusOS';
    }
  }

  Widget _buildChatPanel() {
    return Container(
      color: AppColors.sidebarBg,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.sidebarSurface,
              border: Border(bottom: BorderSide(color: AppColors.sidebarDivider)),
            ),
            child: Row(
              children: [
                Icon(Icons.smart_toy_rounded, color: AppColors.accent, size: 22),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Campus AI Assistant',
                  style: AppTypography.h6.copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final msg = _chatMessages[index];
                final isUser = msg['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.accent : AppColors.sidebarSurface,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: AppTypography.bodySmall.copyWith(
                        color: isUser ? AppColors.sidebarBg : AppColors.sidebarText,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    style: AppTypography.body.copyWith(color: AppColors.sidebarText),
                    decoration: InputDecoration(
                      hintText: 'Ask CampusOS Agent...',
                      hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.sidebarTextMuted),
                      filled: true,
                      fillColor: AppColors.sidebarSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        borderSide: const BorderSide(color: AppColors.sidebarDivider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        borderSide: const BorderSide(color: AppColors.sidebarDivider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                    ),
                    onSubmitted: _handleAgentSubmit,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                IconButton(
                  icon: Icon(Icons.send_rounded, color: AppColors.accent),
                  onPressed: () => _handleAgentSubmit(_chatController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsView(String query) {
    final schedMatches = _repo.schedules.where((s) =>
      s.course.toLowerCase().contains(query) ||
      s.title.toLowerCase().contains(query) ||
      s.instructor.toLowerCase().contains(query) ||
      s.room.toLowerCase().contains(query) ||
      s.day.toLowerCase().contains(query)
    ).toList();

    final roomMatches = _repo.rooms.where((r) =>
      r.roomNumber.toLowerCase().contains(query) ||
      r.type.toLowerCase().contains(query) ||
      r.status.toLowerCase().contains(query) ||
      r.equipment.any((e) => e.toLowerCase().contains(query))
    ).toList();

    final eventMatches = _repo.events.where((e) =>
      e.name.toLowerCase().contains(query) ||
      e.description.toLowerCase().contains(query) ||
      e.venue.toLowerCase().contains(query) ||
      e.organizer.toLowerCase().contains(query)
    ).toList();

    final annMatches = _repo.announcements.where((a) =>
      a.title.toLowerCase().contains(query) ||
      a.body.toLowerCase().contains(query) ||
      a.postedBy.toLowerCase().contains(query) ||
      a.priority.toLowerCase().contains(query)
    ).toList();

    final asgnMatches = _repo.assignments.where((a) =>
      a.course.toLowerCase().contains(query) ||
      a.title.toLowerCase().contains(query) ||
      a.description.toLowerCase().contains(query) ||
      a.submissionPlatform.toLowerCase().contains(query)
    ).toList();

    final totalCount = schedMatches.length + roomMatches.length + eventMatches.length + annMatches.length + asgnMatches.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.search_rounded, color: AppColors.accent, size: 24),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Search Results for "$_searchQuery"',
                style: AppTypography.h4,
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentBg,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '$totalCount matches',
                  style: AppTypography.caption.copyWith(color: AppColors.accentDark, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                }),
                icon: const Icon(Icons.close_rounded, size: 18),
                label: const Text('Clear Search'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (totalCount == 0)
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.contentSurface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.contentDivider),
              ),
              child: Column(
                children: [
                  const Icon(Icons.search_off_rounded, size: 48, color: AppColors.contentTextMuted),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No matching records found',
                    style: AppTypography.h5,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Try searching for a course code (CSE 4113), room (7A03), event, or deadline.',
                    style: AppTypography.body.copyWith(color: AppColors.contentTextMuted),
                  ),
                ],
              ),
            )
          else ...[
            if (schedMatches.isNotEmpty) ...[
              _buildSearchCategoryHeader('Schedules', Icons.calendar_today_rounded, schedMatches.length, 'schedule'),
              ...schedMatches.map((s) => _buildSearchResultCard(
                title: '${s.course} — ${s.title}',
                subtitle: '${s.day} ${s.startTime}-${s.endTime} · Room ${s.room} · ${s.instructor}',
                badge: s.section,
                categoryKey: 'schedule',
              )),
              const SizedBox(height: AppSpacing.md),
            ],
            if (roomMatches.isNotEmpty) ...[
              _buildSearchCategoryHeader('Rooms', Icons.meeting_room_rounded, roomMatches.length, 'rooms'),
              ...roomMatches.map((r) => _buildSearchResultCard(
                title: 'Room ${r.roomNumber} (${r.type.toUpperCase()})',
                subtitle: 'Floor ${r.floor} · Capacity: ${r.capacity} · Equipment: ${r.equipment.join(', ')}',
                badge: r.status.toUpperCase(),
                categoryKey: 'rooms',
              )),
              const SizedBox(height: AppSpacing.md),
            ],
            if (eventMatches.isNotEmpty) ...[
              _buildSearchCategoryHeader('Events', Icons.groups_rounded, eventMatches.length, 'events'),
              ...eventMatches.map((e) => _buildSearchResultCard(
                title: e.name,
                subtitle: '${e.date} (${e.startTime}-${e.endTime}) · Venue: ${e.venue} · ${e.organizer}',
                badge: '${e.registered}/${e.capacity}',
                categoryKey: 'events',
              )),
              const SizedBox(height: AppSpacing.md),
            ],
            if (annMatches.isNotEmpty) ...[
              _buildSearchCategoryHeader('Announcements', Icons.campaign_rounded, annMatches.length, 'announcements'),
              ...annMatches.map((a) => _buildSearchResultCard(
                title: a.title,
                subtitle: '${a.postedBy} · ${a.body}',
                badge: a.priority.toUpperCase(),
                categoryKey: 'announcements',
              )),
              const SizedBox(height: AppSpacing.md),
            ],
            if (asgnMatches.isNotEmpty) ...[
              _buildSearchCategoryHeader('Assignments', Icons.assignment_rounded, asgnMatches.length, 'assignments'),
              ...asgnMatches.map((a) => _buildSearchResultCard(
                title: '${a.course}: ${a.title}',
                subtitle: 'Deadline: ${a.deadline} · Platform: ${a.submissionPlatform} · ${a.description}',
                badge: '${a.marks} Marks',
                categoryKey: 'assignments',
              )),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSearchCategoryHeader(String title, IconData icon, int count, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs, top: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(width: AppSpacing.xs),
          Text(title, style: AppTypography.h6),
          const SizedBox(width: AppSpacing.xs),
          Text('($count)', style: AppTypography.bodySmall.copyWith(color: AppColors.contentTextMuted)),
          const Spacer(),
          TextButton(
            onPressed: () => _selectTab(key),
            child: const Text('View All →', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard({
    required String title,
    required String subtitle,
    required String badge,
    required String categoryKey,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      elevation: 0,
      color: AppColors.contentSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: const BorderSide(color: AppColors.contentDivider),
      ),
      child: ListTile(
        onTap: () => _selectTab(categoryKey),
        title: Text(title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTypography.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accentBg,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(badge, style: AppTypography.caption.copyWith(color: AppColors.accentDark, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
