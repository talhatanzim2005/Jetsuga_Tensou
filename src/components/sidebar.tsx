"use client"

import {
  CalendarDays,
  GraduationCap,
  LayoutDashboard,
  LifeBuoy,
  LogOut,
  Megaphone,
  MessageSquareText,
  Settings,
  TriangleAlert,
} from "lucide-react"
import { cn } from "@/lib/utils"
import { FACULTY } from "@/lib/data"

const menu = [
  { label: "Dashboard", icon: LayoutDashboard, active: true },
  { label: "AI Assistant", icon: MessageSquareText },
  { label: "Schedule", icon: CalendarDays },
  { label: "Notices", icon: Megaphone },
  { label: "Conflicts", icon: TriangleAlert, badge: 1 },
]

const general = [
  { label: "Settings", icon: Settings },
  { label: "Help", icon: LifeBuoy },
  { label: "Logout", icon: LogOut },
]

function NavItem({
  item,
}: {
  item: { label: string; icon: typeof LayoutDashboard; active?: boolean; badge?: number }
}) {
  return (
    <button
      type="button"
      className={cn(
        "flex w-full items-center gap-3 rounded-xl px-3.5 py-2.5 text-sm font-medium transition-colors",
        item.active
          ? "bg-primary text-primary-foreground shadow-md shadow-primary/25"
          : "text-muted-foreground hover:bg-muted hover:text-foreground",
      )}
    >
      <item.icon className="h-[18px] w-[18px] shrink-0" />
      <span className="flex-1 text-left">{item.label}</span>
      {item.badge ? (
        <span
          className={cn(
            "flex h-5 min-w-5 items-center justify-center rounded-full px-1.5 text-[11px] font-semibold",
            item.active
              ? "bg-white/20 text-primary-foreground"
              : "bg-danger/10 text-danger",
          )}
        >
          {item.badge}
        </span>
      ) : null}
    </button>
  )
}

export function Sidebar() {
  return (
    <aside className="hidden w-64 shrink-0 flex-col border-r border-border bg-card lg:flex">
      <div className="flex items-center gap-2.5 px-5 pt-6 pb-5">
        <div className="flex h-9 w-9 items-center justify-center rounded-full bg-primary text-primary-foreground">
          <GraduationCap className="h-5 w-5" />
        </div>
        <div className="leading-tight">
          <p className="text-base font-bold tracking-tight">FacultyOS</p>
          <p className="text-[11px] text-muted-foreground">AUST · CSE</p>
        </div>
      </div>

      <p className="px-6 pb-2 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
        Menu
      </p>
      <nav className="space-y-1 px-3">
        {menu.map((item) => (
          <NavItem key={item.label} item={item} />
        ))}
      </nav>

      <p className="px-6 pt-6 pb-2 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
        General
      </p>
      <nav className="space-y-1 px-3">
        {general.map((item) => (
          <NavItem key={item.label} item={item} />
        ))}
      </nav>

      <div className="mt-auto px-3 pb-4">
        <div className="flex items-center gap-3 rounded-2xl border border-border bg-background p-3">
          <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-primary font-mono text-xs font-semibold text-primary-foreground">
            {FACULTY.initials}
          </div>
          <div className="min-w-0 leading-tight">
            <p className="truncate text-sm font-semibold">{FACULTY.name}</p>
            <p className="truncate text-xs text-muted-foreground">
              {FACULTY.role}
            </p>
          </div>
        </div>
      </div>
    </aside>
  )
}
