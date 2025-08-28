# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt histignorealldups sharehistory

export VISUAL="nvim"
export EDITOR=$VISUAL


# Aliases
alias vim='nvim'

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history


# Use modern completion system
autoload -Uz compinit
compinit

# Setup Package Manager
source $HOME/.antidote/antidote.zsh
antidote load

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export PATH="/home/chiyu/miniconda3/bin:$PATH"  # commented out by conda initialize


export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/scripts:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$HOME/personal/scripts:$PATH"
export PATH="/opt/homebrew/opt/bc/bin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/yoyo/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/yoyo/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/yoyo/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/yoyo/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
#
eval "$(zoxide init zsh)"


# pnpm
export PNPM_HOME="/Users/yoyo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
