**Three delegation tools are installed. Pick by context need, not by habit.**

| Use | When | Why |
|---|---|---|
| `fork` | The work depends on this conversation — debugging, review, validating a change we just discussed | Inherits the active session branch, so it already knows the task history and constraints |
| `Agent` | The work is self-contained — locating code, open-ended research, planning | Fresh context. Use `Explore` for finding things, `Plan` for strategy. Prefer `run_in_background` for independent work |
| `TaskExecute` | The work is already a tracked task with `agentType` set | Never wrap these in `Agent` — they are already running |

Defaults when torn:
- Needs our conversation → `fork`. Doesn't → `Agent`.
- Read-only lookup with a known target → no delegation. Just use `ffgrep`/`Read`.
- Never run the same search yourself that you delegated.

**Search order before delegating:** `map`/`search` (codemapper) to orient → `ffgrep`/`fffind` to locate → `Read` to confirm. Delegating a search you could do in two calls wastes more than it saves.

---
