{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    claude-code
    ripgrep
    tmux
    lazygit
    tree
    wget
    neovim
    vim
    nodejs
    fd
    jq
    bat
    gcc
    tree-sitter
    unzip
    stylua
    lua-language-server
    pyright
    gopls
    templ
    vscode-langservers-extracted
    go
  ];
  # fzf / mise / autojump come from their programs.* modules below

  home.file = {
    ".gitconfig".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.gitconfig";
    ".tmux.conf".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.tmux.conf";
    ".vimrc".source      = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.vimrc";
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.wezterm.lua";
  };

  home.activation.nvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${config.xdg.configHome}"
    run ln -sfn "${config.home.homeDirectory}/dotfiles/nvim" "${config.xdg.configHome}/nvim"
  '';

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;      # CTRL-T / CTRL-R / ALT-C + completion
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;      # replaces eval "$(mise activate zsh)"
  };

  programs.autojump.enable = true;

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true; # loaded after autosuggestions automatically

    oh-my-zsh = {
      enable = true;
      theme = "strug";
      plugins = [ "git" "virtualenv" ]; # autojump handled by programs.autojump
    };

    history = {
      path = "$HOME/.zhistory";
      size = 10000;
      save = 10000;
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
      # Assert vi mode here, since initContent runs after oh-my-zsh.
      bindkey -v

      setopt hist_verify
      setopt glob_dots
      export KEYTIMEOUT=1

      # tmux sets its own TERM, but preserve the explicit logic:
      if [[ -n "$TMUX" ]]; then export TERM=tmux-256color; else export TERM=xterm-256color; fi
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    HIST_STAMPS = "yyyy/mm/dd";                 # oh-my-zsh timestamp format
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=245";
  };

  home.sessionPath = [
    "$HOME/go/bin"
    "/opt/homebrew/bin"
    "$HOME/dotfiles/scripts"
    "/usr/local/bin"
  ];

  programs.home-manager.enable = true;
}
