"use client"

import {
  CalendarDays,
  GraduationCap,
  LayoutDashboard,
  Megaphone,
  MessageSquareText,
  Settings,
  TriangleAlert,
} from "lucide-react"
import { cn } from "@/lib/utils"
import { FACULTY } from "@/lib/data"

const nav = [
  { label: "Dashboard", icon: LayoutDashboard, active: true },
  { label: "AI Assistant", icon: MessageSquareText },
  { label: "Schedule", icon: CalendarDays },
  { label: "Notices", icon: Megaphone },
  { label: "Conflicts", icon: TriangleAlert, badge: 1 },
]

export function Sidebar() {
  return (
    <aside className="hidden w-64 shrink-0 flex-col border-r border-border bg-card/40 lg:flex">
      <div className="flex items-center gap-2.5 px-5 py-5">
        <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary text-primary-foreground">
          <GraduationCap className="h-5 w-5" />
        </div>
        <div className="leading-tight">
          <p className="text-sm font-semibold tracking-tight">FacultyOS</p>
          <p className="font-mono text-[10px] uppercase tracking-widest text-muted-foreground">
            AUST · CSE
          </p>
        </div>
      </div>

      <nav className="flex-1 space-y-1 px-3 py-2">
        {nav.map((item) => (
          <button
            key={item.label}
            type="button"
            className={cn(
              "flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors",
              item.active
                ? "bg-primary/12 text-primary"
                : "text-muted-foreground hover:bg-accent hover:text-foreground",
            )}
          >
            <item.icon className="h-4 w-4 shrink-0" />
            <span className="flex-1 text-left">{item.label}</span>
            {item.badge ? (
              <span className="flex h-5 min-w-5 items-center justify-center rounded-full bg-danger px-1.5 text-[11px] font-semibold text-danger-foreground">
                {item.badge}
              </span>
            ) : null}
          </button>
        ))}
      </nav>

      <div className="px-3 py-2">
        <button
          type="button"
          className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"
        >
          <Settings className="h-4 w-4" />
          Settings
        </button>
      </div>

      <div className="m-3 flex items-center gap-3 rounded-lg border border-border bg-background/60 p-3">
        <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-accent font-mono text-xs font-semibold text-accent-foreground">
          {FACULTY.initials}
        </div>
        <div className="min-w-0 leading-tight">
          <p className="truncate text-sm font-medium">{FACULTY.name}</p>
          <p className="truncate text-xs text-muted-foreground">
            {FACULTY.role}
          </p>
        </div>
      </div>
    </aside>
  )
}
