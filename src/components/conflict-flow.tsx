"use client"

import { useEffect, useState } from "react"
import {
  ArrowLeft,
  ArrowRight,
  Brain,
  CalendarClock,
  Check,
  CheckCircle2,
  Radar,
  TriangleAlert,
  Wrench,
  X,
} from "lucide-react"
import { Badge, CourseTag } from "@/components/primitives"
import {
  MEETINGS,
  NOTICES,
  ORIGINAL_EXAM_TIME,
  PRIMARY_CONFLICT,
} from "@/lib/data"
import { formatDate, to12h, toMinutes } from "@/lib/utils"

const STEPS = [
  { label: "Detected", icon: Radar },
  { label: "Understood", icon: Brain },
  { label: "Conflict", icon: TriangleAlert },
  { label: "Action", icon: Wrench },
]

const RESOLUTION_OPTIONS = [
  { id: "move", label: "Move meeting to 12:15 PM", detail: "Recommended — clears the overlap", best: true },
  { id: "shorten", label: "Shorten meeting to 11:30 AM", detail: "Ends before the exam begins" },
  { id: "delegate", label: "Delegate exam invigilation", detail: "Ask co-examiner to cover" },
]

export function ConflictFlow({
  open,
  onClose,
  onResolve,
}: {
  open: boolean
  onClose: () => void
  onResolve: () => void
}) {
  const [step, setStep] = useState(0)
  const [choice, setChoice] = useState<string>("move")

  useEffect(() => {
    if (open) {
      setStep(0)
      setChoice("move")
    }
  }, [open])

  useEffect(() => {
    function onKey(e: KeyboardEvent) {
      if (e.key === "Escape") onClose()
    }
    if (open) document.addEventListener("keydown", onKey)
    return () => document.removeEventListener("keydown", onKey)
  }, [open, onClose])

  if (!open || !PRIMARY_CONFLICT) return null

  const c = PRIMARY_CONFLICT
  const notice = NOTICES.find((n) => n.id === "ann-003")!
  const meeting = MEETINGS[0]

  function finish() {
    onResolve()
    onClose()
  }

  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center bg-background/70 p-0 backdrop-blur-sm sm:items-center sm:p-4">
      <button
        type="button"
        aria-label="Close"
        onClick={onClose}
        className="absolute inset-0 h-full w-full cursor-default"
      />
      <div className="fos-scale-in relative flex max-h-[92vh] w-full max-w-lg flex-col overflow-hidden rounded-t-2xl border border-border bg-popover sm:rounded-2xl">
        {/* header + stepper */}
        <div className="border-b border-border px-5 py-4">
          <div className="mb-3 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="flex h-6 w-6 items-center justify-center rounded-md bg-primary/15 text-primary">
                <Radar className="h-3.5 w-3.5" />
              </span>
              <h2 className="text-sm font-semibold tracking-tight">
                Conflict resolution
              </h2>
            </div>
            <button
              type="button"
              onClick={onClose}
              aria-label="Close"
              className="flex h-7 w-7 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"
            >
              <X className="h-4 w-4" />
            </button>
          </div>
          <ol className="flex items-center gap-1.5">
            {STEPS.map((s, i) => {
              const done = i < step
              const active = i === step
              return (
                <li key={s.label} className="flex flex-1 flex-col gap-1.5">
                  <div
                    className={`h-1 rounded-full transition-colors ${
                      done || active ? "bg-primary" : "bg-border"
                    }`}
                  />
                  <span
                    className={`flex items-center gap-1 text-[10px] font-medium uppercase tracking-wide ${
                      active
                        ? "text-primary"
                        : done
                          ? "text-foreground"
                          : "text-muted-foreground"
                    }`}
                  >
                    {done ? <Check className="h-3 w-3" /> : <s.icon className="h-3 w-3" />}
                    <span className="hidden sm:inline">{s.label}</span>
                  </span>
                </li>
              )
            })}
          </ol>
        </div>

        {/* body */}
        <div className="fos-scroll flex-1 overflow-y-auto px-5 py-5">
          {step === 0 ? (
            <StepDetected notice={notice} />
          ) : step === 1 ? (
            <StepUnderstood
              course={c.a.subtitle}
              newDate={c.date}
              newStart={c.a.start_time}
              newEnd={c.a.end_time}
              room={c.a.room}
            />
          ) : step === 2 ? (
            <StepConflict
              examLabel={c.a.subtitle}
              examStart={c.a.start_time}
              examEnd={c.a.end_time}
              meetingLabel={meeting.title}
              meetingStart={meeting.start_time}
              meetingEnd={meeting.end_time}
              date={c.date}
              overlapStart={c.overlapStart}
              overlapEnd={c.overlapEnd}
              overlapMinutes={c.overlapMinutes}
            />
          ) : (
            <StepAction choice={choice} setChoice={setChoice} />
          )}
        </div>

        {/* footer */}
        <div className="flex items-center justify-between gap-3 border-t border-border px-5 py-4">
          <button
            type="button"
            onClick={() => setStep((s) => Math.max(0, s - 1))}
            disabled={step === 0}
            className="inline-flex items-center gap-1.5 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition-colors hover:text-foreground disabled:invisible"
          >
            <ArrowLeft className="h-4 w-4" /> Back
          </button>
          {step < STEPS.length - 1 ? (
            <button
              type="button"
              onClick={() => setStep((s) => s + 1)}
              className="inline-flex items-center gap-1.5 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground transition-transform hover:scale-[1.02] active:scale-[0.99]"
            >
              {step === 2 ? "Resolve it" : "Continue"}
              <ArrowRight className="h-4 w-4" />
            </button>
          ) : (
            <button
              type="button"
              onClick={finish}
              className="inline-flex items-center gap-1.5 rounded-lg bg-success px-4 py-2 text-sm font-semibold text-success-foreground transition-transform hover:scale-[1.02] active:scale-[0.99]"
            >
              <Check className="h-4 w-4" />
              Confirm &amp; update calendar
            </button>
          )}
        </div>
      </div>
    </div>
  )
}

