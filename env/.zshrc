setopt histignorealldups sharehistory

export VISUAL="nvim"
export EDITOR=$VISUAL
export ANTHROPIC_API_KEY=$(ansible-vault view ~/dotfiles/secrets.yml | awk '/api_key:/ {print $2}')


# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

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

eval "$(zoxide init zsh)"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

export TERM=alacritty

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export PATH="/home/chiyu/miniconda3/bin:$PATH"  # commented out by conda initialize

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/yoyo/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/yoyo/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/yoyo/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/yoyo/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

