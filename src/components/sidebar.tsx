"use client"

import Link from "next/link"
import { usePathname } from "next/navigation"
import {
  CalendarDays,
  GraduationCap,
  LayoutDashboard,
  Megaphone,
  TriangleAlert,
} from "lucide-react"
import { cn } from "@/lib/utils"

const NAV = [
  { label: "Dashboard", icon: LayoutDashboard, href: "/" },
  { label: "My Routine", icon: CalendarDays, href: "/routine" },
  { label: "AUST Intel", icon: Megaphone, href: "/intel" },
  { label: "Conflicts & Alerts", icon: TriangleAlert, href: "/conflicts" },
]

export function Sidebar({ conflicts = 1 }: { conflicts?: number }) {
  const pathname = usePathname()

  return (
    <aside className="sticky top-0 hidden h-screen w-64 shrink-0 flex-col border-r border-border bg-card lg:flex">
      <Link href="/" className="flex items-center gap-2.5 px-5 pb-6 pt-6">
        <div className="flex h-9 w-9 items-center justify-center rounded-full bg-primary text-primary-foreground">
          <GraduationCap className="h-5 w-5" />
        </div>
        <p className="text-base font-bold tracking-tight">FacultyOS</p>
      </Link>

      <p className="px-6 pb-2 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
        Menu
      </p>
      <nav className="space-y-1 px-3">
        {NAV.map((item) => {
          const active =
            item.href === "/"
              ? pathname === "/"
              : pathname.startsWith(item.href)
          const badge = item.label.startsWith("Conflicts") ? conflicts : 0
          return (
            <Link
              key={item.label}
              href={item.href}
              className={cn(
                "flex w-full items-center gap-3 rounded-xl px-3.5 py-2.5 text-sm font-medium transition-colors",
                active
                  ? "bg-primary text-primary-foreground shadow-md shadow-primary/25"
                  : "text-muted-foreground hover:bg-muted hover:text-foreground",
              )}
            >
              <item.icon className="h-[18px] w-[18px] shrink-0" />
              <span className="flex-1 text-left">{item.label}</span>
              {badge > 0 ? (
                <span
                  className={cn(
                    "flex h-5 min-w-5 items-center justify-center rounded-full px-1.5 text-[11px] font-semibold",
                    active
                      ? "bg-primary-foreground/20 text-primary-foreground"
                      : "bg-danger/10 text-danger",
                  )}
                >
                  {badge}
                </span>
              ) : null}
            </Link>
          )
        })}
      </nav>
    </aside>
  )
}