function StepDetected({ notice }: { notice: (typeof NOTICES)[number] }) {
  return (
    <div className="fos-fade-up space-y-4">
      <Intro
        icon={<Radar className="h-4 w-4" />}
        title="New information detected"
        body="FacultyOS picked up a new notice from the university and flagged it as relevant to you."
      />
      <div className="rounded-lg border border-danger/30 bg-danger/10 p-4">
        <div className="mb-2 flex items-center justify-between gap-2">
          <Badge tone="danger">Important · {notice.category}</Badge>
          <span className="font-mono text-[11px] text-muted-foreground">
            {formatDate(notice.date)}
          </span>
        </div>
        <h3 className="text-sm font-semibold">{notice.title}</h3>
        <p className="mt-1.5 text-xs leading-relaxed text-muted-foreground">
          {notice.body}
        </p>
        <p className="mt-3 font-mono text-[11px] text-muted-foreground">
          Source: {notice.posted_by}
        </p>
      </div>
    </div>
  )
}

function StepUnderstood({
  course,
  newDate,
  newStart,
  newEnd,
  room,
}: {
  course: string
  newDate: string
  newStart: string
  newEnd: string
  room: string
}) {
  return (
    <div className="fos-fade-up space-y-4">
      <Intro
        icon={<Brain className="h-4 w-4" />}
        title="AI understood the notice"
        body="Instead of raw text, here is exactly what changed and who it affects."
      />
      <div className="flex items-center gap-2">
        <CourseTag code="CSE 2201" />
        <span className="text-sm font-medium">{course}</span>
      </div>
      <div className="grid grid-cols-2 gap-3">
        <div className="rounded-lg border border-border bg-background/40 p-3">
          <p className="mb-1 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
            Previous
          </p>
          <p className="text-sm font-medium line-through decoration-danger/60">
            {formatDate(ORIGINAL_EXAM_TIME.date)}
          </p>
          <p className="font-mono text-xs text-muted-foreground line-through decoration-danger/60">
            {to12h(ORIGINAL_EXAM_TIME.start_time)}
          </p>
        </div>
        <div className="rounded-lg border border-primary/40 bg-primary/10 p-3">
          <p className="mb-1 text-[10px] font-medium uppercase tracking-wide text-primary">
            New
          </p>
          <p className="text-sm font-medium">{formatDate(newDate)}</p>
          <p className="font-mono text-xs text-muted-foreground">
            {to12h(newStart)} – {to12h(newEnd)} · {room}
          </p>
        </div>
      </div>
      <p className="rounded-lg bg-accent px-3 py-2.5 text-xs leading-relaxed text-accent-foreground">
        You are the <span className="font-medium">course examiner</span> for CSE
        2201, so this change lands directly on your calendar.
      </p>
    </div>
  )
}

