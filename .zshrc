#
# ~/.zshrc
#

if [[ $- == *i* ]]; then
  fastfetch
fi

# plugin manager zsh
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# PATHs
export PATH="$HOME/.local/bin:$PATH"

# alias
alias ll='eza -lg --icons'
alias lll='eza -lga --icons'
alias ..='cd ..'
alias cat='bat --style=header,grid'
alias c='z'

# utility
alias v='nvim'
alias mk='mkdir -p'
alias diff='difft'
alias h='herdr'
alias va='source ./venv/bin/activate'

# misc
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# plugins
source <(fzf --zsh)

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

autoload -U compinit && compinit

# keybinding
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:c:*' fzf-preview 'ls --color $realpath'


# opencode
export PATH=/home/raj/.opencode/bin:$PATH
