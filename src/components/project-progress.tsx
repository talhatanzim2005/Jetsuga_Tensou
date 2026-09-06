const PERCENT = 41

export function ProjectProgress() {
  const size = 180
  const stroke = 14
  const r = (size - stroke) / 2
  const c = 2 * Math.PI * r
  const filled = (PERCENT / 100) * c

  return (
    <section className="fos-card rounded-2xl border border-border bg-card p-5">
      <h2 className="text-base font-semibold tracking-tight">Project Progress</h2>

      <div className="mt-4 flex flex-col items-center">
        <div className="relative" style={{ width: size, height: size }}>
          {/* hatched pending background */}
          <svg width={size} height={size} className="absolute inset-0">
            <defs>
              <pattern
                id="hatch"
                width="8"
                height="8"
                patternTransform="rotate(45)"
                patternUnits="userSpaceOnUse"
              >
                <rect width="8" height="8" fill="transparent" />
                <line
                  x1="0"
                  y1="0"
                  x2="0"
                  y2="8"
                  stroke="var(--primary)"
                  strokeWidth="3"
                  opacity="0.18"
                />
              </pattern>
            </defs>
            <circle cx={size / 2} cy={size / 2} r={r - 6} fill="url(#hatch)" />
          </svg>
          {/* progress ring */}
          <svg
            width={size}
            height={size}
            className="absolute inset-0 -rotate-90"
          >
            <circle
              cx={size / 2}
              cy={size / 2}
              r={r}
              fill="none"
              stroke="var(--primary)"
              strokeWidth={stroke}
              strokeLinecap="round"
              strokeDasharray={`${filled} ${c - filled}`}
            />
          </svg>
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <span className="text-4xl font-bold tracking-tight">
              {PERCENT}%
            </span>
            <span className="mt-1 text-xs text-muted-foreground">
              Project Ended
            </span>
          </div>
        </div>

        <div className="mt-5 flex items-center gap-4 text-xs text-muted-foreground">
          <span className="flex items-center gap-1.5">
            <span className="h-2.5 w-2.5 rounded-full bg-primary" />
            Completed
          </span>
          <span className="flex items-center gap-1.5">
            <span className="h-2.5 w-2.5 rounded-full bg-foreground" />
            In Progress
          </span>
          <span className="flex items-center gap-1.5">
            <span className="h-2.5 w-2.5 rounded-full border border-primary/40 bg-[repeating-linear-gradient(45deg,transparent,transparent_1px,var(--primary)_1px,var(--primary)_2px)] opacity-40" />
            Pending
          </span>
        </div>
      </div>
    </section>
  )
}
