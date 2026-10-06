{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # claude-code intentionally omitted: managed by the native installer
    # (~/.local/bin/claude) so `claude update` can self-update it.
    ripgrep
    tmux
    lazygit
    gh
    tree
    wget
    neovim
    vim
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
    delve # dlv, used by nvim-dap-go
    vscode-langservers-extracted
    prettier   # nvim conform formatter
    typescript # tsserver for typescript-tools.nvim
    go
    golangci-lint
    templ
    sqlc
    air
    goose
    go-task # provides the `task` command
    gotools # goimports and other golang.org/x/tools commands
    nodejs # includes npm and npx
    python3
  ];
  # fzf / autojump come from their programs.* modules below

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

  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
    rootDirectory = "${config.home.homeDirectory}/.pyenv"; # keep existing installed versions
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
      # macOS path_helper (/etc/zprofile) moves system dirs like /usr/bin ahead of Nix,
      # and Nix's setup scripts skip re-running in shells that inherit their env (e.g. tmux).
      # Put the Nix profiles back in front; typeset -U drops the later duplicates.
      typeset -U path
      path=("$HOME/.nix-profile/bin" /nix/var/nix/profiles/default/bin $path)

      # Per-machine prompt color set via PROMPT_COLOR in each host's home config
      local _c="''${PROMPT_COLOR:-2}"
      local _git='$(git_prompt_info)%{$reset_color%}$(git_remote_status)'
      PROMPT="%F{$_c}╭─%n@%m %{$reset_color%}%{$fg[yellow]%}in %~ %{$reset_color%}''${_git}
%F{$_c}╰\$ %{$reset_color%}"

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
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "/opt/homebrew/bin"
    "$HOME/dotfiles/scripts"
    "/usr/local/bin"
  ];

  programs.home-manager.enable = true;
}
