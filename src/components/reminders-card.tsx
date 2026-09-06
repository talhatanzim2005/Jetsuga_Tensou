import { Video } from "lucide-react"

export function RemindersCard() {
  return (
    <section className="fos-card rounded-2xl border border-border bg-card p-5">
      <h2 className="text-base font-semibold tracking-tight">Reminders</h2>

      <div className="mt-4 rounded-xl border border-border bg-muted/30 p-4">
        <p className="text-sm font-semibold">Meeting with Arc Company</p>
        <p className="mt-1 text-xs text-muted-foreground">
          Time : 02.00 pm - 04.00 pm
        </p>
        <button
          type="button"
          className="mt-4 flex w-full items-center justify-center gap-2 rounded-full bg-primary py-2.5 text-sm font-semibold text-primary-foreground shadow-md shadow-primary/25 transition-transform hover:scale-[1.01] active:scale-[0.99]"
        >
          <Video className="h-4 w-4" />
          Start Meeting
        </button>
      </div>
    </section>
  )
}
