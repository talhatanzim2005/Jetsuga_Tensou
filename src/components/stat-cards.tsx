import {
  CalendarClock,
  ClipboardList,
  GraduationCap,
  Megaphone,
} from "lucide-react"
import {
  DEADLINES,
  DEMO_TODAY_DOW,
  EXAMS,
  NOTICES,
  facultyClassesFor,
} from "@/lib/data"

export function StatCards() {
  const stats = [
    {
      label: "Today's Classes",
      value: facultyClassesFor(DEMO_TODAY_DOW).length,
      hint: "Sunday",
      icon: GraduationCap,
      tone: "text-primary",
    },
    {
      label: "Upcoming Exams",
      value: EXAMS.length,
      hint: "next 3 weeks",
      icon: CalendarClock,
      tone: "text-warning",
    },
    {
      label: "Pending Deadlines",
      value: DEADLINES.length,
      hint: "action needed",
      icon: ClipboardList,
      tone: "text-foreground",
    },
    {
      label: "Relevant Notices",
      value: NOTICES.filter((n) => n.relevant).length,
      hint: `of ${NOTICES.length} published`,
      icon: Megaphone,
      tone: "text-primary",
    },
  ]

  return (
    <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
      {stats.map((s) => (
        <div
          key={s.label}
          className="rounded-xl border border-border bg-card p-4"
        >
          <div className="mb-3 flex items-center justify-between">
            <span className="text-xs font-medium text-muted-foreground">
              {s.label}
            </span>
            <s.icon className={`h-4 w-4 ${s.tone}`} />
          </div>
          <div className="flex items-baseline gap-2">
            <span className="font-mono text-3xl font-semibold tracking-tight">
              {s.value}
            </span>
            <span className="text-xs text-muted-foreground">{s.hint}</span>
          </div>
        </div>
      ))}
    </div>
  )
}
