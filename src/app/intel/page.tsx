"use client"

import { useState } from "react"
import {
  CheckCircle2,
  Filter,
  RefreshCw,
  Sparkles,
} from "lucide-react"
import { AppShell } from "@/components/app-shell"
import { DEPT_CIRCULARS, NOTICES } from "@/lib/data"
import type { Notice } from "@/lib/types"
import { useConflict } from "@/lib/use-conflict"
import { cn } from "@/lib/utils"

const FILTERS = [
  "All Updates",
  "Action Required",
  "Academics",
  "Examinations",
  "HR & Admin",
]

const priorityMeta: Record<
  string,
  { label: string; badge: string; bar: string; panel: string }
> = {
  high: {
    label: "HIGH PRIORITY",
    badge: "bg-danger/10 text-danger",
    bar: "bg-danger",
    panel: "border-danger/25 bg-danger/5",
  },
  medium: {
    label: "RELEVANT",
    badge: "bg-warning/10 text-warning",
    bar: "bg-warning",
    panel: "border-warning/25 bg-warning/5",
  },
  low: {
    label: "GENERAL INFO",
    badge: "bg-muted text-muted-foreground",
    bar: "bg-muted-foreground/40",
    panel: "border-border bg-muted/40",
  },
}

function matchesFilter(n: Notice, filter: string): boolean {
  if (filter === "All Updates") return true
  if (filter === "Action Required") return n.priority === "high"
  if (filter === "Academics") return n.category === "Academic"
  if (filter === "Examinations") return n.category === "Examination"
  if (filter === "HR & Admin")
    return ["General", "Facilities", "HR"].includes(n.category)
  return true
}

function NoticeCard({
  notice,
  resolved,
}: {
  notice: Notice
  resolved: boolean
}) {
  const meta = priorityMeta[notice.priority] ?? priorityMeta.low
  const isConflict = notice.id === "ann-003"
  const showResolved = isConflict && resolved

  return (
    <article className="fos-card relative overflow-hidden rounded-2xl border border-border bg-card">
      <span className={cn("absolute inset-y-0 left-0 w-1", meta.bar)} />
      <div className="flex flex-col gap-5 p-5 pl-6 lg:flex-row">
        {/* Left: notice content */}
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-2">
            <span
              className={cn(
                "rounded px-2 py-0.5 text-[10px] font-bold tracking-wide",
                meta.badge,
              )}
            >
              {showResolved ? "RESOLVED" : meta.label}
            </span>
            <span className="text-xs text-muted-foreground">
              {notice.posted_by} • {notice.ago ?? notice.date}
            </span>
          </div>
          <h3 className="mt-2.5 text-base font-bold tracking-tight">
            {notice.title}
          </h3>
          <p className="mt-1.5 text-sm leading-relaxed text-muted-foreground">
            {notice.body}
          </p>
          {notice.link ? (
            <button
              type="button"
              className="mt-3 text-xs font-medium text-primary hover:underline"
            >
              {notice.link}
            </button>
          ) : null}
        </div>

        {/* Right: FacultyOS analysis */}
        {notice.analysis ? (
          <aside
            className={cn(
              "w-full shrink-0 self-start rounded-xl border p-4 lg:w-72",
              showResolved ? "border-success/25 bg-success/5" : meta.panel,
            )}
          >
            <p className="flex items-center gap-1.5 text-xs font-semibold text-foreground">
              <Sparkles className="h-3.5 w-3.5 text-primary" />
              FacultyOS Analysis
            </p>
            <p className="mt-2 text-xs leading-relaxed text-muted-foreground">
              {notice.analysis}
            </p>

            {showResolved ? (
              <p className="mt-3 flex items-center gap-1.5 rounded-lg bg-success/10 px-3 py-2 text-xs font-medium text-success">
                <CheckCircle2 className="h-3.5 w-3.5 shrink-0" />
                Conflict resolved — no overlap remains.
              </p>
            ) : notice.impact ? (
              <p className="mt-3 rounded-lg bg-danger/10 px-3 py-2 text-xs font-medium leading-relaxed text-danger">
                {notice.impact}
              </p>
            ) : null}

            {notice.actionLabel && !showResolved ? (
              <p className="mt-3 text-[11px] font-medium text-muted-foreground">
                {notice.actionLabel} — see Conflicts &amp; Alerts for details.
              </p>
            ) : null}
          </aside>
        ) : null}
      </div>
    </article>
  )
}

