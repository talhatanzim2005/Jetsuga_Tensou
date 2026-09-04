class Schedule {
  final String id;
  final String course;
  final String title;
  final String day;
  final String startTime;
  final String endTime;
  final String room;
  final String instructor;
  final String section;

  Schedule({
    required this.id,
    required this.course,
    required this.title,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.instructor,
    required this.section,
  });

  factory Schedule.fromMap(Map<String, dynamic> data, String id) {
    return Schedule(
      id: id,
      course: data['course'] ?? '',
      title: data['title'] ?? '',
      day: data['day'] ?? '',
      startTime: data['start_time'] ?? '',
      endTime: data['end_time'] ?? '',
      room: data['room'] ?? '',
      instructor: data['instructor'] ?? '',
      section: data['section'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'course': course,
      'title': title,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
      'instructor': instructor,
      'section': section,
    };
  }
}

class Room {
  final String id;
  final String roomNumber;
  final String type;
  final int capacity;
  final List<String> equipment;
  final int floor;
  final String status;

  Room({
    required this.id,
    required this.roomNumber,
    required this.type,
    required this.capacity,
    required this.equipment,
    required this.floor,
    required this.status,
  });

  factory Room.fromMap(Map<String, dynamic> data, String id) {
    return Room(
      id: id,
      roomNumber: data['room_number'] ?? '',
      type: data['type'] ?? '',
      capacity: data['capacity']?.toInt() ?? 0,
      equipment: List<String>.from(data['equipment'] ?? []),
      floor: data['floor']?.toInt() ?? 0,
      status: data['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'room_number': roomNumber,
      'type': type,
      'capacity': capacity,
      'equipment': equipment,
      'floor': floor,
      'status': status,
    };
  }
}

class Event {
  final String id;
  final String name;
  final String description;
  final String date;
  final String startTime;
  final String endTime;
  final String endDate;
  final String venue;
  final String organizer;
  final int capacity;
  final int registered;
  final String status;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.endDate,
    required this.venue,
    required this.organizer,
    required this.capacity,
    required this.registered,
    required this.status,
  });

  factory Event.fromMap(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      startTime: data['start_time'] ?? '',
      endTime: data['end_time'] ?? '',
      endDate: data['end_date'] ?? '',
      venue: data['venue'] ?? '',
      organizer: data['organizer'] ?? '',
      capacity: data['capacity']?.toInt() ?? 0,
      registered: data['registered']?.toInt() ?? 0,
      status: data['status'] ?? 'upcoming',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'end_date': endDate,
      'venue': venue,
      'organizer': organizer,
      'capacity': capacity,
      'registered': registered,
      'status': status,
    };
  }
}

class Announcement {
  final String id;
  final String title;
  final String body;
  final String date;
  final String priority;
  final String postedBy;
  final String expires;

  Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.priority,
    required this.postedBy,
    required this.expires,
  });

  factory Announcement.fromMap(Map<String, dynamic> data, String id) {
    return Announcement(
      id: id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      date: data['date'] ?? '',
      priority: data['priority'] ?? 'low',
      postedBy: data['posted_by'] ?? '',
      expires: data['expires'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'date': date,
      'priority': priority,
      'posted_by': postedBy,
      'expires': expires,
    };
  }
}

class Assignment {
  final String id;
  final String course;
  final String courseTitle;
  final String title;
  final String description;
  final String assignedDate;
  final String deadline;
  final String submissionPlatform;
  final String status;
  final int marks;

  Assignment({
    required this.id,
    required this.course,
    required this.courseTitle,
    required this.title,
    required this.description,
    required this.assignedDate,
    required this.deadline,
    required this.submissionPlatform,
    required this.status,
    required this.marks,
  });

  factory Assignment.fromMap(Map<String, dynamic> data, String id) {
    return Assignment(
      id: id,
      course: data['course'] ?? '',
      courseTitle: data['course_title'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      assignedDate: data['assigned_date'] ?? '',
      deadline: data['deadline'] ?? '',
      submissionPlatform: data['submission_platform'] ?? '',
      status: data['status'] ?? 'pending',
      marks: data['marks']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'course': course,
      'course_title': courseTitle,
      'title': title,
      'description': description,
      'assigned_date': assignedDate,
      'deadline': deadline,
      'submission_platform': submissionPlatform,
      'status': status,
      'marks': marks,
    };
  }
}
