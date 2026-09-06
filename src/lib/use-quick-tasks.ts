"use client"

import useSWR from "swr"
import { QUICK_TASKS } from "./data"
import type { QuickTask } from "./types"

const KEY = "facultyos/quick-tasks"

/**
 * Shared quick-tasks store. Both the Quick Tasks panel and the FacultyOS
 * assistant read/mutate the same SWR cache entry, so changes made by either
 * (checkbox, inline edit, or an AI command) stay in sync instantly.
 */
export function useQuickTasks() {
  const { data, mutate } = useSWR<QuickTask[]>(KEY, null, {
    fallbackData: QUICK_TASKS,
  })
  const tasks = data ?? QUICK_TASKS

  function addTask(title: string): QuickTask {
    const task: QuickTask = {
      id: `qt-${Date.now()}`,
      title: title.trim(),
      done: false,
    }
    mutate((current = QUICK_TASKS) => [task, ...current], false)
    return task
  }

  function updateTask(id: string, patch: Partial<Omit<QuickTask, "id">>) {
    mutate(
      (current = QUICK_TASKS) =>
        current.map((t) => (t.id === id ? { ...t, ...patch } : t)),
      false,
    )
  }

  function deleteTask(id: string) {
    mutate((current = QUICK_TASKS) => current.filter((t) => t.id !== id), false)
  }

  return { tasks, addTask, updateTask, deleteTask }
}

export type TaskActions = ReturnType<typeof useQuickTasks>
