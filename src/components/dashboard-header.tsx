"use client"

import { Bell, GraduationCap, Mail, Search } from "lucide-react"
import { FACULTY } from "@/lib/data"

export function DashboardHeader() {
  return (
    <header className="sticky top-0 z-20 border-b border-border bg-background/85 backdrop-blur">
      <div className="flex items-center gap-4 px-5 py-3.5 md:px-8">
        <div className="flex items-center gap-2.5 lg:hidden">
          <div className="flex h-8 w-8 items-center justify-center rounded-full bg-primary text-primary-foreground">
            <GraduationCap className="h-4 w-4" />
          </div>
          <span className="text-sm font-bold">FacultyOS</span>
        </div>

        <div className="relative hidden w-full max-w-md sm:block">
          <Search className="pointer-events-none absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <input
            type="text"
            placeholder="Search classes, exams, notices…"
            className="h-10 w-full rounded-full border border-border bg-card pl-10 pr-14 text-sm text-foreground shadow-sm outline-none placeholder:text-muted-foreground focus:border-ring focus:ring-2 focus:ring-ring/20"
          />
          <kbd className="pointer-events-none absolute right-3.5 top-1/2 -translate-y-1/2 rounded-md border border-border bg-muted px-1.5 py-0.5 font-mono text-[10px] font-medium text-muted-foreground">
            ⌘F
          </kbd>
        </div>

        <div className="ml-auto flex items-center gap-2.5">
          <button
            type="button"
            aria-label="Messages"
            className="flex h-10 w-10 items-center justify-center rounded-full text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
          >
            <Mail className="h-[18px] w-[18px]" />
          </button>

          <button
            type="button"
            aria-label="Notifications"
            className="relative flex h-10 w-10 items-center justify-center rounded-full text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
          >
            <Bell className="h-[18px] w-[18px]" />
            <span className="absolute right-2 top-2 h-2 w-2 rounded-full bg-danger ring-2 ring-background" />
          </button>

          <div className="mx-1 hidden h-6 w-px bg-border sm:block" />

          <div className="flex items-center gap-2.5">
            <div className="flex h-10 w-10 items-center justify-center rounded-full bg-primary font-mono text-xs font-semibold text-primary-foreground">
              {FACULTY.initials}
            </div>
            <div className="hidden leading-tight md:block">
              <p className="text-sm font-semibold">{FACULTY.name}</p>
              <p className="text-xs text-muted-foreground">{FACULTY.email}</p>
            </div>
          </div>
        </div>
      </div>
    </header>
  )
}
