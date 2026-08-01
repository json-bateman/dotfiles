{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fzf
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
    mise
    nerd-fonts.fira-code
    tree-sitter
    unzip
    deno
  ];

  home.file = {
    ".gitconfig".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.gitconfig";
    ".tmux.conf".source  = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.tmux.conf";
    ".vimrc".source      = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.vimrc";
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.wezterm.lua";
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.home-manager.enable = true;
}