function Intel() {
  const { resolved } = useConflict()
  const [filter, setFilter] = useState("All Updates")

  const relevant = NOTICES.filter((n) => n.relevant)
  const visible = relevant.filter((n) => matchesFilter(n, filter))
  const actionCount = relevant.filter((n) => n.priority === "high").length

  return (
    <div className="space-y-5">
      {/* Header */}
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <p className="text-xs font-medium uppercase tracking-wider text-muted-foreground">
            AUST Intel
          </p>
          <h1 className="mt-0.5 text-2xl font-bold tracking-tight">
            AUST Intelligence
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">
            University notices automatically analyzed and mapped to your
            schedule.
          </p>
        </div>
        <div className="flex items-center gap-2">
          <button
            type="button"
            className="flex items-center gap-1.5 rounded-lg border border-border bg-card px-3.5 py-2 text-sm font-medium transition-colors hover:bg-muted"
          >
            <Filter className="h-4 w-4" />
            Filter
          </button>
          <button
            type="button"
            className="flex items-center gap-1.5 rounded-lg border border-border bg-card px-3.5 py-2 text-sm font-medium transition-colors hover:bg-muted"
          >
            <RefreshCw className="h-4 w-4" />
            Refresh Sync
          </button>
        </div>
      </div>

      {/* Filter pills */}
      <div className="flex flex-wrap items-center gap-2">
        {FILTERS.map((f) => {
          const active = filter === f
          const count =
            f === "All Updates"
              ? relevant.length
              : f === "Action Required"
                ? actionCount
                : null
          return (
            <button
              key={f}
              type="button"
              onClick={() => setFilter(f)}
              className={cn(
                "flex items-center gap-1.5 rounded-full px-3.5 py-1.5 text-xs font-semibold transition-colors",
                active
                  ? "bg-foreground text-background"
                  : "border border-border bg-card text-muted-foreground hover:text-foreground",
              )}
            >
              {f === "Action Required" && (
                <span className="h-1.5 w-1.5 rounded-full bg-danger" />
              )}
              {f}
              {count !== null && (
                <span
                  className={cn(
                    "rounded-full px-1.5 text-[10px]",
                    active ? "bg-background/20" : "bg-muted",
                  )}
                >
                  {count}
                </span>
              )}
            </button>
          )
        })}
      </div>

      <div className="grid grid-cols-1 items-start gap-6 xl:grid-cols-3">
        {/* Notices */}
        <div className="space-y-4 xl:col-span-2">
          {visible.map((n) => (
            <NoticeCard key={n.id} notice={n} resolved={resolved} />
          ))}
          {visible.length === 0 && (
            <div className="fos-card rounded-2xl border border-border bg-card p-10 text-center text-sm text-muted-foreground">
              No updates in this category right now.
            </div>
          )}
        </div>

        {/* Right rail */}
        <div className="space-y-4">
          <div className="fos-card rounded-2xl border border-border bg-card p-5">
            <h2 className="text-xs font-bold uppercase tracking-wider text-foreground">
              Processing Status
            </h2>
            <div className="mt-4">
              <div className="flex items-center justify-between text-xs">
                <span className="text-muted-foreground">
                  Sync with AUST Board
                </span>
                <span className="font-semibold text-success">Up to date</span>
              </div>
              <div className="mt-2 h-1.5 overflow-hidden rounded-full bg-muted">
                <div className="h-full w-full rounded-full bg-success" />
              </div>
              <p className="mt-1.5 text-right text-[10px] text-muted-foreground">
                Last checked: 2 mins ago
              </p>
            </div>
            <div className="mt-4 space-y-3 border-t border-border pt-4">
              <div className="flex items-center justify-between text-sm">
                <span className="text-muted-foreground">
                  Total Analyzed (This Month)
                </span>
                <span className="font-bold">42</span>
              </div>
              <div className="flex items-center justify-between text-sm">
                <span className="text-muted-foreground">Relevant to you</span>
                <span className="font-bold text-success">
                  {relevant.length}
                </span>
              </div>
            </div>
          </div>

          <div className="fos-card rounded-2xl border border-border bg-card p-5">
            <div className="flex items-center justify-between">
              <h2 className="text-sm font-semibold">Raw Dept. Circulars</h2>
              <button
                type="button"
                className="text-xs font-medium text-primary hover:underline"
              >
                View All
              </button>
            </div>
            <div className="mt-3 divide-y divide-border">
              {DEPT_CIRCULARS.map((c) => (
                <div key={c.id} className="py-3 first:pt-0 last:pb-0">
                  <p className="text-sm font-medium leading-snug">{c.title}</p>
                  <p className="mt-0.5 text-xs text-muted-foreground">
                    {c.date} • {c.by}
                  </p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default function IntelPage() {
  return (
    <AppShell>
      <Intel />
    </AppShell>
  )
}
