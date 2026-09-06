"use client"

import { useState } from "react"
import { AttentionBanner } from "@/components/attention-banner"
import { ConflictFlow } from "@/components/conflict-flow"
import { DashboardHeader } from "@/components/dashboard-header"
import { FloatingAssistant } from "@/components/floating-assistant"
import { IntelAlerts } from "@/components/intel-alerts"
import { OverviewCards } from "@/components/overview-cards"
import { QuickTasks } from "@/components/quick-tasks"
import { Sidebar } from "@/components/sidebar"

export default function Page() {
  const [flowOpen, setFlowOpen] = useState(false)
  const [resolved, setResolved] = useState(false)

  const openFlow = () => setFlowOpen(true)

  return (
    <div className="flex min-h-screen bg-background text-foreground">
      <Sidebar conflicts={resolved ? 0 : 1} />

      <div className="flex min-w-0 flex-1 flex-col">
        <DashboardHeader />

        <main className="mx-auto w-full max-w-[1400px] flex-1 space-y-6 px-5 py-6 md:px-8">
          <div>
            <h1 className="text-2xl font-bold tracking-tight">Dashboard</h1>
            <p className="mt-1 text-sm text-muted-foreground">
              Good morning, Dr. Razi — here&apos;s what matters in your academic
              day.
            </p>
          </div>

          <AttentionBanner resolved={resolved} onReviewConflict={openFlow} />

          <OverviewCards resolved={resolved} onReviewConflict={openFlow} />

          <div className="grid grid-cols-1 items-start gap-6 lg:grid-cols-3">
            <div className="lg:col-span-2">
              <IntelAlerts resolved={resolved} onReviewConflict={openFlow} />
            </div>
            <QuickTasks />
          </div>
        </main>
      </div>

      <FloatingAssistant />

      <ConflictFlow
        open={flowOpen}
        onClose={() => setFlowOpen(false)}
        onResolve={() => setResolved(true)}
      />
    </div>
  )
}
