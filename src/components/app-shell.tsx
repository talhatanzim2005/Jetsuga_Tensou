"use client"

import { createContext, useContext, useState, type ReactNode } from "react"
import { ConflictFlow } from "@/components/conflict-flow"
import { DashboardHeader } from "@/components/dashboard-header"
import { FloatingAssistant } from "@/components/floating-assistant"
import { Sidebar } from "@/components/sidebar"
import { useConflict } from "@/lib/use-conflict"

const ConflictFlowContext = createContext<() => void>(() => {})

/** Lets any page open the shared conflict-resolution flow. */
export function useConflictFlow() {
  return useContext(ConflictFlowContext)
}

export function AppShell({ children }: { children: ReactNode }) {
  const { resolved, resolve } = useConflict()
  const [flowOpen, setFlowOpen] = useState(false)
  const openFlow = () => setFlowOpen(true)

  return (
    <ConflictFlowContext.Provider value={openFlow}>
      <div className="flex min-h-screen bg-background text-foreground">
        <Sidebar conflicts={resolved ? 0 : 1} />

        <div className="flex min-w-0 flex-1 flex-col">
          <DashboardHeader />
          <main className="mx-auto w-full max-w-[1400px] flex-1 px-5 py-6 md:px-8">
            {children}
          </main>
        </div>

        <FloatingAssistant />

        <ConflictFlow
          open={flowOpen}
          onClose={() => setFlowOpen(false)}
          onResolve={resolve}
        />
      </div>
    </ConflictFlowContext.Provider>
  )
}
