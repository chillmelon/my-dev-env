## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Delegation Routing

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
