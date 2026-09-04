import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hackathon/back_end/models.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _schedulesRef => _db.collection('schedules');
  CollectionReference<Map<String, dynamic>> get _roomsRef => _db.collection('rooms');
  CollectionReference<Map<String, dynamic>> get _eventsRef => _db.collection('events');
  CollectionReference<Map<String, dynamic>> get _announcementsRef => _db.collection('announcements');
  CollectionReference<Map<String, dynamic>> get _assignmentsRef => _db.collection('assignments');

  Stream<List<Schedule>> streamSchedules() {
    return _schedulesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Schedule.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<Room>> streamRooms() {
    return _roomsRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Room.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<Event>> streamEvents() {
    return _eventsRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Event.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<Announcement>> streamAnnouncements() {
    return _announcementsRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Announcement.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<Assignment>> streamAssignments() {
    return _assignmentsRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Assignment.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addSchedule(Schedule schedule) async {
    await _schedulesRef.doc(schedule.id).set(schedule.toMap());
  }

  Future<void> updateSchedule(Schedule schedule) async {
    await _schedulesRef.doc(schedule.id).update(schedule.toMap());
  }

  Future<void> deleteSchedule(String id) async {
    await _schedulesRef.doc(id).delete();
  }

  Future<void> addRoom(Room room) async {
    await _roomsRef.doc(room.id).set(room.toMap());
  }

  Future<void> updateRoom(Room room) async {
    await _roomsRef.doc(room.id).update(room.toMap());
  }

  Future<void> deleteRoom(String id) async {
    await _roomsRef.doc(id).delete();
  }

  Future<void> addEvent(Event event) async {
    await _eventsRef.doc(event.id).set(event.toMap());
  }

  Future<void> updateEvent(Event event) async {
    await _eventsRef.doc(event.id).update(event.toMap());
  }

  Future<void> deleteEvent(String id) async {
    await _eventsRef.doc(id).delete();
  }

  Future<void> registerStudentForEvent(String eventId, String studentId, String studentName) async {
    final doc = await _eventsRef.doc(eventId).get();
    if (doc.exists) {
      final event = Event.fromMap(doc.data()!, doc.id);
      if (event.registered < event.capacity) {
        final newCount = event.registered + 1;
        final newStatus = newCount >= event.capacity ? 'full' : event.status;
        await _eventsRef.doc(eventId).update({
          'registered': newCount,
          'status': newStatus,
        });
      }
    }
  }

  Future<void> addAnnouncement(Announcement announcement) async {
    await _announcementsRef.doc(announcement.id).set(announcement.toMap());
  }

  Future<void> updateAnnouncement(Announcement announcement) async {
    await _announcementsRef.doc(announcement.id).update(announcement.toMap());
  }

  Future<void> deleteAnnouncement(String id) async {
    await _announcementsRef.doc(id).delete();
  }

  Future<void> addAssignment(Assignment assignment) async {
    await _assignmentsRef.doc(assignment.id).set(assignment.toMap());
  }

  Future<void> updateAssignment(Assignment assignment) async {
    await _assignmentsRef.doc(assignment.id).update(assignment.toMap());
  }

  Future<void> deleteAssignment(String id) async {
    await _assignmentsRef.doc(id).delete();
  }

  Future<void> seedIfEmpty() async {
    try {
      final schedulesSnap = await _schedulesRef.get();
      if (schedulesSnap.docs.isEmpty) {
        final seedSchedules = [
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
        ];
        for (var s in seedSchedules) {
          await addSchedule(s);
        }
      }

      final roomsSnap = await _roomsRef.get();
      if (roomsSnap.docs.isEmpty) {
        final seedRooms = [
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
            id: 'room-004',
            roomNumber: '7C01',
            type: 'seminar',
            capacity: 65,
            equipment: ['projector', 'AC', 'sound system'],
            floor: 7,
            status: 'available',
          ),
        ];
        for (var r in seedRooms) {
          await addRoom(r);
        }
      }
    } catch (e) {
      debugPrint('Firestore seed error: $e');
    }
  }
}
