import {
  ArrowUpRight,
  CalendarClock,
  ClipboardList,
  GraduationCap,
  Megaphone,
  TrendingDown,
  TrendingUp,
} from "lucide-react"
import {
  DEADLINES,
  DEMO_TODAY_DOW,
  EXAMS,
  NOTICES,
  facultyClassesFor,
} from "@/lib/data"
import { cn } from "@/lib/utils"

export function StatCards() {
  const stats = [
    {
      label: "Today's Classes",
      value: facultyClassesFor(DEMO_TODAY_DOW).length,
      trend: "+1",
      hint: "vs last Sunday",
      up: true,
      icon: GraduationCap,
    },
    {
      label: "Upcoming Exams",
      value: EXAMS.length,
      trend: "+2",
      hint: "this month",
      up: true,
      icon: CalendarClock,
    },
    {
      label: "Pending Deadlines",
      value: DEADLINES.length,
      trend: "-2",
      hint: "cleared this week",
      up: true,
      icon: ClipboardList,
    },
    {
      label: "Relevant Notices",
      value: NOTICES.filter((n) => n.relevant).length,
      trend: `of ${NOTICES.length}`,
      hint: "published",
      up: null,
      icon: Megaphone,
    },
  ]

  return (
    <div className="grid grid-cols-2 gap-4 xl:grid-cols-4">
      {stats.map((s) => (
        <div
          key={s.label}
          className="fos-card rounded-2xl border border-border bg-card p-4"
        >
          <div className="flex items-start justify-between gap-2">
            <div className="flex min-w-0 items-center gap-2">
              <span className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-accent text-accent-foreground">
                <s.icon className="h-4 w-4" />
              </span>
              <span className="text-[13px] font-medium leading-tight text-muted-foreground">
                {s.label}
              </span>
            </div>
            <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-primary text-primary-foreground">
              <ArrowUpRight className="h-3.5 w-3.5" />
            </span>
          </div>

          <p className="mt-5 text-3xl font-bold tracking-tight">{s.value}</p>

          <p className="mt-3 flex items-center gap-1.5 text-xs">
            {s.up === true ? (
              <TrendingUp className="h-3.5 w-3.5 text-success" />
            ) : s.up === false ? (
              <TrendingDown className="h-3.5 w-3.5 text-danger" />
            ) : null}
            <span
              className={cn(
                "font-medium",
                s.up === true
                  ? "text-success"
                  : s.up === false
                    ? "text-danger"
                    : "text-muted-foreground",
              )}
            >
              {s.trend}
            </span>
            <span className="text-muted-foreground">{s.hint}</span>
          </p>
        </div>
      ))}
    </div>
  )
}
