import 'package:flutter/foundation.dart';
import 'package:hackathon/back_end/models.dart';

class CampusDataRepository extends ChangeNotifier {
  static final CampusDataRepository _instance = CampusDataRepository._internal();
  factory CampusDataRepository() => _instance;

  CampusDataRepository._internal() {
    _initSeedData();
  }

  final List<Schedule> _schedules = [];
  final List<Room> _rooms = [];
  final List<Event> _events = [];
  final List<Announcement> _announcements = [];
  final List<Assignment> _assignments = [];

  List<Schedule> get schedules => List.unmodifiable(_schedules);
  List<Room> get rooms => List.unmodifiable(_rooms);
  List<Event> get events => List.unmodifiable(_events);
  List<Announcement> get announcements => List.unmodifiable(_announcements);
  List<Assignment> get assignments => List.unmodifiable(_assignments);

  void _initSeedData() {
    _schedules.addAll([
      Schedule(
        id: 'sch-001',
        course: 'CSE 4113',
        title: 'Distributed Systems & Cloud Computing',
        day: 'Sunday',
        startTime: '08:00',
        endTime: '09:30',
        room: '7A03',
        instructor: 'Dr. Alimur Razi',
        section: 'A',
      ),
      Schedule(
        id: 'sch-002',
        course: 'CSE 4114',
        title: 'Distributed Systems Lab',
        day: 'Sunday',
        startTime: '09:30',
        endTime: '12:30',
        room: '7B02',
        instructor: 'Lecturer Sharmin Akter',
        section: 'A1/A2',
      ),
      Schedule(
        id: 'sch-003',
        course: 'CSE 3201',
        title: 'Software Engineering',
        day: 'Monday',
        startTime: '10:00',
        endTime: '11:30',
        room: '7A05',
        instructor: 'Prof. Hasan Sarwar',
        section: 'B',
      ),
      Schedule(
        id: 'sch-004',
        course: 'CSE 4203',
        title: 'Artificial Intelligence & Neural Nets',
        day: 'Tuesday',
        startTime: '11:30',
        endTime: '13:00',
        room: '7C01',
        instructor: 'Dr. Tariqul Islam',
        section: 'DWM',
      ),
    ]);

    _rooms.addAll([
      Room(
        id: 'room-001',
        roomNumber: '7A03',
        type: 'classroom',
        capacity: 45,
        equipment: ['projector', 'AC', 'whiteboard'],
        floor: 7,
        status: 'available',
      ),
      Room(
        id: 'room-002',
        roomNumber: '7B02',
        type: 'lab',
        capacity: 30,
        equipment: ['projector', 'AC', 'computers', 'whiteboard'],
        floor: 7,
        status: 'available',
      ),
      Room(
        id: 'room-003',
        roomNumber: '7B06',
        type: 'lab',
        capacity: 35,
        equipment: ['AC', 'computers', 'whiteboard'],
        floor: 7,
        status: 'available',
      ),
      Room(
        id: 'room-004',
        roomNumber: '7C01',
        type: 'seminar',
        capacity: 65,
        equipment: ['projector', 'AC', 'sound system', 'podium'],
        floor: 7,
        status: 'available',
      ),
      Room(
        id: 'room-005',
        roomNumber: '7C04',
        type: 'seminar',
        capacity: 60,
        equipment: ['projector', 'AC', 'sound system'],
        floor: 7,
        status: 'unavailable',
      ),
    ]);

    _events.addAll([
      Event(
        id: 'evt-001',
        name: 'CSE Carnival 8.0 Hackathon',
        description: 'Annual flagship competitive programming & AI hackathon at AUST.',
        date: '2026-09-10',
        startTime: '09:00',
        endTime: '18:00',
        endDate: '2026-09-10',
        venue: '7C01',
        organizer: 'AUST CSE Society',
        capacity: 50,
        registered: 42,
        status: 'upcoming',
      ),
      Event(
        id: 'evt-002',
        name: 'AI Agent Workshop: ReAct Patterns',
        description: 'Hands-on session on building tool-augmented autonomous AI agents.',
        date: '2026-09-15',
        startTime: '14:00',
        endTime: '16:30',
        endDate: '2026-09-15',
        venue: '7B02',
        organizer: 'Innovation Club',
        capacity: 30,
        registered: 30,
        status: 'full',
      ),
    ]);

    _announcements.addAll([
      Announcement(
        id: 'ann-001',
        title: 'Midterm Examination Schedule Released',
        body: 'Fall 2026 midterm exams will commence from September 20th. Check your student portal for seat plans.',
        date: '2026-09-01',
        priority: 'high',
        postedBy: 'Exam Controller Office',
        expires: '2026-09-25',
      ),
      Announcement(
        id: 'ann-002',
        title: 'Lab Maintenance Notice for 7B06',
        body: 'Room 7B06 hardware maintenance scheduled for Saturday. No access permitted.',
        date: '2026-08-28',
        priority: 'medium',
        postedBy: 'IT Infrastructure Dept',
        expires: '2026-09-02',
      ),
    ]);

    _assignments.addAll([
      Assignment(
        id: 'asgn-001',
        course: 'CSE 4113',
        courseTitle: 'Distributed Systems & Cloud Computing',
        title: 'Lab Report 1: Raft Consensus Protocol',
        description: 'Implement leader election and log replication using Go or Python.',
        assignedDate: '2026-09-01',
        deadline: '2026-09-08',
        submissionPlatform: 'Google Classroom',
        status: 'pending',
        marks: 20,
      ),
      Assignment(
        id: 'asgn-002',
        course: 'CSE 3201',
        courseTitle: 'Software Engineering',
        title: 'Project Architecture Document (ADR)',
        description: 'Submit C4 model diagrams and 3 ADR entries for your semester project.',
        assignedDate: '2026-08-25',
        deadline: '2026-09-05',
        submissionPlatform: 'Physical submission',
        status: 'pending',
        marks: 15,
      ),
    ]);
  }

  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  void updateSchedule(Schedule updated) {
    final index = _schedules.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _schedules[index] = updated;
      notifyListeners();
    }
  }

  void deleteSchedule(String id) {
    _schedules.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void addRoom(Room room) {
    _rooms.add(room);
    notifyListeners();
  }

  void updateRoom(Room updated) {
    final index = _rooms.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      _rooms[index] = updated;
      notifyListeners();
    }
  }

  void deleteRoom(String id) {
    _rooms.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void updateEvent(Event updated) {
    final index = _events.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _events[index] = updated;
      notifyListeners();
    }
  }

  void deleteEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void registerStudentForEvent(String eventId, String studentId, String studentName) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final current = _events[index];
      if (current.registered < current.capacity) {
        final newCount = current.registered + 1;
        final newStatus = newCount >= current.capacity ? 'full' : current.status;
        _events[index] = Event(
          id: current.id,
          name: current.name,
          description: current.description,
          date: current.date,
          startTime: current.startTime,
          endTime: current.endTime,
          endDate: current.endDate,
          venue: current.venue,
          organizer: current.organizer,
          capacity: current.capacity,
          registered: newCount,
          status: newStatus,
        );
        notifyListeners();
      }
    }
  }

  void addAnnouncement(Announcement announcement) {
    _announcements.add(announcement);
    notifyListeners();
  }

  void updateAnnouncement(Announcement updated) {
    final index = _announcements.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _announcements[index] = updated;
      notifyListeners();
    }
  }

  void deleteAnnouncement(String id) {
    _announcements.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    notifyListeners();
  }

  void updateAssignment(Assignment updated) {
    final index = _assignments.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      _assignments[index] = updated;
      notifyListeners();
    }
  }

  void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}
