import type { ReactNode } from "react"
import { cn } from "@/lib/utils"

export function Panel({
  className,
  children,
}: {
  className?: string
  children: ReactNode
}) {
  return (
    <section
      className={cn(
        "fos-card rounded-2xl border border-border bg-card p-5",
        className,
      )}
    >
      {children}
    </section>
  )
}

export function PanelHeader({
  title,
  icon,
  action,
}: {
  title: string
  icon?: ReactNode
  action?: ReactNode
}) {
  return (
    <div className="mb-4 flex items-center justify-between gap-3">
      <div className="flex items-center gap-2">
        {icon ? <span className="text-primary">{icon}</span> : null}
        <h2 className="text-base font-semibold tracking-tight text-foreground">
          {title}
        </h2>
      </div>
      {action}
    </div>
  )
}

type BadgeTone =
  | "info"
  | "warning"
  | "danger"
  | "success"
  | "neutral"
  | "primary"

const toneClasses: Record<BadgeTone, string> = {
  info: "bg-accent text-accent-foreground border-transparent",
  primary: "bg-primary text-primary-foreground border-transparent",
  warning: "bg-warning/10 text-warning border-warning/25",
  danger: "bg-danger/10 text-danger border-danger/25",
  success: "bg-success/10 text-success border-success/25",
  neutral: "bg-muted text-muted-foreground border-border",
}

export function Badge({
  children,
  tone = "neutral",
  className,
}: {
  children: ReactNode
  tone?: BadgeTone
  className?: string
}) {
  return (
    <span
      className={cn(
        "inline-flex items-center gap-1 rounded-full border px-2.5 py-0.5 text-xs font-medium",
        toneClasses[tone],
        className,
      )}
    >
      {children}
    </span>
  )
}

export function CourseTag({ code }: { code: string }) {
  return (
    <span className="rounded-md bg-accent px-1.5 py-0.5 font-mono text-[11px] font-semibold text-accent-foreground">
      {code}
    </span>
  )
}
