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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final CampusDataRepository _repo = CampusDataRepository();

  // AI Chat State
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
    _chatController.dispose();
    super.dispose();
  }

  void _onRepoChanged() => setState(() {});

  Widget _getActiveScreen() {
    switch (_activeKey) {
      case 'overview':
        return OverviewScreen(onNavigateKey: (key) => setState(() => _activeKey = key));
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
        return OverviewScreen(onNavigateKey: (key) => setState(() => _activeKey = key));
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
                  setState(() => _activeKey = key);
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
              onItemTap: (key) => setState(() => _activeKey = key),
            ),

          // ── Main Content ──
          Expanded(
            child: Column(
              children: [
                // Top Bar
                CampusTopBar(
                  onSearchTap: () {},
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
}
