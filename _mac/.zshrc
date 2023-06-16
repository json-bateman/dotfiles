# plugins
plugins=(autojump)
export ZSH="/Users/jack/.oh-my-zsh"
ZSH_THEME="af-magic"
source $ZSH/oh-my-zsh.sh

#------------------------------------
# Aliases
#------------------------------------

alias vim='nvim'
alias tks='tmux kill-server'
alias lg='lazygit'

#------------------------------------
# Path and Environment Variables
#------------------------------------

export PATH="/opt/homebrew/bin:$PATH"

#------------------------------------
# Keybinds
#------------------------------------

bindkey -s "^F" "tmux-sessionizer^M"
bindkey -v "K" up-line-or-beginning-search
bindkey -v "J" down-line-or-beginning-search
# bindkey "H" backward-char
# bindkey "L" forward-char

#------------------------------------
# Commands on Startup
#------------------------------------
# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
set -o vi

#------------------------------------
# Miscellaneous 
#------------------------------------
export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
