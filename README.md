# Campus OS — Comprehensive File & Function Documentation

A modern, responsive, dual-tone Flutter Web & Desktop application for campus management, class scheduling, room availability, event tracking, notice announcements, and assignment workflows powered by Firebase Authentication and Cloud Firestore.

---

## 📁 Repository Directory Structure

```
lib/
├── main.dart
├── back_end/
│   ├── auth_service.dart
│   ├── firebase_options.dart
│   ├── firestore_service.dart
│   ├── mock_data.dart
│   └── models.dart
├── front_end/
│   ├── campus_os_dashboard.dart
│   ├── responsive.dart
│   ├── theme.dart
│   └── screens/
│       ├── announcements_screen.dart
│       ├── assignments_screen.dart
│       ├── auth_screen.dart
│       ├── events_screen.dart
│       ├── overview_screen.dart
│       ├── rooms_screen.dart
│       └── schedule_screen.dart
└── widget/
    ├── app_button.dart
    ├── app_card.dart
    ├── campus_sidebar.dart
    ├── campus_top_bar.dart
    ├── data_table_view.dart
    ├── record_form_modal.dart
    ├── responsive_grid.dart
    └── stat_card.dart
```

---

## 📑 Complete Function & API Reference by File

### 📍 Entry Point (`lib/`)

#### 1. `lib/main.dart`
- **Purpose**: Application initialization and Authentication Gate.
- **Classes & Functions**:
  - `void main()`: Async entry point. Calls `WidgetsFlutterBinding.ensureInitialized()` and `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`. Runs `CampusOSApp`.
  - `class CampusOSApp extends StatelessWidget`: Main MaterialApp root.
  - `Widget build(BuildContext context)`: Sets up MaterialApp with `AppTheme.lightTheme` and a `StreamBuilder<User?>` listening to `AuthService().authStateChanges`.
    - Returns `CampusOSDashboardScreen` if `snapshot.data != null` (user is authenticated).
    - Returns `AuthScreen` if user is unauthenticated.

---

### ⚙️ Back-End Layer (`lib/back_end/`)

#### 1. `lib/back_end/auth_service.dart`
- **Purpose**: Central Firebase Authentication and Firestore user profile manager (Singleton).
- **Classes & Functions**:
  - `class AuthService`: Singleton manager (`factory AuthService() => _instance`).
  - `Stream<User?> get authStateChanges`: Stream emitting Firebase authentication state changes.
  - `User? get currentUser`: Getter for the currently authenticated `User`.
  - `Future<UserCredential> signUpWithEmailAndPassword({required String email, required String password, required String displayName})`:
    - Registers a new user with `createUserWithEmailAndPassword`.
    - Updates user display name using `user.updateDisplayName(displayName)`.
    - Calls `saveUserProfile` to store user metadata in Firestore.
  - `Future<UserCredential> signInWithEmailAndPassword({required String email, required String password})`:
    - Authenticates existing user via `signInWithEmailAndPassword`.
    - Updates `lastLogin` timestamp in Firestore via `saveUserProfile`.
  - `Future<UserCredential> signInWithGoogle()`:
    - Configures `GoogleAuthProvider` with email and profile scopes.
    - Launches `signInWithPopup` on Web (`kIsWeb`) or `signInWithProvider` on native platforms.
    - Automatically syncs profile metadata to Firestore.
  - `Future<void> saveUserProfile(User user, {String? name})`:
    - Creates or updates the document at `users/{uid}` in Cloud Firestore.
    - Stores `uid`, `email`, `displayName`, `photoURL`, `lastLogin`, and `createdAt`.
  - `static String emailToName(String email)`: Utility function converting email handles (e.g. `alex.rivera@campus.edu`) into formatted names (`Alex Rivera`).
  - `Future<void> signOut()`: Terminates active user session using `_auth.signOut()`.

