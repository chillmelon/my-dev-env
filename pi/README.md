# Pi 設定快照

此目錄備份目前使用中的全域 Pi 設定，取代 repo 舊的 `agents/`。不是正在使用的設定目錄，也不會自動同步。

## 內容

- `agent/settings.json`：`~/.pi/agent/settings.json` 原樣快照，包含模型偏好與套件來源。
- `agent/keybindings.json`、`agent/APPEND_SYSTEM.md`：快捷鍵與附加指令。
- `agent/extensions/`：本機 extension 設定，目前為 RTK optimizer 設定。
- `agent/prompts/`：自訂 prompt。
- `agent/skills/`：29 個本機 skills。原本指向 `~/.agents/skills/` 的連結已轉為實際檔案，不依賴原機路徑。
- `packages.txt`：11 個啟用套件的頂層版本／Git commit，按原設定順序記錄。
- `patches/pi-codemapper.patch`：已安裝 CodeMapper 套件中尚未提交的 5 個檔案修改，相對於記錄的 commit。

快照使用 Pi **0.86.1**、Node.js **24.19.0**。`settings.json` 保持原樣，因此套件來源本身未鎖版；以下還原步驟使用 `packages.txt` 安裝指定版本，會讓還原後的 settings 記錄鎖版來源。

### 不包含

- `auth.json`、API keys、環境變數、SSH keys：需另外安全管理，新機重新登入。
- sessions、任務／mission 狀態、逐字稿、快取、暫存、信任紀錄、模型目錄快取。
- `npm/`、`git/` 套件副本、`node_modules/`、`dist/`、Python 快取／虛擬環境。
- Pi 的輔助二進位工具，以及 repo 以外的專案設定。
- 已安裝但未列入目前 `settings.json` 的停用套件。

這是設定快照，不是完整離線環境映像：固定頂層套件版本不等於固定所有間接依賴。套件內本機產生的 lockfile 也未備份。SSSF skill 的 visualizer 依賴需在使用時依該 skill 指示安裝。

## 在新環境還原

先準備 Node.js/npm、Git。CodeMapper 套件使用 GitHub SSH 來源，需先設定 GitHub SSH 存取權。相關功能也依賴 `cm`（CodeMapper CLI）、`rtk`、`rg`、`fd`；若使用 SSSF，另需依 skill 指示準備 Python／Bun 等工具。本快照不安裝這些系統工具。

以下從 **repo 根目錄** 執行，只允許還原到不存在的設定目錄，避免覆蓋現有設定。若目的地已存在，先退出所有使用該目錄的 Pi 程序，再自行移走／另行備份，或使用 `PI_CODING_AGENT_DIR` 指定新目錄。

```bash
(
  set -eu
  snapshot="$PWD/pi"
  target="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
  test -f "$snapshot/agent/settings.json"
  if test -e "$target"; then
    printf '目的地已存在，停止以避免覆蓋：%s\n' "$target" >&2
    exit 1
  fi

  npm install -g --ignore-scripts @earendil-works/pi-coding-agent@0.86.1
  mkdir -p "$target"
  cp -a "$snapshot/agent/." "$target/"
  export PI_CODING_AGENT_DIR="$target"

  while IFS= read -r package; do
    pi install "$package" --no-approve
  done < "$snapshot/packages.txt"

  package_dir="$target/git/github.com/elpapi42/pi-codemapper"
  git -C "$package_dir" apply --check "$snapshot/patches/pi-codemapper.patch"
  git -C "$package_dir" apply "$snapshot/patches/pi-codemapper.patch"
)
```

完成後啟動 `pi`，用 `/login` 重新登入供應商。若使用自訂設定目錄，啟動時仍需設定相同的 `PI_CODING_AGENT_DIR`。可用 `pi list` 查看套件，並在 Pi 內確認模型、快捷鍵、skills 與工具載入狀態。

注意：

- 原設定的模型名稱需要相應帳號／供應商支援，否則請用 `/model` 選擇可用模型。
- 這份快照將 shared skills 還原為 Pi 專用檔案，不會替其他 agent 建立 `~/.agents/skills/`。若新機已有另一份 shared skills，請自行確認重複載入問題。
- CodeMapper patch 屬於本機修改；未來升級套件前先保存，更新或重裝可能覆蓋它。
- 還原步驟需要網路，尚未在乾淨新機完整執行；本次僅驗證快照內容與 patch 可重建性。

## 日後更新

此快照不會追蹤家目錄的後續變更。重新備份時，只更新上述白名單資源，重新記錄 Pi／套件版本及本機 patch，再檢查 Git diff。不要直接複製整個 `~/.pi/agent/`。

`.gitignore` 僅是基本防護，不會自動清除設定或 extension 中手寫的 token；提交前仍需檢查敏感資訊。
