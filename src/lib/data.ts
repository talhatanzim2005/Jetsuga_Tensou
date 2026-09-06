import type {
  AgendaItem,
  ClassSession,
  Conflict,
  Deadline,
  Exam,
  Meeting,
  Notice,
  QuickTask,
  RoutineItem,
} from "./types"
import { to12h, toMinutes } from "./utils"

/**
 * The faculty member the workspace is personalized for.
 * FacultyOS scopes every view to this person's routine.
 */
export const FACULTY = {
  name: "Dr. Alimur Razi",
  shortName: "Dr. Razi",
  role: "Associate Professor, CSE",
  department: "Computer Science & Engineering",
  email: "razi@aust.edu",
  initials: "AR",
}

/** Demo "now". The academic week runs Sunday–Thursday. */
export const DEMO_TODAY_DOW = "Sunday"
export const DEMO_DATE = "2026-09-06"

/**
 * Class sessions from data/schedules.json, extended with the additional
 * courses Dr. Razi teaches so the routine is complete. CSE 2201 is the
 * course affected by the revised examination notice.
 */
export const SCHEDULES: ClassSession[] = [
  {
    id: "sch-005",
    course: "CSE 2201",
    title: "Data Structures",
    day: "Sunday",
    start_time: "09:00",
    end_time: "10:20",
    room: "5B",
    instructor: "Dr. Alimur Razi",
    section: "B",
  },
  {
    id: "sch-008",
    course: "CSE 2201",
    title: "Data Structures Lab",
    day: "Sunday",
    start_time: "15:00",
    end_time: "16:20",
    room: "7B02",
    instructor: "Dr. Alimur Razi",
    section: "B",
  },
  {
    id: "sch-006",
    course: "CSE 4113",
    title: "Distributed Systems & Cloud Computing",
    day: "Tuesday",
    start_time: "08:00",
    end_time: "09:30",
    room: "7A03",
    instructor: "Dr. Alimur Razi",
    section: "A",
  },
  {
    id: "sch-007",
    course: "CSE 2201",
    title: "Data Structures",
    day: "Wednesday",
    start_time: "11:00",
    end_time: "12:30",
    room: "7A01",
    instructor: "Dr. Alimur Razi",
    section: "B",
  },
]

/**
 * Examinations Dr. Razi is responsible for.
 * exam-001 (CSE 2201) is the one the university just rescheduled.
 */
export const ORIGINAL_EXAM_TIME = {
  date: "2026-09-18",
  start_time: "09:00",
  end_time: "11:00",
  room: "7C01",
}

export const EXAMS: Exam[] = [
  {
    id: "exam-001",
    course: "CSE 2201",
    title: "Data Structures — Midterm",
    date: "2026-09-20",
    start_time: "11:30",
    end_time: "14:00",
    room: "7C01",
    role: "Course Examiner",
  },
  {
    id: "exam-002",
    course: "CSE 4113",
    title: "Distributed Systems — Midterm",
    date: "2026-09-22",
    start_time: "09:00",
    end_time: "11:00",
    room: "7C02",
    role: "Course Examiner",
  },
]

/** Personal + departmental meetings on Dr. Razi's calendar. */
export const MEETINGS: Meeting[] = [
  {
    id: "mtg-001",
    title: "Department Curriculum Review",
    date: "2026-09-20",
    start_time: "11:00",
    end_time: "12:00",
    room: "7C05",
    organizer: "Head of Department",
  },
  {
    id: "mtg-002",
    title: "Faculty Senate — Monthly",
    date: "2026-09-24",
    start_time: "15:00",
    end_time: "16:00",
    room: "7C05",
    organizer: "Office of the Registrar",
  },
  {
    id: "mtg-003",
    title: "Faculty Meeting",
    date: "2026-09-06",
    start_time: "11:30",
    end_time: "12:15",
    room: "7C05",
    organizer: "Head of Department",
  },
]

/** Faculty-facing deadlines derived from data/assignments.json. */
export const DEADLINES: Deadline[] = [
  {
    id: "asgn-001",
    course: "CSE 4113",
    course_title: "Distributed Systems & Cloud Computing",
    title: "Grade Lab Report 1: Raft Consensus",
    deadline: "2026-09-08",
    platform: "Google Classroom",
    kind: "Grading",
  },
  {
    id: "asgn-002",
    course: "CSE 3201",
    course_title: "Software Engineering",
    title: "Review Project Architecture (ADR) submissions",
    deadline: "2026-09-05",
    platform: "Physical submission",
    kind: "Review",
  },
  {
    id: "dl-003",
    course: "CSE 2201",
    course_title: "Data Structures",
    title: "Finalize midterm question paper",
    deadline: "2026-09-17",
    platform: "Exam Controller Office",
    kind: "Submission",
  },
]

/**
 * University notices. ann-003 is the incoming revised-exam notice that
 * drives the hero journey. `relevant` marks whether FacultyOS decided the
 * notice matters to this faculty member.
 */