#### 2. `lib/back_end/firebase_options.dart`
- **Purpose**: Auto-generated Firebase initialization credentials.
- **Classes & Functions**:
  - `class DefaultFirebaseOptions`: Platform configuration resolver.
  - `static FirebaseOptions get currentPlatform`: Selects platform options based on `kIsWeb` or `defaultTargetPlatform`.
  - `static const FirebaseOptions web`: Firebase web configuration keys (`apiKey`, `appId`, `messagingSenderId`, `projectId`, `authDomain`, `storageBucket`).
  - `static const FirebaseOptions android / ios / macos / windows`: Platform-specific credential configurations.

#### 3. `lib/back_end/firestore_service.dart`
- **Purpose**: Real-time Cloud Firestore Database interactions.
- **Classes & Functions**:
  - `class FirestoreService`: Service interface for database CRUD operations.
  - `Stream<List<ScheduleItem>> getScheduleStream()`: Listens to live snapshots from `schedules` collection.
  - `Future<void> addSchedule(ScheduleItem item)`: Inserts a schedule document into Firestore.
  - `Future<void> updateSchedule(ScheduleItem item)`: Updates an existing schedule document by ID.
  - `Future<void> deleteSchedule(String id)`: Deletes a schedule document by ID.
  - `Stream<List<RoomItem>> getRoomsStream()`: Listens to live snapshots from `rooms` collection.
  - `Future<void> addRoom(RoomItem item)` / `updateRoom(RoomItem item)` / `deleteRoom(String id)`: CRUD methods for room availability records.
  - `Stream<List<EventItem>> getEventsStream()`: Listens to live snapshots from `events` collection.
  - `Future<void> addEvent(EventItem item)` / `registerForEvent(String eventId)`: Inserts events or increments attendee counts.
  - `Stream<List<AnnouncementItem>> getAnnouncementsStream()`: Real-time notice feed stream.
  - `Stream<List<AssignmentItem>> getAssignmentsStream()`: Real-time assignment records stream.

#### 4. `lib/back_end/mock_data.dart`
- **Purpose**: In-memory reactive data repository (`CampusDataRepository`) extending `ChangeNotifier`.
- **Classes & Functions**:
  - `class CampusDataRepository extends ChangeNotifier`: Singleton data store.
  - `List<ScheduleItem> get schedules`: Returns list of class schedules.
  - `List<RoomItem> get rooms`: Returns list of room statuses.
  - `List<EventItem> get events`: Returns list of campus events.
  - `List<AnnouncementItem> get announcements`: Returns list of notices.
  - `List<AssignmentItem> get assignments`: Returns list of assignments.
  - `void addSchedule(ScheduleItem item)` / `editSchedule(ScheduleItem item)` / `deleteSchedule(String id)`: Updates schedules and triggers `notifyListeners()`.
  - `void addRoom(RoomItem item)` / `editRoom(RoomItem item)` / `deleteRoom(String id)`: Updates rooms and triggers `notifyListeners()`.
  - `void addEvent(EventItem item)` / `editEvent(EventItem item)` / `deleteEvent(String id)`: Updates events and triggers `notifyListeners()`.
  - `void addAnnouncement(AnnouncementItem item)` / `editAnnouncement(AnnouncementItem item)` / `deleteAnnouncement(String id)`: Updates announcements and triggers `notifyListeners()`.
  - `void addAssignment(AssignmentItem item)` / `editAssignment(AssignmentItem item)` / `deleteAssignment(String id)`: Updates assignments and triggers `notifyListeners()`.

#### 5. `lib/back_end/models.dart`
- **Purpose**: Data contracts and serialization for domain entities.
- **Classes & Functions**:
  - `class ScheduleItem`: Fields: `id`, `course`, `title`, `instructor`, `day`, `startTime`, `endTime`, `room`. Methods: `factory ScheduleItem.fromJson(Map<String, dynamic> json)`, `Map<String, dynamic> toJson()`.
  - `class RoomItem`: Fields: `id`, `roomNumber`, `type`, `capacity`, `floor`, `equipment`, `status`. Methods: `fromJson`, `toJson`.
  - `class EventItem`: Fields: `id`, `name`, `venue`, `date`, `organizer`, `capacity`, `registered`. Methods: `fromJson`, `toJson`.
  - `class AnnouncementItem`: Fields: `id`, `title`, `content`, `postedBy`, `date`, `priority`, `expires`. Methods: `fromJson`, `toJson`.
  - `class AssignmentItem`: Fields: `id`, `title`, `course`, `deadline`, `submissionPlatform`, `marks`. Methods: `fromJson`, `toJson`.

