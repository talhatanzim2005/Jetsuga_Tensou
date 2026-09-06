"use client"

import { ArrowRight, EyeOff, Megaphone, Sparkles } from "lucide-react"
import { Badge, Panel, PanelHeader } from "@/components/primitives"
import { NOTICES } from "@/lib/data"
import { formatDate } from "@/lib/utils"

export function NoticesPanel({
  onReviewConflict,
}: {
  onReviewConflict: () => void
}) {
  return (
    <Panel>
      <PanelHeader
        title="Notices"
        icon={<Megaphone className="h-4 w-4" />}
        action={
          <span className="inline-flex items-center gap-1 text-xs text-muted-foreground">
            <Sparkles className="h-3.5 w-3.5 text-primary" /> AI-filtered
          </span>
        }
      />
      <ul className="space-y-3">
        {NOTICES.map((n) => {
          const drivesConflict = n.id === "ann-003"
          return (
            <li
              key={n.id}
              className={`rounded-xl border p-3.5 ${
                n.relevant
                  ? "border-border bg-muted/40"
                  : "border-dashed border-border bg-transparent opacity-60"
              }`}
            >
              <div className="mb-1.5 flex items-center justify-between gap-2">
                <div className="flex items-center gap-2">
                  {n.priority === "high" && n.relevant ? (
                    <Badge tone="danger">Important</Badge>
                  ) : (
                    <Badge tone="neutral">{n.category}</Badge>
                  )}
                  {!n.relevant ? (
                    <span className="inline-flex items-center gap-1 text-[11px] text-muted-foreground">
                      <EyeOff className="h-3 w-3" /> Not relevant to you
                    </span>
                  ) : null}
                </div>
                <span className="shrink-0 font-mono text-[11px] text-muted-foreground">
                  {formatDate(n.date)}
                </span>
              </div>
              <h3 className="text-sm font-medium leading-snug">{n.title}</h3>
              <p className="mt-1 line-clamp-2 text-xs leading-relaxed text-muted-foreground">
                {n.body}
              </p>
              {drivesConflict ? (
                <button
                  type="button"
                  onClick={onReviewConflict}
                  className="mt-2.5 inline-flex items-center gap-1 text-xs font-medium text-primary transition-colors hover:underline"
                >
                  See how this affects you
                  <ArrowRight className="h-3.5 w-3.5" />
                </button>
              ) : null}
            </li>
          )
        })}
      </ul>
    </Panel>
  )
}
