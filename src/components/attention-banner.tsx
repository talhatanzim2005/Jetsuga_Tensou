"use client"

import { ArrowRight, CheckCircle2, TriangleAlert } from "lucide-react"
import { PRIMARY_CONFLICT } from "@/lib/data"
import { formatDate, to12h } from "@/lib/utils"

export function AttentionBanner({
  resolved,
  onReviewConflict,
}: {
  resolved: boolean
  onReviewConflict: () => void
}) {
  const c = PRIMARY_CONFLICT
  if (!c) return null

  if (resolved) {
    return (
      <div className="fos-fade-up flex items-center gap-4 rounded-xl border border-success/30 bg-success/10 p-5">
        <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-success/20 text-success">
          <CheckCircle2 className="h-5 w-5" />
        </div>
        <div className="min-w-0">
          <p className="text-sm font-semibold text-foreground">
            Conflict resolved — you&apos;re all set.
          </p>
          <p className="mt-0.5 text-sm text-muted-foreground">
            The Department Curriculum Review was moved to 12:15 PM, clear of your
            rescheduled CSE 2201 exam.
          </p>
        </div>
      </div>
    )
  }

  return (
    <div className="fos-fade-up relative overflow-hidden rounded-xl border border-danger/30 bg-danger/10 p-5">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center">
        <div className="fos-pulse flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-danger/20 text-danger">
          <TriangleAlert className="h-5 w-5" />
        </div>
        <div className="min-w-0 flex-1">
          <p className="text-sm font-semibold text-foreground">
            Your schedule needs attention
          </p>
          <p className="mt-0.5 text-sm text-muted-foreground">
            Your{" "}
            <span className="font-medium text-foreground">CSE 2201</span>{" "}
            examination was moved to{" "}
            <span className="font-medium text-foreground">
              {to12h(c.a.start_time)} on {formatDate(c.date)}
            </span>
            . This now conflicts with your{" "}
            <span className="font-medium text-foreground">
              {c.b.title.toLowerCase()}
            </span>{" "}
            by {c.overlapMinutes} minutes.
          </p>
        </div>
        <button
          type="button"
          onClick={onReviewConflict}
          className="inline-flex shrink-0 items-center gap-2 rounded-lg bg-danger px-4 py-2.5 text-sm font-semibold text-danger-foreground transition-transform hover:scale-[1.02] active:scale-[0.99]"
        >
          Review conflict
          <ArrowRight className="h-4 w-4" />
        </button>
      </div>
    </div>
  )
}
