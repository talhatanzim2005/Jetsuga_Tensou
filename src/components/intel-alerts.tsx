import { CheckCircle2, Sparkles } from "lucide-react"
import { Badge, Panel } from "@/components/primitives"
import { PRIMARY_CONFLICT } from "@/lib/data"

function CategoryBadge({
  tone,
  label,
}: {
  tone: "danger" | "warning" | "info" | "success"
  label: string
}) {
  return (
    <Badge tone={tone}>
      <span className="h-1.5 w-1.5 rounded-full bg-current" />
      {label}
    </Badge>
  )
}

export function IntelAlerts({
  resolved,
  onReviewConflict,
}: {
  resolved: boolean
  onReviewConflict: () => void
}) {
  return (
    <Panel>
      <div className="mb-2 flex items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <Sparkles className="h-4 w-4 text-primary" />
          <h2 className="text-base font-semibold tracking-tight">
            AUST Intelligence &amp; Personal Alerts
          </h2>
        </div>
        <button
          type="button"
          className="text-sm font-medium text-primary hover:underline"
        >
          View All
        </button>
      </div>

      <div className="divide-y divide-border">
        {/* Conflict alert */}
        <div className="flex gap-4 py-4">
          <div className="min-w-0 flex-1">
            <CategoryBadge
              tone={resolved ? "success" : "danger"}
              label={resolved ? "Resolved" : "Conflict"}
            />
            <h3 className="mt-2 text-sm font-semibold">
              Schedule Overlap Detected
            </h3>
            <p className="mt-1 text-sm leading-relaxed text-muted-foreground">
              Your CSE 2201 Midterm (11:30 AM, Sep 20) now overlaps with a
              scheduled {PRIMARY_CONFLICT.b.title}.
            </p>
            {resolved ? (
              <p className="mt-3 flex items-center gap-1.5 text-sm font-medium text-success">
                <CheckCircle2 className="h-4 w-4" />
                Curriculum Review moved to 2:00 PM — no overlap remains.
              </p>
            ) : (
              <div className="mt-3 flex flex-wrap gap-2">
                <button
                  type="button"
                  onClick={onReviewConflict}
                  className="rounded-lg border border-border bg-card px-3.5 py-2 text-xs font-semibold transition-colors hover:border-primary/50 hover:text-primary"
                >
                  View Impact
                </button>
                <button
                  type="button"
                  onClick={onReviewConflict}
                  className="rounded-lg bg-primary px-3.5 py-2 text-xs font-semibold text-primary-foreground shadow-sm transition-transform hover:scale-[1.02] active:scale-[0.99]"
                >
                  Reschedule Meeting
                </button>
              </div>
            )}
          </div>
          {!resolved && (
            <aside className="hidden w-52 shrink-0 self-start rounded-xl bg-accent p-3.5 sm:block">
              <p className="flex items-center gap-1.5 text-xs font-semibold text-accent-foreground">
                <Sparkles className="h-3.5 w-3.5" />
                AI Analysis
              </p>
              <p className="mt-2 text-xs leading-relaxed text-muted-foreground">
                Notice from Exam Controller changes midterm slot, directly
                conflicting with Dept calendar.
              </p>
            </aside>
          )}
        </div>

        {/* Academic alert */}
        <div className="py-4">
          <CategoryBadge tone="warning" label="Academic" />
          <h3 className="mt-2 text-sm font-semibold">
            Revised AUST Academic Calendar
          </h3>
          <p className="mt-1 text-sm leading-relaxed text-muted-foreground">
            Fall semester dates have been updated. This affects 2 of your
            planned assignment deadlines.
          </p>
          <button
            type="button"
            className="mt-3 rounded-lg border border-border bg-card px-3.5 py-2 text-xs font-semibold transition-colors hover:border-primary/50 hover:text-primary"
          >
            Review Changes
          </button>
        </div>

        {/* General alert */}
        <div className="py-4">
          <CategoryBadge tone="info" label="General" />
          <h3 className="mt-2 text-sm font-semibold">
            Research Grant Applications Open
          </h3>
          <p className="mt-1 text-sm leading-relaxed text-muted-foreground">
            University grants for Q4 are now accepting submissions. No direct
            action required for your current schedule.
          </p>
        </div>
      </div>
    </Panel>
  )
}
