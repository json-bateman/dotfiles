# Portable zshrc for mac + linux (mirrors the home-manager config in nix/home/common.nix)

# --- oh-my-zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="murilasso"
plugins=(git virtualenv autojump)
source "$ZSH/oh-my-zsh.sh"

# --- locale / editor / term ---
export LANG=en_US.UTF-8
export EDITOR=nvim
export HIST_STAMPS="yyyy/mm/dd"
if [[ -n "$TMUX" ]]; then export TERM=tmux-256color; else export TERM=xterm-256color; fi

# --- path ---
export PATH="$HOME/go/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"      # mac (Apple Silicon Homebrew)
export PATH="$HOME/dotfiles/scripts:$PATH"
export PATH="/usr/local/bin:$PATH"

# --- keybindings (vi mode) ---
bindkey -v
export KEYTIMEOUT=1

# --- history ---
HISTFILE="$HOME/.zhistory"
HISTSIZE=20000
SAVEHIST=20000
setopt extended_history share_history hist_expire_dups_first hist_ignore_dups hist_verify

# --- options ---
setopt glob_dots

# --- aliases ---
alias tkS='tmux kill-server'
alias tks='tmux kill-session'
alias tms='tmux-sessionizer'
alias f='cd $(fd --type directory | fzf)'
alias lg='lazygit'

# --- mise ---
command -v mise >/dev/null && eval "$(mise activate zsh)"

# --- direnv ---
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# --- fzf ---
if command -v fzf >/dev/null; then
    eval "$(fzf --zsh)" 2>/dev/null \
        || { [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh; } \
        || { [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh; }
fi

# --- extras (guarded sourcing) ---
try-source() { for p in "$@"; do [[ -r "$p" ]] && source "$p" && return 0; done; }

# autosuggestions
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=245"
try-source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
           /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
           "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# syntax highlighting (must load AFTER autosuggestions)
try-source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
           /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
           "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
