{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fzf
    tmux
    lazygit
    tree
    wget
    vim
    nodejs
    fd
    jq
    bat
    mise
    nerd-fonts.fira-code
    tree-sitter
    unzip
    stylua
    lua-language-server
    pyright
    gopls
    templ
    vscode-langservers-extracted
    deno
    autojump
    go
  ];

  home.file = {
    ".gitconfig".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.gitconfig";
    ".tmux.conf".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.tmux.conf";
    ".vimrc".source      = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.vimrc";
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.wezterm.lua";
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "autojump" ];
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];
    shellAliases = {
      tks = "tmux kill-session";
      tms = "tmux-sessionizer";
      f = "cd $(fd --type directory | fzf)";
      lg = "lazygit";
    };
    history = {
      size = 100000;
      save = 100000;
      share = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
    };
    initExtra = ''
      bindkey -v
      export KEYTIMEOUT=1
      export LANG=en_US.UTF-8
      export EDITOR=nvim
      if [[ -n "$TMUX" ]]; then export TERM=tmux-256color; else export TERM=xterm-256color; fi
      eval "$(mise activate zsh)"
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.home-manager.enable = true;
}
