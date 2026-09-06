"use client"

import { useState } from "react"
import { Check, Plus } from "lucide-react"
import { Panel } from "@/components/primitives"
import { QUICK_TASKS } from "@/lib/data"
import type { QuickTask } from "@/lib/types"
import { cn } from "@/lib/utils"

export function QuickTasks() {
  const [tasks, setTasks] = useState<QuickTask[]>(QUICK_TASKS)
  const [adding, setAdding] = useState(false)
  const [draft, setDraft] = useState("")

  function toggle(id: string) {
    setTasks((ts) =>
      ts.map((t) => (t.id === id ? { ...t, done: !t.done } : t)),
    )
  }

  function addTask() {
    const title = draft.trim()
    if (!title) return
    setTasks((ts) => [
      { id: `qt-${Date.now()}`, title, done: false },
      ...ts,
    ])
    setDraft("")
    setAdding(false)
  }

  return (
    <Panel>
      <div className="mb-3 flex items-center justify-between gap-3">
        <h2 className="text-base font-semibold tracking-tight">Quick Tasks</h2>
        <button
          type="button"
          onClick={() => setAdding((a) => !a)}
          className="flex items-center gap-1 rounded-lg bg-primary px-2.5 py-1.5 text-xs font-semibold text-primary-foreground shadow-sm transition-transform hover:scale-[1.03] active:scale-[0.98]"
        >
          <Plus className="h-3.5 w-3.5" />
          New
        </button>
      </div>

      {adding ? (
        <form
          onSubmit={(e) => {
            e.preventDefault()
            addTask()
          }}
          className="mb-2"
        >
          <input
            autoFocus
            value={draft}
            onChange={(e) => setDraft(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Escape") setAdding(false)
            }}
            placeholder="Task title — press Enter to add"
            className="h-9 w-full rounded-lg border border-input bg-background px-3 text-sm outline-none placeholder:text-muted-foreground focus:border-ring focus:ring-2 focus:ring-ring/20"
          />
        </form>
      ) : null}

      <ul className="space-y-0.5">
        {tasks.map((t) => (
          <li key={t.id}>
            <button
              type="button"
              onClick={() => toggle(t.id)}
              className="flex w-full items-center gap-3 rounded-lg px-2 py-2 text-left transition-colors hover:bg-muted/60"
            >
              <span
                className={cn(
                  "flex h-[18px] w-[18px] shrink-0 items-center justify-center rounded border transition-colors",
                  t.done
                    ? "border-primary bg-primary text-primary-foreground"
                    : "border-input bg-card",
                )}
              >
                {t.done ? <Check className="h-3 w-3" /> : null}
              </span>
              <span
                className={cn(
                  "text-sm leading-snug",
                  t.done && "text-muted-foreground line-through",
                )}
              >
                {t.title}
              </span>
            </button>
          </li>
        ))}
      </ul>
    </Panel>
  )
}
