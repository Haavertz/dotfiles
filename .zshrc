#
# ~/.zshrc
#

[[ $- != *i* ]] && return

# ui 
if [[ $- == *i* ]]; then
  fastfetch
fi

# ux

export PATH="/home/raj/.local/bin:$PATH"

# alias

alias ll='exa -lg --icons'
alias lll='exa -lga'
alias ..='cd ..'
alias cat='bat --style=header,grid'
alias cd='z'

# utility

alias n='nvim'
alias mkdir='mkdir -p'
alias diff='difft'
alias h='herdr'

# misc
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


# plugins
source <(fzf --zsh)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
