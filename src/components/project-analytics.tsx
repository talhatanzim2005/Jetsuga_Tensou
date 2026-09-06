const BARS = [
  { day: "S", value: 45, shade: "oklch(0.55 0.11 155)" },
  { day: "M", value: 74, shade: "oklch(0.42 0.09 155)" },
  { day: "T", value: 76, shade: "oklch(0.62 0.14 155)" },
  { day: "W", value: 92, shade: "oklch(0.38 0.08 155)" },
  { day: "T", value: 36, shade: "oklch(0.55 0.11 155)" },
  { day: "F", value: 60, shade: "oklch(0.45 0.1 155)" },
  { day: "S", value: 50, shade: "oklch(0.68 0.16 155)" },
]

const MAX = 100

export function ProjectAnalytics() {
  const avg = Math.round(BARS.reduce((s, b) => s + b.value, 0) / BARS.length)
  const peak = Math.max(...BARS.map((b) => b.value))

  return (
    <section className="fos-card flex h-full flex-col rounded-2xl border border-border bg-card p-5">
      <div className="flex items-center justify-between">
        <h2 className="text-base font-semibold tracking-tight">
          Project Analytics
        </h2>
        <span className="flex items-center gap-1.5 text-xs text-muted-foreground">
          <span className="h-2 w-2 rounded-full bg-primary" />
          Weekly Activity
        </span>
      </div>

      <div className="mt-6 flex flex-1 items-end gap-3 sm:gap-4">
        {BARS.map((b, i) => (
          <div key={i} className="flex flex-1 flex-col items-center gap-2">
            <div className="flex h-44 w-full items-end">
              <div
                className="w-full rounded-xl transition-all"
                style={{
                  height: `${(b.value / MAX) * 100}%`,
                  backgroundColor: b.shade,
                }}
              />
            </div>
            <span className="text-xs font-medium text-muted-foreground">
              {b.day}
            </span>
          </div>
        ))}
      </div>

      <div className="mt-5 flex items-center justify-between border-t border-border pt-4 text-sm">
        <span className="text-muted-foreground">
          Average: <span className="font-bold text-foreground">{avg}%</span>
        </span>
        <span className="text-muted-foreground">
          Peak: <span className="font-bold text-primary">{peak}%</span>
        </span>
      </div>
    </section>
  )
}
