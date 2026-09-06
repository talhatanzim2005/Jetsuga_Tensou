"use client"

import { MapPin, TriangleAlert } from "lucide-react"
import { WEEK_DAYS, WEEK_EVENTS } from "@/lib/data"
import type { WeekEvent, WeekEventKind } from "@/lib/types"
import { cn, toMinutes } from "@/lib/utils"

const DAY_START = 8 * 60 // 8 AM
const DAY_END = 17 * 60 // 5 PM
const SPAN = DAY_END - DAY_START
const HOURS = [8, 9, 10, 11, 12, 13, 14, 15, 16]

const kindStyles: Record<
  WeekEventKind,
  { block: string; dot: string; label: string }
> = {
  class: {
    block: "border-l-emerald-500 bg-emerald-50 text-emerald-900",
    dot: "bg-emerald-500",
    label: "Classes",
  },
  lab: {
    block: "border-l-sky-500 bg-sky-50 text-sky-900",
    dot: "bg-sky-500",
    label: "Labs",
  },
  meeting: {
    block: "border-l-violet-500 bg-violet-50 text-violet-900",
    dot: "bg-violet-500",
    label: "Meetings",
  },
  office: {
    block: "border-l-amber-500 bg-amber-50 text-amber-900",
    dot: "bg-amber-500",
    label: "Office Hours",
  },
  research: {
    block: "border-l-orange-500 bg-orange-50 text-orange-900",
    dot: "bg-orange-500",
    label: "Research",
  },
}

function left(start: string) {
  return ((toMinutes(start) - DAY_START) / SPAN) * 100
}
function width(start: string, end: string) {
  return ((toMinutes(end) - toMinutes(start)) / SPAN) * 100
}

function EventBlock({ event }: { event: WeekEvent }) {
  const style = kindStyles[event.kind]
  return (
    <div
      className={cn(
        "absolute top-1.5 bottom-1.5 flex min-w-0 flex-col justify-center overflow-hidden rounded-lg border-l-4 px-2.5 py-1.5 shadow-sm",
        style.block,
      )}
      style={{ left: `${left(event.start)}%`, width: `${width(event.start, event.end)}%` }}
      title={`${event.title}${event.subtitle ? ` — ${event.subtitle}` : ""}`}
    >
      <p className="truncate text-xs font-bold leading-tight">{event.title}</p>
      {event.subtitle ? (
        <p className="truncate text-[10px] leading-tight opacity-80">
          {event.subtitle}
        </p>
      ) : null}
      {event.conflict ? (
        <span className="mt-1 inline-flex w-fit items-center gap-1 rounded bg-danger/15 px-1.5 py-0.5 text-[9px] font-semibold text-danger">
          <TriangleAlert className="h-2.5 w-2.5" />
          Conflict Alert!
        </span>
      ) : event.room ? (
        <p className="mt-0.5 flex items-center gap-1 truncate text-[10px] opacity-70">
          <MapPin className="h-2.5 w-2.5 shrink-0" />
          {event.room}
        </p>
      ) : null}
    </div>
  )
}

export function WeeklyTimetable() {
  const todayDow = "Monday" // demo "today" marker per design

  return (
    <div className="fos-card overflow-hidden rounded-2xl border border-border bg-card">
      <div className="overflow-x-auto">
        <div className="min-w-[760px]">
          {/* Hour header */}
          <div className="flex border-b border-border">
            <div className="w-20 shrink-0" />
            <div className="relative flex-1">
              <div className="flex">
                {HOURS.map((h) => (
                  <div
                    key={h}
                    className="flex-1 py-2.5 text-center text-[11px] font-medium text-muted-foreground"
                  >
                    {h <= 11 ? `${h} AM` : h === 12 ? "12 PM" : `${h - 12} PM`}
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Day rows */}
          {WEEK_DAYS.map((day) => {
            const events = WEEK_EVENTS.filter((e) => e.day === day.dow)
            const isToday = day.dow === todayDow
            return (
              <div
                key={day.dow}
                className="flex border-b border-border last:border-b-0"
              >
                <div className="flex w-20 shrink-0 flex-col items-center justify-center gap-0.5 border-r border-border py-3">
                  <span
                    className={cn(
                      "text-sm font-semibold",
                      isToday ? "text-primary" : "text-foreground",
                    )}
                  >
                    {day.short}
                  </span>
                  {isToday ? (
                    <span className="rounded bg-primary/10 px-1.5 py-0.5 text-[9px] font-semibold text-primary">
                      Today
                    </span>
                  ) : (
                    <span className="text-[10px] text-muted-foreground">
                      {day.date}
                    </span>
                  )}
                </div>

                <div className="relative h-20 flex-1">
                  {/* hour gridlines */}
                  <div className="absolute inset-0 flex">
                    {HOURS.map((h) => (
                      <div
                        key={h}
                        className="flex-1 border-r border-border/50 last:border-r-0"
                      />
                    ))}
                  </div>
                  {events.map((e) => (
                    <EventBlock key={e.id} event={e} />
                  ))}
                  {/* now line on today */}
                  {isToday && (
                    <div
                      className="absolute top-0 bottom-0 w-px bg-danger"
                      style={{ left: `${left("10:30")}%` }}
                    >
                      <span className="absolute -top-1 -left-1 h-2 w-2 rounded-full bg-danger" />
                    </div>
                  )}
                </div>
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}
