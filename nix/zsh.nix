{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";          # bindkey -v

    autosuggestion.enable = true; # mac omz plugin + linux try-source
    syntaxHighlighting.enable = true; # mac omz plugin + linux try-source (loaded after, automatically)

    oh-my-zsh = {
      enable = true;
      theme = "murilasso";
      plugins = [ "git" "virtualenv" ]; # autojump handled by programs.autojump
    };

    history = {
      path = "$HOME/.zhistory";
      size = 100000;                  
      save = 100000;
      extended = true;                
      share = true;                   
      expireDuplicatesFirst = true;   
      ignoreDups = true;             
    };

    shellAliases = {
      tkS = "tmux kill-server";       
      tks = "tmux kill-session";
      tms = "tmux-sessionizer";
      f   = "cd $(fd --type directory | fzf)";
      lg  = "lazygit";
    };

    initContent = ''
      setopt hist_verify              
      setopt glob_dots                
      export KEYTIMEOUT=1             

      # tmux sets its own TERM, but preserve your explicit logic:
      if [[ -n "$TMUX" ]]; then export TERM=tmux-256color; else export TERM=xterm-256color; fi
    '';
  };

  # --- env / editor / locale ---
  home.sessionVariables = {
    EDITOR = "nvim";
    HIST_STAMPS = "yyyy/mm/dd";                 
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=245"; # mac
    LANG = "en_US.UTF-8";
  };

  # --- PATH (prepended) ---
  home.sessionPath =
    [ 
      "$HOME/go/bin" 
      "/opt/homebrew/bin"
      "$HOME/dotfiles/scripts"
      "/usr/local/bin"
    ];

  # --- mise ---   eval "$(mise activate zsh)"
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  # --- fzf ---
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;      # provides CTRL-T / CTRL-R / ALT-C key bindings + completion
  };

  # --- direnv ---
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # --- autojump ---
  programs.autojump.enable = true;
}
