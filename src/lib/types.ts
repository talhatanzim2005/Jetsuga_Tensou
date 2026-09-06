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
