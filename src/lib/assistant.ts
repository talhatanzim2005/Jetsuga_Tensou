import {
  DEADLINES,
  EXAMS,
  FACULTY,
  MEETINGS,
  NOTICES,
  ORIGINAL_EXAM_TIME,
  PRIMARY_CONFLICT,
  SCHEDULES,
} from "./data"
import { formatDate, to12h } from "./utils"

export interface AssistantReply {
  text: string
  /** Optional structured callouts rendered as chips under the message. */
  tags?: { label: string; tone: "info" | "warning" | "danger" | "success" }[]
}

export const SUGGESTED_QUESTIONS = [
  "What do I have tomorrow?",
  "When is my next examination?",
  "What important notices were published this week?",
  "Did anything change in my schedule?",
  "Do I have any conflicts next week?",
]

/** A deterministic, offline "AI" that answers from the faculty member's data. */
export function answer(question: string): AssistantReply {
  const q = question.toLowerCase()

  if (q.includes("tomorrow")) {
    // Demo "today" is Sunday, so tomorrow is Monday (no classes) — be honest.
    const mondayClasses = SCHEDULES.filter(
      (s) => s.day === "Monday" && s.instructor === FACULTY.name,
    )
    if (mondayClasses.length === 0) {
      return {
        text: "You have no classes scheduled for tomorrow (Monday). Your next teaching day is Tuesday: CSE 4113 — Distributed Systems at 8:00 AM in Room 7A03.",
        tags: [{ label: "Tue · CSE 4113 · 8:00 AM", tone: "info" }],
      }
    }
    return { text: "You have classes tomorrow." }
  }

  if (
    q.includes("next exam") ||
    q.includes("next examination") ||
    (q.includes("exam") && q.includes("when"))
  ) {
    const exam = [...EXAMS].sort((a, b) =>
      a.date.localeCompare(b.date),
    )[0]
    return {
      text: `Your next examination is the ${exam.course} ${exam.title} on ${formatDate(
        exam.date,
      )} at ${to12h(exam.start_time)} in Room ${exam.room}. Note: this exam was recently moved from its original ${to12h(
        ORIGINAL_EXAM_TIME.start_time,
      )} slot.`,
      tags: [
        { label: `${exam.course} · ${formatDate(exam.date)}`, tone: "warning" },
        { label: "Rescheduled", tone: "danger" },
      ],
    }
  }

  if (q.includes("notice") || q.includes("published") || q.includes("news")) {
    const relevant = NOTICES.filter((n) => n.relevant)
    return {
      text: `${relevant.length} notices this week matter to you. The most important: "${relevant[0].title}" from the ${relevant[0].posted_by}. It changes your CSE 2201 exam time — I've already checked it against your routine.`,
      tags: relevant.map((n) => ({
        label: n.title,
        tone: n.priority === "high" ? ("danger" as const) : ("info" as const),
      })),
    }
  }

  if (
    q.includes("change") ||
    q.includes("changed") ||
    q.includes("update") ||
    q.includes("different")
  ) {
    return {
      text: `Yes — one change affects you. Your CSE 2201 (Data Structures) midterm moved from ${formatDate(
        ORIGINAL_EXAM_TIME.date,
      )}, ${to12h(ORIGINAL_EXAM_TIME.start_time)} to ${formatDate(
        EXAMS[0].date,
      )}, ${to12h(
        EXAMS[0].start_time,
      )}. This new time overlaps another item on your calendar.`,
      tags: [
        { label: "CSE 2201 exam moved", tone: "warning" },
        { label: "Creates a conflict", tone: "danger" },
      ],
    }
  }

  if (
    q.includes("conflict") ||
    q.includes("overlap") ||
    q.includes("clash") ||
    q.includes("free")
  ) {
    if (PRIMARY_CONFLICT) {
      const c = PRIMARY_CONFLICT
      return {
        text: `Yes. On ${formatDate(c.date)}, your "${c.a.subtitle}" (${to12h(
          c.a.start_time,
        )}–${to12h(c.a.end_time)}) overlaps "${c.b.title}" (${to12h(
          c.b.start_time,
        )}–${to12h(c.b.end_time)}) by ${c.overlapMinutes} minutes. Suggested action: reschedule the ${c.b.title.toLowerCase()}.`,
        tags: [
          { label: `${c.overlapMinutes} min overlap`, tone: "danger" },
          { label: formatDate(c.date), tone: "warning" },
        ],
      }
    }
    return { text: "Good news — no conflicts found on your calendar next week." }
  }

  if (q.includes("meeting")) {
    const m = MEETINGS[0]
    return {
      text: `Your next meeting is "${m.title}" on ${formatDate(m.date)} at ${to12h(
        m.start_time,
      )} in Room ${m.room}, organized by the ${m.organizer}. Heads up: it currently conflicts with your rescheduled CSE 2201 exam.`,
      tags: [{ label: "Conflict detected", tone: "danger" }],
    }
  }

  if (q.includes("deadline") || q.includes("due") || q.includes("grade")) {
    const next = [...DEADLINES].sort((a, b) =>
      a.deadline.localeCompare(b.deadline),
    )[0]
    return {
      text: `Your nearest deadline is "${next.title}" (${next.course}) due ${formatDate(
        next.deadline,
      )} via ${next.platform}.`,
      tags: [{ label: `Due ${formatDate(next.deadline)}`, tone: "warning" }],
    }
  }

  return {
    text: "I can answer questions about your classes, exams, meetings, deadlines, notices, and schedule conflicts. Try asking \u201CDo I have any conflicts next week?\u201D or \u201CWhen is my next examination?\u201D",
  }
}
