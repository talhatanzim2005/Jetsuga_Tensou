"use client"

import { Calendar, ChevronLeft, ChevronRight, Plus } from "lucide-react"
import { AppShell } from "@/components/app-shell"
import { WeeklyTimetable } from "@/components/weekly-timetable"

const LEGEND = [
  { label: "Classes", dot: "bg-emerald-500" },
  { label: "Labs", dot: "bg-sky-500" },
  { label: "Meetings", dot: "bg-violet-500" },
  { label: "Office Hours", dot: "bg-amber-500" },
  { label: "Research", dot: "bg-orange-500" },
]

function Routine() {
  return (
    <div className="space-y-5">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <p className="text-xs font-medium uppercase tracking-wider text-muted-foreground">
            My Routine
          </p>
          <h1 className="mt-0.5 text-2xl font-bold tracking-tight">
            Weekly Schedule
          </h1>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          <div className="flex items-center rounded-lg border border-border bg-card">
            <button
              type="button"
              aria-label="Previous week"
              className="flex h-9 w-9 items-center justify-center text-muted-foreground transition-colors hover:text-foreground"
            >
              <ChevronLeft className="h-4 w-4" />
            </button>
            <span className="flex items-center gap-2 border-x border-border px-3 text-sm font-medium">
              <Calendar className="h-4 w-4 text-muted-foreground" />
              Sep 6 – Sep 10, 2026
            </span>
            <button
              type="button"
              aria-label="Next week"
              className="flex h-9 w-9 items-center justify-center text-muted-foreground transition-colors hover:text-foreground"
            >
              <ChevronRight className="h-4 w-4" />
            </button>
          </div>

          <button
            type="button"
            className="rounded-lg border border-border bg-card px-3.5 py-2 text-sm font-medium transition-colors hover:bg-muted"
          >
            Today
          </button>

          <button
            type="button"
            className="flex items-center gap-1.5 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground shadow-md shadow-primary/25 transition-transform hover:scale-[1.02] active:scale-[0.99]"
          >
            <Plus className="h-4 w-4" />
            Add Personal Event
          </button>
        </div>
      </div>

      {/* Legend */}
      <div className="flex flex-wrap items-center gap-x-5 gap-y-2">
        {LEGEND.map((l) => (
          <span
            key={l.label}
            className="flex items-center gap-1.5 text-xs font-medium text-muted-foreground"
          >
            <span className={`h-2.5 w-2.5 rounded-full ${l.dot}`} />
            {l.label}
          </span>
        ))}
      </div>

      <WeeklyTimetable />
    </div>
  )
}

export default function RoutinePage() {
  return (
    <AppShell>
      <Routine />
    </AppShell>
  )
}
