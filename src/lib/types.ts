export type Priority = "high" | "medium" | "low"

export interface ClassSession {
  id: string
  course: string
  title: string
  day: string
  start_time: string
  end_time: string
  room: string
  instructor: string
  section: string
}

export interface Exam {
  id: string
  course: string
  title: string
  date: string
  start_time: string
  end_time: string
  room: string
  role: string
}

export interface Meeting {
  id: string
  title: string
  date: string
  start_time: string
  end_time: string
  room: string
  organizer: string
}

export interface Deadline {
  id: string
  course: string
  course_title: string
  title: string
  deadline: string
  platform: string
  kind: string
}

export interface Notice {
  id: string
  title: string
  body: string
  date: string
  priority: Priority
  posted_by: string
  expires: string
  relevant: boolean
  category: string
  unread?: boolean
  /** AUST Intel: relative time label, e.g. "2 hours ago". */
  ago?: string
  /** AUST Intel: the AI's read on how this notice affects the faculty member. */
  analysis?: string
  /** AUST Intel: a follow-up impact line highlighted inside the analysis. */
  impact?: string
  /** AUST Intel: link to the source document. */
  link?: string
  /** AUST Intel: primary action label, when the notice needs one. */
  actionLabel?: string
}

export interface QuickTask {
  id: string
  title: string
  done: boolean
}

export interface AgendaItem {
  id: string
  time: string
  title: string
  detail?: string
  kind: "class" | "meeting"
}

export interface RoutineItem {
  id: string
  kind: "class" | "exam" | "meeting"
  title: string
  subtitle: string
  date: string
  start_time: string
  end_time: string
  room: string
}

export interface Conflict {
  a: RoutineItem
  b: RoutineItem
  date: string
  overlapStart: string
  overlapEnd: string
  overlapMinutes: number
}

export type WeekEventKind =
  | "class"
  | "lab"
  | "meeting"
  | "office"
  | "research"

/** A block on the weekly routine timetable. */
export interface WeekEvent {
  id: string
  day: string
  start: string
  end: string
  title: string
  subtitle?: string
  room?: string
  kind: WeekEventKind
  conflict?: boolean
}