function StepConflict(props: {
  examLabel: string
  examStart: string
  examEnd: string
  meetingLabel: string
  meetingStart: string
  meetingEnd: string
  date: string
  overlapStart: string
  overlapEnd: string
  overlapMinutes: number
}) {
  // timeline window 11:00 – 14:30
  const axisStart = toMinutes("11:00")
  const axisEnd = toMinutes("14:30")
  const span = axisEnd - axisStart
  const pct = (t: string) => ((toMinutes(t) - axisStart) / span) * 100
  const width = (a: string, b: string) =>
    ((toMinutes(b) - toMinutes(a)) / span) * 100

  return (
    <div className="fos-fade-up space-y-4">
      <Intro
        icon={<TriangleAlert className="h-4 w-4" />}
        title="Conflict detected"
        body="Compared against your routine, the new exam time overlaps another commitment."
        tone="danger"
      />

      <div className="rounded-lg border border-border bg-background/40 p-4">
        <div className="mb-3 flex items-center justify-between">
          <span className="text-xs font-medium text-muted-foreground">
            {formatDate(props.date)}
          </span>
          <Badge tone="danger">
            {props.overlapMinutes} min overlap
          </Badge>
        </div>

        <div className="space-y-3">
          <TimelineRow
            label={props.meetingLabel}
            time={`${to12h(props.meetingStart)}–${to12h(props.meetingEnd)}`}
            left={pct(props.meetingStart)}
            w={width(props.meetingStart, props.meetingEnd)}
            tone="meeting"
          />
          <TimelineRow
            label={props.examLabel}
            time={`${to12h(props.examStart)}–${to12h(props.examEnd)}`}
            left={pct(props.examStart)}
            w={width(props.examStart, props.examEnd)}
            tone="exam"
          />
        </div>

        {/* overlap marker */}
        <div className="relative mt-3 h-6">
          <div
            className="absolute top-0 flex h-6 items-center justify-center rounded bg-danger/25"
            style={{
              left: `${pct(props.overlapStart)}%`,
              width: `${width(props.overlapStart, props.overlapEnd)}%`,
            }}
          >
            <span className="whitespace-nowrap px-1 font-mono text-[10px] font-semibold text-danger">
              {to12h(props.overlapStart)}–{to12h(props.overlapEnd)}
            </span>
          </div>
        </div>

        <div className="mt-1 flex justify-between font-mono text-[10px] text-muted-foreground">
          <span>11:00</span>
          <span>12:30</span>
          <span>14:00</span>
        </div>
      </div>

      <div className="flex items-start gap-2 rounded-lg border border-warning/30 bg-warning/10 p-3">
        <Wrench className="mt-0.5 h-4 w-4 shrink-0 text-warning" />
        <p className="text-xs leading-relaxed text-foreground">
          Suggested action: reschedule the{" "}
          <span className="font-medium">{props.meetingLabel.toLowerCase()}</span>,
          since the examination time is fixed by the university.
        </p>
      </div>
    </div>
  )
}

function TimelineRow({
  label,
  time,
  left,
  w,
  tone,
}: {
  label: string
  time: string
  left: number
  w: number
  tone: "exam" | "meeting"
}) {
  return (
    <div>
      <div className="mb-1 flex items-center justify-between text-xs">
        <span className="font-medium">{label}</span>
        <span className="font-mono text-[10px] text-muted-foreground">
          {time}
        </span>
      </div>
      <div className="relative h-6 rounded bg-muted/60">
        <div
          className={`absolute top-0 flex h-6 items-center rounded px-2 text-[10px] font-medium ${
            tone === "exam"
              ? "bg-danger/70 text-danger-foreground"
              : "bg-primary/70 text-primary-foreground"
          }`}
          style={{ left: `${left}%`, width: `${w}%` }}
        >
          {tone === "exam" ? "Exam" : "Meeting"}
        </div>
      </div>
    </div>
  )
}

function StepAction({
  choice,
  setChoice,
}: {
  choice: string
  setChoice: (v: string) => void
}) {
  return (
    <div className="fos-fade-up space-y-4">
      <Intro
        icon={<CheckCircle2 className="h-4 w-4" />}
        title="Choose how to resolve it"
        body="Pick an action and FacultyOS updates your calendar and notifies attendees."
        tone="success"
      />
      <div className="space-y-2.5">
        {RESOLUTION_OPTIONS.map((opt) => {
          const selected = choice === opt.id
          return (
            <button
              key={opt.id}
              type="button"
              onClick={() => setChoice(opt.id)}
              className={`flex w-full items-center gap-3 rounded-lg border p-3.5 text-left transition-colors ${
                selected
                  ? "border-primary bg-primary/10"
                  : "border-border bg-background/40 hover:border-primary/40"
              }`}
            >
              <span
                className={`flex h-5 w-5 shrink-0 items-center justify-center rounded-full border ${
                  selected
                    ? "border-primary bg-primary text-primary-foreground"
                    : "border-border"
                }`}
              >
                {selected ? <Check className="h-3 w-3" /> : null}
              </span>
              <span className="min-w-0 flex-1">
                <span className="flex items-center gap-2 text-sm font-medium">
                  {opt.label}
                  {opt.best ? <Badge tone="success">Best</Badge> : null}
                </span>
                <span className="text-xs text-muted-foreground">
                  {opt.detail}
                </span>
              </span>
            </button>
          )
        })}
      </div>
    </div>
  )
}

function Intro({
  icon,
  title,
  body,
  tone = "primary",
}: {
  icon: React.ReactNode
  title: string
  body: string
  tone?: "primary" | "danger" | "success"
}) {
  const toneClass =
    tone === "danger"
      ? "bg-danger/15 text-danger"
      : tone === "success"
        ? "bg-success/15 text-success"
        : "bg-primary/15 text-primary"
  return (
    <div className="flex items-start gap-3">
      <span className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-lg ${toneClass}`}>
        {icon}
      </span>
      <div>
        <h3 className="text-sm font-semibold tracking-tight">{title}</h3>
        <p className="mt-0.5 text-xs leading-relaxed text-muted-foreground">
          {body}
        </p>
      </div>
    </div>
  )
}