---

### 🎨 Front-End Layer (`lib/front_end/`)

#### 1. `lib/front_end/theme.dart`
- **Purpose**: Centralized design system and visual styling tokens.
- **Classes & Functions**:
  - `abstract class AppSpacing`: 8-point grid tokens (`xs: 8.0`, `sm: 16.0`, `md: 24.0`, `lg: 32.0`, `xl: 48.0`, `xxl: 64.0`).
  - `abstract class AppRadius`: Border radii (`sm: 8.0`, `md: 12.0`, `lg: 16.0`, `xl: 24.0`, `full: 9999.0`).
  - `abstract class AppTypography`: Major Third 1.25x scale TextStyles (`h1`, `h2`, `h3`, `h4`, `h5`, `h6`, `body`, `bodySmall`, `caption`, `tableHeader`) using `Inter` font.
  - `abstract class AppColors`: Color definitions:
    - Sidebar (Dark Navy `#1B1E2E`, `#252838`, `#CBCED8`, `#6B7089`).
    - Content Area (Warm Cream `#F4F1EA`, Surface `#FFFFFF`, Text `#1A1A2E`, Divider `#E5E1D8`).
    - Accent (Warm Gold `#E8C858`, `#D4AE38`, `#FDF6E3`).
    - Badges & Tables (`onlineGreen`, `tableHeaderBg`, `tableRowHover`, `statCoral`, `statTeal`).
  - `abstract class AppTheme`: `static ThemeData get lightTheme` returning complete Material ThemeData.

#### 2. `lib/front_end/campus_os_dashboard.dart`
- **Purpose**: Root application layout shell and state manager.
- **Classes & Functions**:
  - `class CampusOSDashboardScreen extends StatefulWidget`: Dashboard shell.
  - `Widget build(BuildContext context)`: Assembles `CampusSidebar`, `CampusTopBar`, routed screens, and end-drawer AI Assistant.
  - `Widget _getActiveScreen()`: Evaluates `_activeKey` ('overview', 'schedule', 'rooms', 'events', 'announcements', 'assignments') and returns target screen widget. Passes `onNavigateKey` callback to `OverviewScreen`.
  - `void _handleAgentSubmit(String text)`: Processes user input in AI Assistant drawer, matches keyword queries ('room', 'schedule', 'event', 'assignment'), executes repository queries, and appends agent response messages.
  - `Widget _buildAiDrawer()`: Renders side-drawer conversation view for the AI Assistant.

#### 3. `lib/front_end/responsive.dart`
- **Purpose**: Breakpoint detection helper.
- **Classes & Functions**:
  - `class Responsive extends StatelessWidget`: Layout builder wrapper.
  - `static bool isMobile(BuildContext context)`: Returns true if viewport width < 650.
  - `static bool isTablet(BuildContext context)`: Returns true if 650 <= viewport width < 1100.
  - `static bool isDesktop(BuildContext context)`: Returns true if viewport width >= 1100.

---

### 🖥 Screens (`lib/front_end/screens/`)

#### 1. `lib/front_end/screens/auth_screen.dart`
- **Purpose**: Login and Registration form screen.
- **Classes & Functions**:
  - `class AuthScreen extends StatefulWidget`: Auth form container.
  - `Future<void> _submitEmailAuth()`: Validates form input, calls `AuthService().signInWithEmailAndPassword` or `signUpWithEmailAndPassword`, and manages loading indicators and error messages.
  - `Future<void> _submitGoogleAuth()`: Calls `AuthService().signInWithGoogle()` to open Google OAuth login popup.
  - `String _getReadableAuthError(FirebaseAuthException e)`: Maps Firebase error codes (`user-not-found`, `wrong-password`, `invalid-email`, `email-already-in-use`, `weak-password`) to readable message strings.

