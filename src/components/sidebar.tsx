"use client"

import {
  CalendarDays,
  GraduationCap,
  LayoutDashboard,
  Megaphone,
  TriangleAlert,
} from "lucide-react"
import { cn } from "@/lib/utils"

function NavItem({
  item,
}: {
  item: {
    label: string
    icon: typeof LayoutDashboard
    active?: boolean
    badge?: number
  }
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
        <span className="flex h-5 min-w-5 items-center justify-center rounded-full bg-danger/10 px-1.5 text-[11px] font-semibold text-danger">
          {item.badge}
        </span>
      ) : null}
    </button>
  )
}

export function Sidebar({ conflicts = 1 }: { conflicts?: number }) {
  const menu = [
    { label: "Dashboard", icon: LayoutDashboard, active: true },
    { label: "Routine", icon: CalendarDays },
    { label: "AUST Intel", icon: Megaphone },
    { label: "Conflicts", icon: TriangleAlert, badge: conflicts },
  ]

  return (
    <aside className="sticky top-0 hidden h-screen w-64 shrink-0 flex-col border-r border-border bg-card lg:flex">
      <div className="flex items-center gap-2.5 px-5 pt-6 pb-6">
        <div className="flex h-9 w-9 items-center justify-center rounded-full bg-primary text-primary-foreground">
          <GraduationCap className="h-5 w-5" />
        </div>
        <p className="text-base font-bold tracking-tight">FacultyOS</p>
      </div>

      <p className="px-6 pb-2 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
        Menu
      </p>
      <nav className="space-y-1 px-3">
        {menu.map((item) => (
          <NavItem key={item.label} item={item} />
        ))}
      </nav>
    </aside>
  )
}
