import { Clock, MapPin, Users } from "lucide-react"
import { Badge, CourseTag, Panel, PanelHeader } from "@/components/primitives"
import { DEMO_TODAY_DOW, facultyClassesFor } from "@/lib/data"
import { durationLabel, to12h, toMinutes } from "@/lib/utils"

export function TodaySchedule() {
  const classes = facultyClassesFor(DEMO_TODAY_DOW)

  return (
    <Panel>
      <PanelHeader
        title="Today's Schedule"
        icon={<Clock className="h-4 w-4" />}
        action={<Badge tone="neutral">{DEMO_TODAY_DOW}</Badge>}
      />

      {classes.length === 0 ? (
        <p className="py-8 text-center text-sm text-muted-foreground">
          No classes scheduled today.
        </p>
      ) : (
        <ol className="space-y-3">
          {classes.map((c) => {
            const mins = toMinutes(c.end_time) - toMinutes(c.start_time)
            return (
              <li
                key={c.id}
                className="flex gap-4 rounded-xl border border-border bg-muted/40 p-3.5"
              >
                <div className="flex w-16 shrink-0 flex-col items-center justify-center border-r border-border pr-3 text-center">
                  <span className="font-mono text-sm font-semibold">
                    {to12h(c.start_time).replace(" ", "")}
                  </span>
                  <span className="mt-0.5 text-[10px] uppercase tracking-wide text-muted-foreground">
                    {durationLabel(mins)}
                  </span>
                </div>
                <div className="min-w-0 flex-1">
                  <div className="mb-1 flex flex-wrap items-center gap-2">
                    <CourseTag code={c.course} />
                    <h3 className="truncate text-sm font-medium">{c.title}</h3>
                  </div>
                  <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground">
                    <span className="inline-flex items-center gap-1">
                      <MapPin className="h-3.5 w-3.5" /> Room {c.room}
                    </span>
                    <span className="inline-flex items-center gap-1">
                      <Users className="h-3.5 w-3.5" /> Section {c.section}
                    </span>
                    <span className="inline-flex items-center gap-1">
                      <Clock className="h-3.5 w-3.5" />
                      {to12h(c.start_time)} – {to12h(c.end_time)}
                    </span>
                  </div>
                </div>
              </li>
            )
          })}
        </ol>
      )}
    </Panel>
  )
}
