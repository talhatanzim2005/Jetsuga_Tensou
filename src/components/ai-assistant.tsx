"use client"

import { useEffect, useRef, useState } from "react"
import { Send, Sparkles } from "lucide-react"
import { Badge } from "@/components/primitives"
import { answer, SUGGESTED_QUESTIONS, type AssistantReply } from "@/lib/assistant"

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

export function AiAssistant() {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: nextId(),
      role: "assistant",
      text: "Hi Dr. Razi — I've reviewed this week's university information against your routine. Ask me anything, or tap a question below.",
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
  }, [messages])

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
      const reply = answer(text)
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

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    ask(input)
  }

  return (
    <div className="flex h-[32rem] flex-col rounded-xl border border-border bg-card">
      <div className="flex items-center gap-2 border-b border-border px-5 py-4">
        <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-primary/15 text-primary">
          <Sparkles className="h-4 w-4" />
        </div>
        <div className="leading-tight">
          <h2 className="text-sm font-semibold tracking-tight">
            AI Academic Assistant
          </h2>
          <p className="text-[11px] text-muted-foreground">
            Answers from your actual schedule
          </p>
        </div>
      </div>

      <div ref={scrollRef} className="fos-scroll flex-1 space-y-4 overflow-y-auto px-5 py-4">
        {messages.map((m) => (
          <div
            key={m.id}
            className={m.role === "user" ? "flex justify-end" : "flex justify-start"}
          >
            <div
              className={
                m.role === "user"
                  ? "max-w-[85%] rounded-2xl rounded-br-sm bg-primary px-3.5 py-2.5 text-sm text-primary-foreground"
                  : "max-w-[90%] rounded-2xl rounded-bl-sm bg-accent px-3.5 py-2.5 text-sm text-accent-foreground"
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

      <div className="border-t border-border px-5 py-3">
        <div className="mb-2.5 flex flex-wrap gap-1.5">
          {SUGGESTED_QUESTIONS.slice(0, 3).map((q) => (
            <button
              key={q}
              type="button"
              onClick={() => ask(q)}
              disabled={busy}
              className="rounded-full border border-border bg-background/60 px-2.5 py-1 text-xs text-muted-foreground transition-colors hover:border-primary/40 hover:text-foreground disabled:opacity-50"
            >
              {q}
            </button>
          ))}
        </div>
        <form onSubmit={handleSubmit} className="flex items-center gap-2">
          <input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Ask about your schedule…"
            className="h-10 flex-1 rounded-lg border border-input bg-background/60 px-3 text-sm outline-none placeholder:text-muted-foreground focus:border-ring focus:ring-2 focus:ring-ring/30"
          />
          <button
            type="submit"
            disabled={busy || !input.trim()}
            aria-label="Send"
            className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary text-primary-foreground transition-opacity disabled:opacity-40"
          >
            <Send className="h-4 w-4" />
          </button>
        </form>
      </div>
    </div>
  )
}
