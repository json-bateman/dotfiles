# plugins
plugins=(autojump virtualenv zsh-autosuggestions)
export ZSH="/Users/jack/.oh-my-zsh"
ZSH_THEME="af-magic"
source $ZSH/oh-my-zsh.sh

#---------
# Aliases
#---------

alias tkS='tmux kill-server'
alias tks='tmux kill-session'
alias tms='tmux-sessionizer'
alias emacs='emacs -nw' # Opens emacs in current terminal instead of standalone program
alias f='cd $(fd --type directory | fzf)' # Jump into directory selected using fzf

#------------------------------------
# Path and Environment Variables
#------------------------------------

# Note, other variables are in the .zshenv file, the .zshenv file contains variables available to other programs
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/jack/scripts/:$PATH"
export PATH="$HOME/go/bin:$PATH"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# GOPATH
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
# Gogotools
export PATH="/Users/jack/Coding/gogo/GoGoTools/bin:$PATH"
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export PATH="/Applications/Emacs.app/Contents/MacOS:$PATH"
export Path="$HOME/Coding/gogo/GoGoTools/bin:$PATH"

#------------------------------------
# Keybinds
#------------------------------------

# bindkey -v "K" up-line-or-beginning-search
# bindkey -v "J" down-line-or-beginning-search
# bindkey "H" backward-char
# bindkey "L" forward-char
# bindkey '^R' history-incremental-search-backward

#------------------------------------
# Miscellaneous 
#------------------------------------
export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY

eval "$(direnv hook zsh)"

# ---------
# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# pnpm
export PNPM_HOME="/Users/jack/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm endexport PATH="/opt/homebrew/opt/lua@5.3/bin:$PATH"
export PATH="/opt/homebrew/opt/lua@5.3/bin:$PATH"

# [ -s ~/.luaver/luaver ] && . ~/.luaver/luaver 
# [ -s ~/.luaver/completions/luaver.bash ] && . ~/.luaver/completions/luaver.bash

# --------------------------
# Options
# --------------------------
setopt GLOB_DOTS

# --------------------------
# Sourcing Files on Startup
# --------------------------
source "/Users/jack/.deno/env"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
eval "$(/usr/local/bin/mise activate zsh)"

# ---------------
# Vim mode config
# ---------------

# Activate vim mode.
bindkey -v

# Remove mode switching delay.
KEYTIMEOUT=5

# Cursor shape change when entering iterm or changing modes
function zle-keymap-select zle-line-init
{
    # change cursor shape in iTerm2
    case $KEYMAP in
        vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
        viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
    esac

    zle reset-prompt
    zle -R
}

function zle-line-finish
{
    print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