export const NOTICES: Notice[] = [
  {
    id: "ann-003",
    title: "Revised Examination Schedule — CSE 2201",
    body: "The CSE 2201 (Data Structures) midterm examination has been rescheduled. Previous: September 18, 9:00 AM. New: September 20, 11:30 AM, Room 7C01. All course examiners must confirm availability.",
    date: "2026-09-05",
    priority: "high",
    posted_by: "Exam Controller Office",
    expires: "2026-09-21",
    relevant: true,
    category: "Examination",
    unread: true,
  },
  {
    id: "ann-001",
    title: "Midterm Examination Schedule Released",
    body: "Fall 2026 midterm exams will commence from September 20th. Check the faculty portal for invigilation duties and seat plans.",
    date: "2026-09-01",
    priority: "high",
    posted_by: "Exam Controller Office",
    expires: "2026-09-25",
    relevant: true,
    category: "Examination",
  },
  {
    id: "ann-002",
    title: "Lab Maintenance Notice for 7B06",
    body: "Room 7B06 hardware maintenance scheduled for Saturday. No access permitted.",
    date: "2026-08-28",
    priority: "medium",
    posted_by: "IT Infrastructure Dept",
    expires: "2026-09-02",
    relevant: false,
    category: "Facilities",
  },
  {
    id: "ann-004",
    title: "Revised AUST Academic Calendar",
    body: "Fall semester dates have been updated. This affects 2 of your planned assignment deadlines.",
    date: "2026-09-04",
    priority: "medium",
    posted_by: "Office of the Registrar",
    expires: "2026-09-30",
    relevant: true,
    category: "Academic",
    unread: true,
  },
  {
    id: "ann-005",
    title: "Research Grant Applications Open",
    body: "University grants for Q4 are now accepting submissions. No direct action required for your current schedule.",
    date: "2026-09-03",
    priority: "low",
    posted_by: "Research & Extension Office",
    expires: "2026-10-15",
    relevant: true,
    category: "General",
  },
]

/** Faculty quick tasks, seeded to match the dashboard design. */
export const QUICK_TASKS: QuickTask[] = [
  { id: "qt-1", title: "Submit CSE 2201 Grades", done: false },
  { id: "qt-2", title: "Review Lab Reports", done: false },
  { id: "qt-3", title: "Grade final project submissions (CSE 2203)", done: false },
  { id: "qt-4", title: "Set Midterm paper questions (CSE 2201)", done: false },
  { id: "qt-5", title: "Review PhD student's draft paper", done: false },
  { id: "qt-6", title: "Organize group photo for graduating class", done: false },
  { id: "qt-7", title: "Appraise faculty promotion candidates", done: false },
  { id: "qt-8", title: "Schedule make-up class (CSE 2201)", done: false },
  { id: "qt-9", title: "Prepare Meeting Notes", done: true },
]

export function facultyClassesFor(day: string): ClassSession[] {
  return SCHEDULES.filter(
    (s) => s.day === day && s.instructor === FACULTY.name,
  ).sort((a, b) => toMinutes(a.start_time) - toMinutes(b.start_time))
}

/** Today's merged agenda: classes/labs plus any meetings dated today. */
export function todayAgenda(): AgendaItem[] {
  const classes = facultyClassesFor(DEMO_TODAY_DOW).map((s) => ({
    id: s.id,
    time: to12h(s.start_time),
    title: s.title.endsWith("Lab") ? `${s.course} Lab` : s.course,
    detail: `Room ${s.room}`,
    kind: "class" as const,
    sort: toMinutes(s.start_time),
  }))
  const meetings = MEETINGS.filter((m) => m.date === DEMO_DATE).map((m) => ({
    id: m.id,
    time: to12h(m.start_time),
    title: m.title,
    kind: "meeting" as const,
    sort: toMinutes(m.start_time),
  }))
  return [...classes, ...meetings]
    .sort((a, b) => a.sort - b.sort)
    .map(({ sort: _sort, ...item }) => item)
}

/** All routine items unified so conflicts can be computed across types. */
export function buildRoutine(): RoutineItem[] {
  const items: RoutineItem[] = []
  for (const e of EXAMS) {
    items.push({
      id: e.id,
      kind: "exam",
      title: `${e.course} Exam`,
      subtitle: e.title,
      date: e.date,
      start_time: e.start_time,
      end_time: e.end_time,
      room: e.room,
    })
  }
  for (const m of MEETINGS) {
    items.push({
      id: m.id,
      kind: "meeting",
      title: m.title,
      subtitle: m.organizer,
      date: m.date,
      start_time: m.start_time,
      end_time: m.end_time,
      room: m.room,
    })
  }
  return items
}

/** Detect overlapping routine items that share a date. */
export function detectConflicts(items: RoutineItem[]): Conflict[] {
  const conflicts: Conflict[] = []
  for (let i = 0; i < items.length; i++) {
    for (let j = i + 1; j < items.length; j++) {
      const a = items[i]
      const b = items[j]
      if (a.date !== b.date) continue
      const aStart = toMinutes(a.start_time)
      const aEnd = toMinutes(a.end_time)
      const bStart = toMinutes(b.start_time)
      const bEnd = toMinutes(b.end_time)
      const overlapStart = Math.max(aStart, bStart)
      const overlapEnd = Math.min(aEnd, bEnd)
      if (overlapStart < overlapEnd) {
        const fmt = (mins: number) =>
          `${String(Math.floor(mins / 60)).padStart(2, "0")}:${String(
            mins % 60,
          ).padStart(2, "0")}`
        conflicts.push({
          a,
          b,
          date: a.date,
          overlapStart: fmt(overlapStart),
          overlapEnd: fmt(overlapEnd),
          overlapMinutes: overlapEnd - overlapStart,
        })
      }
    }
  }
  return conflicts
}

export const PRIMARY_CONFLICT = detectConflicts(buildRoutine())[0]
