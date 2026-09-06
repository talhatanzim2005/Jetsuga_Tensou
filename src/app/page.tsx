"use client"

import { useState } from "react"
import { AiAssistant } from "@/components/ai-assistant"
import { AttentionBanner } from "@/components/attention-banner"
import { ConflictFlow } from "@/components/conflict-flow"
import { DashboardHeader } from "@/components/dashboard-header"
import { NoticesPanel } from "@/components/notices-panel"
import { Sidebar } from "@/components/sidebar"
import { StatCards } from "@/components/stat-cards"
import { TodaySchedule } from "@/components/today-schedule"
import { Deadlines, UpcomingExams } from "@/components/upcoming"

export default function Page() {
  const [flowOpen, setFlowOpen] = useState(false)
  const [resolved, setResolved] = useState(false)

  const openFlow = () => setFlowOpen(true)

  return (
    <div className="flex min-h-screen bg-background text-foreground">
      <Sidebar />

      <div className="flex min-w-0 flex-1 flex-col">
        <DashboardHeader />

        <main className="mx-auto w-full max-w-[1400px] flex-1 space-y-6 px-5 py-6 md:px-8">
          <AttentionBanner resolved={resolved} onReviewConflict={openFlow} />

          <StatCards />

          <div className="grid grid-cols-1 items-start gap-6 lg:grid-cols-3">
            <div className="space-y-6 lg:col-span-2">
              <TodaySchedule />
              <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
                <UpcomingExams onReviewConflict={openFlow} />
                <Deadlines />
              </div>
            </div>

            <div className="space-y-6">
              <AiAssistant />
              <NoticesPanel onReviewConflict={openFlow} />
            </div>
          </div>

          <footer className="border-t border-border pt-5 pb-2 text-center">
            <p className="text-sm font-medium">
              Faculty shouldn&apos;t have to manage information. Information
              should work for faculty.
            </p>
            <p className="mt-1 text-xs text-muted-foreground">
              FacultyOS — from scattered information to intelligent academic
              decisions.
            </p>
          </footer>
        </main>
      </div>

      <ConflictFlow
        open={flowOpen}
        onClose={() => setFlowOpen(false)}
        onResolve={() => setResolved(true)}
      />
    </div>
  )
}
