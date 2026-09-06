"use client"

import { Bell, GraduationCap, Search } from "lucide-react"
import { DEMO_DATE, FACULTY } from "@/lib/data"
import { formatDateLong } from "@/lib/utils"

export function DashboardHeader() {
  const hour = 9
  const greeting = hour < 12 ? "Good morning" : hour < 18 ? "Good afternoon" : "Good evening"

  return (
    <header className="sticky top-0 z-20 border-b border-border bg-background/85 backdrop-blur">
      <div className="flex items-center gap-4 px-5 py-4 md:px-8">
        <div className="flex items-center gap-2.5 lg:hidden">
          <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
            <GraduationCap className="h-4 w-4" />
          </div>
          <span className="text-sm font-semibold">FacultyOS</span>
        </div>

        <div className="hidden min-w-0 flex-col md:flex">
          <h1 className="truncate text-base font-semibold tracking-tight">
            {greeting}, {FACULTY.shortName}
          </h1>
          <p className="text-xs text-muted-foreground">
            {formatDateLong(DEMO_DATE)}
          </p>
        </div>

        <div className="ml-auto flex items-center gap-2.5">
          <div className="relative hidden sm:block">
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <input
              type="text"
              placeholder="Ask or search…"
              className="h-9 w-52 rounded-lg border border-input bg-card pl-9 pr-3 text-sm text-foreground outline-none placeholder:text-muted-foreground focus:border-ring focus:ring-2 focus:ring-ring/30"
            />
          </div>

          <button
            type="button"
            aria-label="Notifications"
            className="relative flex h-9 w-9 items-center justify-center rounded-lg border border-border bg-card text-muted-foreground transition-colors hover:text-foreground"
          >
            <Bell className="h-4 w-4" />
            <span className="absolute -right-0.5 -top-0.5 flex h-4 w-4 items-center justify-center rounded-full bg-danger text-[10px] font-semibold text-danger-foreground">
              1
            </span>
          </button>

          <div className="flex h-9 w-9 items-center justify-center rounded-full bg-accent font-mono text-xs font-semibold text-accent-foreground">
            {FACULTY.initials}
          </div>
        </div>
      </div>
    </header>
  )
}
