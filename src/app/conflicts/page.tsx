"use client"

import {
  AlertTriangle,
  CalendarDays,
  CheckCircle2,
  Clock,
  MapPin,
  Sparkles,
} from "lucide-react"
import { AppShell } from "@/components/app-shell"
import {
  buildRoutine,
  detectConflicts,
  NOTICES,
  PRIMARY_CONFLICT,
} from "@/lib/data"
import { useConflict } from "@/lib/use-conflict"
import { formatDate, to12h } from "@/lib/utils"

function Conflicts() {
  const { resolved } = useConflict()
  const conflicts = detectConflicts(buildRoutine())
  const notice = NOTICES.find((n) => n.id === "ann-003")

  return (
    <div className="space-y-6">
      <div>
        <p className="text-xs font-medium uppercase tracking-wider text-muted-foreground">
          Conflicts &amp; Alerts
        </p>
        <h1 className="mt-0.5 text-2xl font-bold tracking-tight">
          Schedule Conflicts
        </h1>
        <p className="mt-1 text-sm text-muted-foreground">
          FacultyOS continuously checks your routine against university updates
          and flags anything that overlaps.
        </p>
      </div>

      {conflicts.length === 0 || resolved ? (
        <div className="fos-card flex flex-col items-center rounded-2xl border border-success/25 bg-success/5 p-12 text-center">
          <span className="flex h-12 w-12 items-center justify-center rounded-full bg-success/15 text-success">
            <CheckCircle2 className="h-6 w-6" />
          </span>
          <h2 className="mt-4 text-lg font-semibold">No active conflicts</h2>
          <p className="mt-1 max-w-sm text-sm text-muted-foreground">
            Your schedule is clear. FacultyOS will alert you here the moment a
            university update collides with your routine.
          </p>
        </div>
      ) : (
        <div className="space-y-4">
          {conflicts.map((c) => (
            <article
              key={`${c.a.id}-${c.b.id}`}
              className="fos-card relative overflow-hidden rounded-2xl border border-border bg-card"
            >
              <span className="absolute inset-y-0 left-0 w-1 bg-danger" />
              <div className="p-5 pl-6">
                <div className="flex flex-wrap items-center gap-2">
                  <span className="rounded bg-danger/10 px-2 py-0.5 text-[10px] font-bold tracking-wide text-danger">
                    CONFLICT DETECTED
                  </span>
                  <span className="flex items-center gap-1 text-xs text-muted-foreground">
                    <CalendarDays className="h-3.5 w-3.5" />
                    {formatDate(c.date)}
                  </span>
                </div>

                <h2 className="mt-2.5 text-lg font-bold tracking-tight">
                  {c.a.title} overlaps {c.b.title}
                </h2>
                <p className="mt-1 text-sm text-muted-foreground">
                  These two commitments share a {c.overlapMinutes}-minute
                  overlap on {formatDate(c.date)}.
                </p>

                <div className="mt-4 grid gap-3 sm:grid-cols-2">
                  {[
                    { item: c.a, tone: "danger" as const },
                    { item: c.b, tone: "primary" as const },
                  ].map(({ item, tone }) => (
                    <div
                      key={item.id}
                      className={`rounded-xl border p-4 ${
                        tone === "danger"
                          ? "border-danger/25 bg-danger/5"
                          : "border-primary/25 bg-accent"
                      }`}
                    >
                      <p className="text-[10px] font-bold uppercase tracking-wider text-muted-foreground">
                        {item.kind}
                      </p>
                      <p className="mt-1 text-sm font-semibold">{item.title}</p>
                      {item.subtitle ? (
                        <p className="text-xs text-muted-foreground">
                          {item.subtitle}
                        </p>
                      ) : null}
                      <div className="mt-2.5 space-y-1 text-xs text-muted-foreground">
                        <p className="flex items-center gap-1.5">
                          <Clock className="h-3.5 w-3.5" />
                          {to12h(item.start_time)} – {to12h(item.end_time)}
                        </p>
                        {item.room ? (
                          <p className="flex items-center gap-1.5">
                            <MapPin className="h-3.5 w-3.5" />
                            Room {item.room}
                          </p>
                        ) : null}
                      </div>
                    </div>
                  ))}
                </div>

                <div className="mt-4 flex items-start gap-2 rounded-xl border border-danger/25 bg-danger/5 px-4 py-3">
                  <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0 text-danger" />
                  <p className="text-sm">
                    Overlap window:{" "}
                    <span className="font-semibold text-danger">
                      {to12h(c.overlapStart)} – {to12h(c.overlapEnd)}
                    </span>{" "}
                    ({c.overlapMinutes} minutes)
                  </p>
                </div>

                {notice?.analysis ? (
                  <div className="mt-4 rounded-xl border border-border bg-muted/40 p-4">
                    <p className="flex items-center gap-1.5 text-xs font-semibold">
                      <Sparkles className="h-3.5 w-3.5 text-primary" />
                      FacultyOS Analysis
                    </p>
                    <p className="mt-2 text-xs leading-relaxed text-muted-foreground">
                      {notice.analysis} {notice.impact}
                    </p>
                    <p className="mt-2 text-[11px] text-muted-foreground">
                      Source: {notice.posted_by} • {notice.ago}
                    </p>
                  </div>
                ) : null}
              </div>
            </article>
          ))}
        </div>
      )}
    </div>
  )
}

export default function ConflictsPage() {
  return (
    <AppShell>
      <Conflicts />
    </AppShell>
  )
}
