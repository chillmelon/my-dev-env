---
name: zk-notes
description: Write to the user's zk work notebook. Use for 記筆記, 寫進知識庫, 排錯紀錄, 整理 inbox, save/capture/log notes, or any zk request.
---

The notebook's own `AGENTS.md` is the single source of truth for note types, templates, linking and verification. This skill locates the notebook and hands over to it.

1. Resolve the notebook: `NB="${ZK_NOTEBOOK_DIR:-$HOME/notes/work}"`. Confirm `$NB/.zk/config.toml` exists; when it does not, tell the user and stop.
2. Read `$NB/AGENTS.md` in full and follow it.
3. Run every `zk` and `git` command with `cd "$NB"` first (or `zk --notebook-dir "$NB"`), so the correct notebook is used from any cwd.
