import Link from "next/link"
import { ArrowUpRight, CheckCircle2, FileText } from "lucide-react"
import { EXAMS, NOTICES, PRIMARY_CONFLICT, todayAgenda } from "@/lib/data"
import { cn } from "@/lib/utils"

function shortDate(date: string) {
  return new Date(`${date}T00:00:00`).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
  })
}

function examKind(title: string) {
  return title.split("— ")[1] ?? "Exam"
}

export function OverviewCards({ resolved }: { resolved: boolean }) {
  const agenda = todayAgenda()
  const unread = NOTICES.filter((n) => n.unread)
  const exams = [...EXAMS].sort((a, b) => a.date.localeCompare(b.date))

  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
      {/* Today's Academic Agenda — solid emerald */}
      <div className="fos-card rounded-2xl bg-primary p-5 text-primary-foreground">
        <div className="flex items-start justify-between gap-2">
          <p className="text-sm font-medium text-primary-foreground/90">
            Today&apos;s Academic Agenda
          </p>
          <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-lg bg-white/15">
            <ArrowUpRight className="h-4 w-4" />
          </span>
        </div>
        <p className="mt-4 flex items-baseline gap-2">
          <span className="text-4xl font-bold tracking-tight">
            {agenda.length}
          </span>
          <span className="text-sm text-primary-foreground/80">
            classes/labs
          </span>
        </p>
        <ul className="mt-4 space-y-2">
          {agenda.map((item) => (
            <li key={item.id} className="flex items-center gap-2 text-xs">
              <span className="h-1.5 w-1.5 shrink-0 rounded-full bg-primary-foreground/70" />
              <span className="shrink-0 font-semibold">{item.time}</span>
              <span
                className="truncate text-primary-foreground/85"
                title={`${item.title}${item.detail ? ` (${item.detail})` : ""}`}
              >
                — {item.title}
                {item.detail ? ` (${item.detail})` : ""}
              </span>
            </li>
          ))}
        </ul>
      </div>

      {/* Unread AUST Intelligence */}
      <div className="fos-card rounded-2xl border border-border bg-card p-5">
        <div className="flex items-start justify-between gap-2">
          <p className="text-sm font-medium text-muted-foreground">
            Unread AUST Intelligence
          </p>
          <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-lg border border-border text-muted-foreground">
            <ArrowUpRight className="h-4 w-4" />
          </span>
        </div>
        <p className="mt-4 flex items-baseline gap-2">
          <span className="text-4xl font-bold tracking-tight">
            {unread.length}
          </span>
          <span className="text-sm text-muted-foreground">notices</span>
        </p>
        <ul className="mt-4 space-y-2">
          {unread.map((n) => (
            <li key={n.id} className="flex items-center gap-2 text-xs">
              <span
                className={cn(
                  "h-1.5 w-1.5 shrink-0 rounded-full",
                  n.priority === "high" ? "bg-danger" : "bg-warning",
                )}
              />
              <span className="truncate font-medium" title={n.title}>
                {n.title}
              </span>
            </li>
          ))}
        </ul>
      </div>

      {/* Upcoming Exams & Duties */}
      <div className="fos-card rounded-2xl border border-border bg-card p-5">
        <div className="flex items-start justify-between gap-2">
          <p className="text-sm font-medium text-muted-foreground">
            Upcoming Exams &amp; Duties
          </p>
          <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-lg border border-border text-muted-foreground">
            <ArrowUpRight className="h-4 w-4" />
          </span>
        </div>
        <p className="mt-4 flex items-baseline gap-2">
          <span className="text-4xl font-bold tracking-tight">
            {exams.length}
          </span>
          <span className="text-sm text-muted-foreground">upcoming</span>
        </p>
        <ul className="mt-4 space-y-2">
          {exams.map((e) => (
            <li key={e.id} className="flex items-center gap-2 text-xs">
              <FileText className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
              <span className="truncate font-medium">
                {examKind(e.title)} ({e.course})
              </span>
              <span className="ml-auto shrink-0 text-muted-foreground">
                {shortDate(e.date)}
              </span>
            </li>
          ))}
        </ul>
      </div>

      {/* Active Schedule Conflicts */}
      {resolved ? (
        <div className="fos-card rounded-2xl border border-success/25 bg-success/5 p-5">
          <div className="flex items-start justify-between gap-2">
            <p className="text-sm font-medium text-success">
              Active Schedule Conflicts
            </p>
            <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-lg bg-success/15 text-success">
              <CheckCircle2 className="h-4 w-4" />
            </span>
          </div>
          <p className="mt-4 flex items-baseline gap-2">
            <span className="text-4xl font-bold tracking-tight text-success">
              0
            </span>
            <span className="text-sm text-success">active conflicts</span>
          </p>
          <p className="mt-4 text-xs leading-relaxed text-muted-foreground">
            Your schedule is clear — no overlaps detected across classes,
            exams, and meetings.
          </p>
        </div>
      ) : (
        <Link
          href="/conflicts"
          className="fos-card block rounded-2xl border border-danger/25 bg-danger/5 p-5 text-left transition-transform hover:scale-[1.01]"
        >
          <div className="flex items-start justify-between gap-2">
            <p className="text-sm font-medium text-danger">
              Active Schedule Conflicts
            </p>
            <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-lg bg-danger/15">
              <span className="h-2 w-2 rounded-full bg-danger" />
            </span>
          </div>
          <p className="mt-4 flex items-baseline gap-2">
            <span className="text-4xl font-bold tracking-tight text-danger">
              1
            </span>
            <span className="text-sm text-danger">conflict detected</span>
          </p>
          <p className="mt-4 text-xs leading-relaxed text-foreground/80">
            Overlap between {PRIMARY_CONFLICT.b.title} &amp; CSE 2201 Midterm
            on {shortDate(PRIMARY_CONFLICT.date)}.
          </p>
        </Link>
      )}
    </div>
  )
}
