"use client"

import { AppShell, useConflictFlow } from "@/components/app-shell"
import { AttentionBanner } from "@/components/attention-banner"
import { IntelAlerts } from "@/components/intel-alerts"
import { OverviewCards } from "@/components/overview-cards"
import { QuickTasks } from "@/components/quick-tasks"
import { useConflict } from "@/lib/use-conflict"

function Dashboard() {
  const { resolved } = useConflict()
  const openFlow = useConflictFlow()

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">Dashboard</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Good morning, Dr. Razi — here&apos;s what matters in your academic
          day.
        </p>
      </div>

      <AttentionBanner resolved={resolved} onReviewConflict={openFlow} />

      <OverviewCards resolved={resolved} onReviewConflict={openFlow} />

      <div
        id="conflicts"
        className="grid scroll-mt-24 grid-cols-1 items-start gap-6 lg:grid-cols-3"
      >
        <div className="lg:col-span-2">
          <IntelAlerts resolved={resolved} onReviewConflict={openFlow} />
        </div>
        <QuickTasks />
      </div>
    </div>
  )
}

export default function Page() {
  return (
    <AppShell>
      <Dashboard />
    </AppShell>
  )
}
