"use client"

import { AppShell } from "@/components/app-shell"
import { AttentionBanner } from "@/components/attention-banner"
import { OverviewCards } from "@/components/overview-cards"
import { ProjectAnalytics } from "@/components/project-analytics"
import { ProjectProgress } from "@/components/project-progress"
import { RemindersCard } from "@/components/reminders-card"
import { useConflict } from "@/lib/use-conflict"

function Dashboard() {
  const { resolved } = useConflict()

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">Dashboard</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Good morning, Dr. Razi — here&apos;s what matters in your academic
          day.
        </p>
      </div>

      <AttentionBanner resolved={resolved} />

      <OverviewCards resolved={resolved} />

      <div className="grid grid-cols-1 items-stretch gap-6 lg:grid-cols-3">
        <div className="lg:col-span-2">
          <ProjectAnalytics />
        </div>
        <div className="flex flex-col gap-6">
          <RemindersCard />
          <ProjectProgress />
        </div>
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
