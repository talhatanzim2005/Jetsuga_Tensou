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
import type { QuickTask } from "./types"
import { formatDate, to12h } from "./utils"

export interface AssistantReply {
  text: string
  /** Optional structured callouts rendered as chips under the message. */
  tags?: { label: string; tone: "info" | "warning" | "danger" | "success" }[]
}

export const SUGGESTED_QUESTIONS = [
  "What do I have tomorrow?",
  "When is my next examination?",
  "Add task Prepare slides for CSE 2201",
  "Show my tasks",
  "Do I have any conflicts next week?",
]

/** Actions the assistant can perform on the shared quick-tasks store. */
export interface TaskActions {
  tasks: QuickTask[]
  addTask: (title: string) => QuickTask
  updateTask: (id: string, patch: Partial<Omit<QuickTask, "id">>) => void
  deleteTask: (id: string) => void
}

function findTask(tasks: QuickTask[], query: string): QuickTask | undefined {
  const q = query.trim().toLowerCase().replace(/[.?!]+$/, "")
  if (!q) return undefined
  return (
    tasks.find((t) => t.title.toLowerCase() === q) ??
    tasks.find((t) => t.title.toLowerCase().includes(q)) ??
    tasks.find((t) => q.includes(t.title.toLowerCase()))
  )
}

function taskNotFound(query: string, tasks: QuickTask[]): AssistantReply {
  const open = tasks.filter((t) => !t.done)
  const preview = open
    .slice(0, 3)
    .map((t) => `"${t.title}"`)
    .join(", ")
  return {
    text: `I couldn't find a task matching "${query.trim()}".${
      open.length > 0
        ? ` Your open tasks are: ${preview}${open.length > 3 ? `, and ${open.length - 3} more` : ""}.`
        : " Your task list is empty."
    }`,
    tags: [{ label: "No match", tone: "warning" }],
  }
}

/**
 * Parses task-management commands ("add task X", "delete task X",
 * "rename task X to Y", "complete task X", "show my tasks") and applies them
 * to the shared store. Returns null when the message is not a task command,
 * so the caller can fall back to the Q&A brain.
 */
export function tryTaskCommand(
  question: string,
  actions: TaskActions,
): AssistantReply | null {
  const q = question.trim()

  const add = q.match(
    /^(?:please\s+)?(?:add|create|new)\s+(?:a\s+|an\s+)?(?:new\s+)?task[\s:–-]+(.+)$/i,
  )
  if (add) {
    const task = actions.addTask(add[1])
    const open = actions.tasks.filter((t) => !t.done).length + 1
    return {
      text: `Done — I've added "${task.title}" to your Quick Tasks. You now have ${open} open task${open === 1 ? "" : "s"}.`,
      tags: [{ label: "Task added", tone: "success" }],
    }
  }

  const del = q.match(
    /^(?:please\s+)?(?:delete|remove)\s+(?:the\s+)?task[\s:–-]+(.+)$/i,
  )
  if (del) {
    const task = findTask(actions.tasks, del[1])
    if (!task) return taskNotFound(del[1], actions.tasks)
    actions.deleteTask(task.id)
    return {
      text: `Removed "${task.title}" from your Quick Tasks.`,
      tags: [{ label: "Task deleted", tone: "success" }],
    }
  }

  const edit = q.match(
    /^(?:please\s+)?(?:edit|rename|update|change)\s+(?:the\s+)?task[\s:–-]+(.+?)\s+(?:to|into|as)[\s:]+(.+)$/i,
  )
  if (edit) {
    const task = findTask(actions.tasks, edit[1])
    if (!task) return taskNotFound(edit[1], actions.tasks)
    const title = edit[2].trim().replace(/[.?!]+$/, "")
    actions.updateTask(task.id, { title })
    return {
      text: `Updated the task — "${task.title}" is now "${title}".`,
      tags: [{ label: "Task updated", tone: "success" }],
    }
  }

  const done = q.match(
    /^(?:please\s+)?(?:complete|finish|check|mark)\s+(?:off\s+)?(?:the\s+)?task[\s:–-]+(.+)$/i,
  )
  if (done) {
    const title = done[1]
      .replace(/\s+(?:as\s+)?(?:done|complete|completed|off)$/i, "")
      .trim()
    const task = findTask(actions.tasks, title)
    if (!task) return taskNotFound(title, actions.tasks)
    actions.updateTask(task.id, { done: true })
    const remaining = actions.tasks.filter((t) => !t.done && t.id !== task.id).length
    return {
      text: `Marked "${task.title}" as done. ${remaining} open task${remaining === 1 ? "" : "s"} remaining.`,
      tags: [{ label: "Completed", tone: "success" }],
    }
  }

  if (/^(?:show|list|what(?:'s| is| are))\s*(?:my\s+)?(?:open\s+)?tasks?\b/i.test(q)) {
    const open = actions.tasks.filter((t) => !t.done)
    if (open.length === 0) {
      return {
        text: "Your Quick Tasks list is clear — nothing open right now. Tell me \"add task …\" to create one.",
        tags: [{ label: "All clear", tone: "success" }],
      }
    }
    return {
      text: `You have ${open.length} open task${open.length === 1 ? "" : "s"}: ${open
        .map((t, i) => `${i + 1}. ${t.title}`)
        .join("  ")}`,
      tags: [{ label: `${open.length} open`, tone: "info" }],
    }
  }

  return null
}

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
