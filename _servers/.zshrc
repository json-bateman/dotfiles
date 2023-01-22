# plugins
plugins=(git)
#------------------------------------
# Oh-My-Zsh stuff
#------------------------------------
ZSH_THEME="gnzh"
# old theme
# PS1=$'%{\e[1;31m%}%n%{\e[31m%}@%{\e[0m%}%m%{\e[0m%} :: %{\e[1;38m%}%/ %{\e[0m%}'
export ZSH="$HOME/.oh-my-zsh"
source ~/.oh-my-zsh/oh-my-zsh.sh

HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode disabled  # disable automatic updates
# Don't check untracked files (default behavior is to mark untracked files as dirty)
DISABLE_UNTRACKED_FILES_DIRTY="true"

#------------------------------------
# Aliases
#------------------------------------

alias vim="nvim"
alias gasx3='git push -f'
alias lg='lazygit'
alias tks='tmux kill-server' 

#------------------------------------
# Keybinds
#------------------------------------

bindkey -s "^F" "tmux-sessionizer^M"
bindkey "^K" up-line-or-beginning-search
bindkey "^J" down-line-or-beginning-search
bindkey "^H" backward-char
bindkey "^L" forward-char

#------------------------------------
# PATH and environment variables
#------------------------------------

export PATH="$PATH:/home/jack/Scripts"
export GOPATH="$HOME/go"

#------------------------------------
# Other ZSH settings
#------------------------------------

# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
# set -o vi
