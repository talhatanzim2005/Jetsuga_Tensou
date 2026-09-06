"use client"

import { useState } from "react"
import { Check, Pencil, Plus, Trash2 } from "lucide-react"
import { Panel } from "@/components/primitives"
import { useQuickTasks } from "@/lib/use-quick-tasks"
import { cn } from "@/lib/utils"

export function QuickTasks() {
  const { tasks, addTask, updateTask, deleteTask } = useQuickTasks()
  const [adding, setAdding] = useState(false)
  const [draft, setDraft] = useState("")
  const [editingId, setEditingId] = useState<string | null>(null)
  const [editDraft, setEditDraft] = useState("")

  function submitNew() {
    const title = draft.trim()
    if (!title) return
    addTask(title)
    setDraft("")
    setAdding(false)
  }

  function startEdit(id: string, title: string) {
    setEditingId(id)
    setEditDraft(title)
  }

  function submitEdit() {
    const title = editDraft.trim()
    if (editingId && title) updateTask(editingId, { title })
    setEditingId(null)
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
            submitNew()
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
          <li key={t.id} className="group">
            <div className="flex w-full items-center gap-3 rounded-lg px-2 py-2 transition-colors hover:bg-muted/60">
              <button
                type="button"
                onClick={() => updateTask(t.id, { done: !t.done })}
                aria-label={t.done ? `Mark "${t.title}" as not done` : `Mark "${t.title}" as done`}
                className={cn(
                  "flex h-[18px] w-[18px] shrink-0 items-center justify-center rounded border transition-colors",
                  t.done
                    ? "border-primary bg-primary text-primary-foreground"
                    : "border-input bg-card hover:border-primary/60",
                )}
              >
                {t.done ? <Check className="h-3 w-3" /> : null}
              </button>

              {editingId === t.id ? (
                <input
                  autoFocus
                  value={editDraft}
                  onChange={(e) => setEditDraft(e.target.value)}
                  onBlur={submitEdit}
                  onKeyDown={(e) => {
                    if (e.key === "Enter") submitEdit()
                    if (e.key === "Escape") setEditingId(null)
                  }}
                  aria-label={`Edit task "${t.title}"`}
                  className="h-7 min-w-0 flex-1 rounded-md border border-ring bg-background px-2 text-sm outline-none ring-2 ring-ring/20"
                />
              ) : (
                <button
                  type="button"
                  onClick={() => updateTask(t.id, { done: !t.done })}
                  className="min-w-0 flex-1 text-left"
                >
                  <span
                    className={cn(
                      "block truncate text-sm leading-snug",
                      t.done && "text-muted-foreground line-through",
                    )}
                    title={t.title}
                  >
                    {t.title}
                  </span>
                </button>
              )}

              <span className="ml-auto flex shrink-0 items-center gap-0.5 opacity-0 transition-opacity group-hover:opacity-100">
                <button
                  type="button"
                  onClick={() => startEdit(t.id, t.title)}
                  aria-label={`Edit "${t.title}"`}
                  className="flex h-7 w-7 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-accent hover:text-accent-foreground"
                >
                  <Pencil className="h-3.5 w-3.5" />
                </button>
                <button
                  type="button"
                  onClick={() => deleteTask(t.id)}
                  aria-label={`Delete "${t.title}"`}
                  className="flex h-7 w-7 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-danger/10 hover:text-danger"
                >
                  <Trash2 className="h-3.5 w-3.5" />
                </button>
              </span>
            </div>
          </li>
        ))}
      </ul>
    </Panel>
  )
}
