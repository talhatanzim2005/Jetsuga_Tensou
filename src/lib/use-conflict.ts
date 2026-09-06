"use client"

import useSWR from "swr"

/**
 * Shared resolved-state for the primary schedule conflict, so the dashboard,
 * AUST Intel, and the sidebar badge all stay in sync.
 */
export function useConflict() {
  const { data, mutate } = useSWR("facultyos/conflict", null, {
    fallbackData: { resolved: false },
  })
  const resolved = data?.resolved ?? false
  return {
    resolved,
    resolve: () => mutate({ resolved: true }, false),
  }
}
