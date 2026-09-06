"use client"

import { CalendarClock, ClipboardList, MapPin, TriangleAlert } from "lucide-react"
import { Badge, CourseTag, Panel, PanelHeader } from "@/components/primitives"
import { DEADLINES, EXAMS, PRIMARY_CONFLICT } from "@/lib/data"
import { formatDate, to12h } from "@/lib/utils"

export function UpcomingExams({
  onReviewConflict,
}: {
  onReviewConflict: () => void
}) {
  const conflictExamId = PRIMARY_CONFLICT?.a.id

  return (
    <Panel>
      <PanelHeader
        title="Upcoming Exams"
        icon={<CalendarClock className="h-4 w-4" />}
      />
      <ul className="space-y-3">
        {EXAMS.map((e) => {
          const hasConflict = e.id === conflictExamId
          return (
            <li
              key={e.id}
              className="rounded-lg border border-border bg-background/40 p-3.5"
            >
              <div className="mb-1.5 flex items-center justify-between gap-2">
                <CourseTag code={e.course} />
                {hasConflict ? (
                  <Badge tone="danger">
                    <TriangleAlert className="h-3 w-3" /> Conflict
                  </Badge>
                ) : (
                  <Badge tone="warning">{e.role}</Badge>
                )}
              </div>
              <h3 className="text-sm font-medium">{e.title}</h3>
              <div className="mt-1.5 flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground">
                <span className="font-mono">{formatDate(e.date)}</span>
                <span>
                  {to12h(e.start_time)} – {to12h(e.end_time)}
                </span>
                <span className="inline-flex items-center gap-1">
                  <MapPin className="h-3.5 w-3.5" /> {e.room}
                </span>
              </div>
              {hasConflict ? (
                <button
                  type="button"
                  onClick={onReviewConflict}
                  className="mt-3 inline-flex items-center gap-1.5 rounded-md bg-danger/15 px-2.5 py-1.5 text-xs font-medium text-danger transition-colors hover:bg-danger/25"
                >
                  <TriangleAlert className="h-3.5 w-3.5" />
                  Review conflict
                </button>
              ) : null}
            </li>
          )
        })}
      </ul>
    </Panel>
  )
}

const kindTone = {
  Grading: "info",
  Review: "warning",
  Submission: "neutral",
} as const

export function Deadlines() {
  const sorted = [...DEADLINES].sort((a, b) =>
    a.deadline.localeCompare(b.deadline),
  )

  return (
    <Panel>
      <PanelHeader
        title="Deadlines"
        icon={<ClipboardList className="h-4 w-4" />}
      />
      <ul className="space-y-3">
        {sorted.map((d) => (
          <li
            key={d.id}
            className="flex items-start gap-3 rounded-lg border border-border bg-background/40 p-3.5"
          >
            <div className="min-w-0 flex-1">
              <div className="mb-1 flex items-center gap-2">
                <CourseTag code={d.course} />
                <Badge tone={kindTone[d.kind as keyof typeof kindTone] ?? "neutral"}>
                  {d.kind}
                </Badge>
              </div>
              <h3 className="text-sm font-medium leading-snug">{d.title}</h3>
              <p className="mt-1 text-xs text-muted-foreground">{d.platform}</p>
            </div>
            <div className="shrink-0 text-right">
              <p className="font-mono text-xs font-semibold">
                {formatDate(d.deadline)}
              </p>
            </div>
          </li>
        ))}
      </ul>
    </Panel>
  )
}