#### 2. `lib/front_end/screens/overview_screen.dart`
- **Purpose**: Executive overview dashboard screen.
- **Classes & Functions**:
  - `class OverviewScreen extends StatelessWidget`: Dashboard overview widget. Accepts `onNavigateKey` callback.
  - `Widget build(BuildContext context)`: Resolves current user's name, calculates today's schedule count, queries available rooms, and builds responsive stat cards and feeds.
  - `List<Widget> _buildStatCards(CampusDataRepository repo, int todayCount, int availableRooms)`: Constructs 4 `StatCard` widgets with `onTap` callbacks wired to `onNavigateKey`:
    - Classes Today $\rightarrow$ 'schedule'
    - Pending Assignments $\rightarrow$ 'assignments'
    - Upcoming Events $\rightarrow$ 'events'
    - Available Rooms $\rightarrow$ 'rooms'
  - `Widget _buildTodaySchedule(List todayClasses, String today)`: Renders timeline card for today's classes.
  - `Widget _buildRecentAnnouncements(CampusDataRepository repo)`: Renders recent notice feed card.

#### 3. `lib/front_end/screens/schedule_screen.dart`
- **Purpose**: Timetable management screen.
- **Classes & Functions**:
  - `class ScheduleScreen extends StatefulWidget`: Timetable view.
  - `Widget build(BuildContext context)`: Renders `CampusDataTable` configured with `COURSE`, `WHEN`, and `WHERE` columns mapped from `_repo.schedules`.
  - `void _showAddModal(BuildContext context)`: Opens `RecordFormModal` to create a new class schedule item.
  - `void _showEditModal(BuildContext context, ScheduleItem item)`: Opens `RecordFormModal` pre-populated to update an existing class schedule item.

#### 4. `lib/front_end/screens/rooms_screen.dart`
- **Purpose**: Room directory screen.
- **Classes & Functions**:
  - `class RoomsScreen extends StatefulWidget`: Room availability screen.
  - `Widget build(BuildContext context)`: Renders `CampusDataTable` with `ROOM`, `TYPE`, and `STATUS` columns.
  - `Widget _buildStatusChip(String status)`: Renders styled availability status badges (`Available`, `Occupied`, `Maintenance`).

#### 5. `lib/front_end/screens/events_screen.dart`
- **Purpose**: Campus events screen.
- **Classes & Functions**:
  - `class EventsScreen extends StatefulWidget`: Events directory view.
  - `Widget build(BuildContext context)`: Renders `CampusDataTable` with `EVENT`, `VENUE`, and `DATE` columns.
  - `Widget _buildCapacityBadge(int registered, int capacity)`: Renders progress indicator for event registration numbers.

#### 6. `lib/front_end/screens/announcements_screen.dart`
- **Purpose**: Notice board screen.
- **Classes & Functions**:
  - `class AnnouncementsScreen extends StatefulWidget`: Announcements feed view.
  - `Widget build(BuildContext context)`: Renders `CampusDataTable` with `ANNOUNCEMENT`, `PRIORITY`, and `EXPIRES` columns.
  - `Widget _buildPriorityBadge(String priority)`: Renders priority tags (`HIGH`, `MEDIUM`, `LOW`).

#### 7. `lib/front_end/screens/assignments_screen.dart`
- **Purpose**: Course assignments tracker screen.
- **Classes & Functions**:
  - `class AssignmentsScreen extends StatefulWidget`: Task tracker view.
  - `Widget build(BuildContext context)`: Renders `CampusDataTable` with `ASSIGNMENT`, `COURSE`, and `DEADLINE` columns.
  - `Widget _buildDeadlineBadge(String deadline)`: Calculates urgency and renders color-coded deadline badges.

---

