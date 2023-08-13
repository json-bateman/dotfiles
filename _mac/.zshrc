# plugins
plugins=(autojump virtualenv)
export ZSH="/Users/jack/.oh-my-zsh"
ZSH_THEME="af-magic"
source $ZSH/oh-my-zsh.sh

#------------------------------------
# Aliases
#------------------------------------

alias vim='nvim'
alias tkS='tmux kill-server'
alias lg='lazygit'
alias tms='tmux-sessionizer'

#------------------------------------
# Path and Environment Variables
#------------------------------------

# Note, other variables are in the .zshenv file, the .zshenv file contains variables available to other programs
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/jack/scripts/:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

#------------------------------------
# Keybinds
#------------------------------------

bindkey -v "K" up-line-or-beginning-search
bindkey -v "J" down-line-or-beginning-search
# bindkey "H" backward-char
# bindkey "L" forward-char
bindkey '^R' history-incremental-search-backward

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
