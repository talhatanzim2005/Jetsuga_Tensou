import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function to12h(time: string): string {
  const [hStr, m] = time.split(":")
  let h = Number.parseInt(hStr, 10)
  const suffix = h >= 12 ? "PM" : "AM"
  h = h % 12
  if (h === 0) h = 12
  return `${h}:${m} ${suffix}`
}

export function formatDate(iso: string): string {
  const d = new Date(`${iso}T00:00:00`)
  return d.toLocaleDateString("en-US", {
    weekday: "short",
    month: "short",
    day: "numeric",
  })
}

export function formatDateLong(iso: string): string {
  const d = new Date(`${iso}T00:00:00`)
  return d.toLocaleDateString("en-US", {
    weekday: "long",
    month: "long",
    day: "numeric",
    year: "numeric",
  })
}

/** minutes since midnight */
export function toMinutes(time: string): number {
  const [h, m] = time.split(":").map((n) => Number.parseInt(n, 10))
  return h * 60 + m
}

export function durationLabel(minutes: number): string {
  const h = Math.floor(minutes / 60)
  const m = minutes % 60
  if (h === 0) return `${m} min`
  if (m === 0) return `${h}h`
  return `${h}h ${m}m`
}
