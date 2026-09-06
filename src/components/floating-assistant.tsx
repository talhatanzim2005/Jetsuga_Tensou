"use client"

import { useEffect, useRef, useState } from "react"
import { GraduationCap, Send, X } from "lucide-react"
import { Badge } from "@/components/primitives"
import {
  answer,
  SUGGESTED_QUESTIONS,
  tryTaskCommand,
  type AssistantReply,
} from "@/lib/assistant"
import { useQuickTasks } from "@/lib/use-quick-tasks"

interface Message {
  id: number
  role: "user" | "assistant"
  text: string
  tags?: AssistantReply["tags"]
  thinking?: boolean
}

const toneMap = {
  info: "info",
  warning: "warning",
  danger: "danger",
  success: "success",
} as const

let counter = 0
const nextId = () => ++counter

export function FloatingAssistant() {
  const taskActions = useQuickTasks()
  const [open, setOpen] = useState(false)
  const [messages, setMessages] = useState<Message[]>([
    {
      id: nextId(),
      role: "assistant",
      text: "Hi Dr. Razi — I'm FacultyOS. I've reviewed this week's university information against your routine. Ask me anything, or tell me to add, edit, complete, or delete your quick tasks.",
    },
  ])
  const [input, setInput] = useState("")
  const [busy, setBusy] = useState(false)
  const scrollRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    scrollRef.current?.scrollTo({
      top: scrollRef.current.scrollHeight,
      behavior: "smooth",
    })
  }, [messages, open])

  function ask(question: string) {
    const text = question.trim()
    if (!text || busy) return
    setInput("")
    setBusy(true)

    const userMsg: Message = { id: nextId(), role: "user", text }
    const thinkingMsg: Message = {
      id: nextId(),
      role: "assistant",
      text: "",
      thinking: true,
    }
    setMessages((m) => [...m, userMsg, thinkingMsg])

    window.setTimeout(() => {
      const reply = tryTaskCommand(text, taskActions) ?? answer(text)
      setMessages((m) =>
        m.map((msg) =>
          msg.id === thinkingMsg.id
            ? { ...msg, text: reply.text, tags: reply.tags, thinking: false }
            : msg,
        ),
      )
      setBusy(false)
    }, 650)
  }

  if (!open) {
    return (
      <button
        type="button"
        onClick={() => setOpen(true)}
        aria-label="Open FacultyOS assistant"
        className="fos-scale-in fixed bottom-5 right-5 z-40 flex h-14 w-14 items-center justify-center rounded-full bg-primary text-primary-foreground shadow-lg shadow-primary/30 transition-transform hover:scale-105 active:scale-95"
      >
        <GraduationCap className="h-6 w-6" />
      </button>
    )
  }

  return (
    <div className="fos-scale-in fixed bottom-5 right-5 z-40 flex h-[34rem] w-[min(24rem,calc(100vw-2.5rem))] flex-col overflow-hidden rounded-2xl border border-border bg-card shadow-2xl">
      <div className="flex items-center gap-2.5 border-b border-border px-4 py-3.5">
        <div className="flex h-9 w-9 items-center justify-center rounded-full bg-primary text-primary-foreground">
          <GraduationCap className="h-5 w-5" />
        </div>
        <div className="leading-tight">
          <h2 className="text-sm font-semibold tracking-tight">FacultyOS</h2>
          <p className="text-[11px] text-muted-foreground">
            AI Academic Assistant
          </p>
        </div>
        <button
          type="button"
          onClick={() => setOpen(false)}
          aria-label="Close assistant"
          className="ml-auto flex h-8 w-8 items-center justify-center rounded-full text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
        >
          <X className="h-4 w-4" />
        </button>
      </div>

      <div
        ref={scrollRef}
        className="fos-scroll flex-1 space-y-4 overflow-y-auto px-4 py-4"
      >
        {messages.map((m) => (
          <div
            key={m.id}
            className={
              m.role === "user" ? "flex justify-end" : "flex justify-start"
            }
          >
            <div
              className={
                m.role === "user"
                  ? "max-w-[85%] rounded-2xl rounded-br-sm bg-primary px-3.5 py-2.5 text-sm text-primary-foreground"
                  : "max-w-[90%] rounded-2xl rounded-bl-sm bg-muted px-3.5 py-2.5 text-sm text-foreground"
              }
            >
              {m.thinking ? (
                <span className="flex items-center gap-1 py-0.5">
                  <span className="h-1.5 w-1.5 animate-bounce rounded-full bg-muted-foreground [animation-delay:-0.3s]" />
                  <span className="h-1.5 w-1.5 animate-bounce rounded-full bg-muted-foreground [animation-delay:-0.15s]" />
                  <span className="h-1.5 w-1.5 animate-bounce rounded-full bg-muted-foreground" />
                </span>
              ) : (
                <>
                  <p className="leading-relaxed">{m.text}</p>
                  {m.tags && m.tags.length > 0 ? (
                    <div className="mt-2 flex flex-wrap gap-1.5">
                      {m.tags.map((t, i) => (
                        <Badge key={i} tone={toneMap[t.tone]}>
                          {t.label}
                        </Badge>
                      ))}
                    </div>
                  ) : null}
                </>
              )}
            </div>
          </div>
        ))}
      </div>

      <div className="border-t border-border px-4 py-3">
        <div className="mb-2.5 flex flex-wrap gap-1.5">
          {SUGGESTED_QUESTIONS.slice(0, 3).map((q) => (
            <button
              key={q}
              type="button"
              onClick={() => ask(q)}
              disabled={busy}
              className="rounded-full border border-border bg-card px-2.5 py-1 text-xs text-muted-foreground transition-colors hover:border-primary/50 hover:text-primary disabled:opacity-50"
            >
              {q}
            </button>
          ))}
        </div>
        <form
          onSubmit={(e) => {
            e.preventDefault()
            ask(input)
          }}
          className="flex items-center gap-2"
        >
          <input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Ask me, or say “add task …”"
            className="h-10 flex-1 rounded-full border border-input bg-background px-4 text-sm outline-none placeholder:text-muted-foreground focus:border-ring focus:ring-2 focus:ring-ring/20"
          />
          <button
            type="submit"
            disabled={busy || !input.trim()}
            aria-label="Send"
            className="flex h-10 w-10 items-center justify-center rounded-full bg-primary text-primary-foreground transition-opacity disabled:opacity-40"
          >
            <Send className="h-4 w-4" />
          </button>
        </form>
      </div>
    </div>
  )
}