### 🧩 Reusable Widgets (`lib/widget/`)

#### 1. `lib/widget/campus_sidebar.dart`
- **Purpose**: Collapsible navigation sidebar.
- **Classes & Functions**:
  - `class SidebarItem`: Definition model (`label`, `icon`, `key`).
  - `class CampusSidebar extends StatelessWidget`: Sidebar widget.
  - `Widget build(BuildContext context)`: Renders logo header, list of `_SidebarNavItem` widgets, and bottom authenticated user profile section.
  - `class _SidebarNavItem extends StatefulWidget`: Individual navigation item with hover transitions and active tab indicators.
  - User Profile Footer: Displays logged-in user email (`user.email`) and triggers `AuthService().signOut()`.

#### 2. `lib/widget/campus_top_bar.dart`
- **Purpose**: Content header navigation bar.
- **Classes & Functions**:
  - `class CampusTopBar extends StatelessWidget`: Header top bar.
  - `Widget build(BuildContext context)`: Renders breadcrumb trail, search button, AI Assistant toggle button, and `_UserAvatarChip`.
  - `class _UserAvatarChip extends StatelessWidget`: Avatar chip displaying active user's initials, name, and email. Integrates `PopupMenuButton` with a **Sign Out** option calling `AuthService().signOut()`.

#### 3. `lib/widget/data_table_view.dart`
- **Purpose**: Universal data table view (`CampusDataTable`).
- **Classes & Functions**:
  - `class TableCol`: Column model (`label`, `flex`).
  - `class TableRowData`: Row data model (`cells`, `onEdit`, `onDelete`).
  - `class CampusDataTable extends StatefulWidget`: Data table widget.
  - `List<TableRowData> get _filteredRows`: Filters table rows in real-time based on `_searchQuery`.
  - `Widget _buildToolbar()`: Renders search input field and `X of Y records` count indicator.
  - `Widget _buildTable()`: Renders header row and data rows.
  - `class _DataRowWidget extends StatefulWidget`: Individual table row widget supporting mouse hover state and action icons (`Icons.edit_outlined`, `Icons.delete_outline`).

#### 4. `lib/widget/record_form_modal.dart`
- **Purpose**: Generic modal dialog for creating and editing records.
- **Classes & Functions**:
  - `class FormFieldSpec`: Field definition model (`label`, `key`, `type`, `options`, `initialValue`).
  - `class RecordFormModal extends StatefulWidget`: Dynamic form dialog.
  - `Widget _buildField(FormFieldSpec spec)`: Builds appropriate form input (`text`, `dropdown`, `date`, `time`).

#### 5. `lib/widget/stat_card.dart`
- **Purpose**: Micro-animated metric summary card.
- **Classes & Functions**:
  - `class StatCard extends StatefulWidget`: Summary card widget. Accepts `label`, `value`, `icon`, `backgroundColor`, `foregroundColor`, `subtitle`, and `onTap`.
  - `Widget build(BuildContext context)`: Renders card container with smooth hover lift animation (`Matrix4.translationValues(0.0, -2.0, 0.0)`), icon, value, label, and `GestureDetector` click handler.

#### 6. `lib/widget/app_button.dart`
- **Purpose**: Standard button widget.
- **Classes & Functions**:
  - `enum AppButtonVariant`: Button styles (`primary`, `secondary`, `outline`).
  - `class AppButton extends StatefulWidget`: Custom button widget. Manages hover state, loading spinner, icons, and click actions.

#### 7. `lib/widget/app_card.dart`
- **Purpose**: Styled card container wrapper.
- **Classes & Functions**:
  - `class AppCard extends StatelessWidget`: Styled card wrapper. Configures background color, border radius, border color, padding, and tap callbacks.

#### 8. `lib/widget/responsive_grid.dart`
- **Purpose**: Responsive grid container.
- **Classes & Functions**:
  - `class ResponsiveGrid extends StatelessWidget`: Flexible grid builder layout. Dynamically computes column count based on available viewport width.
