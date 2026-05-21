{ config, pkgs, ... }:

{
  home.username = "lima";
  home.homeDirectory = "/home/lima.guest";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    lazygit
    bat
  ];

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Jack Trusler";
        email = "jtrus93@gmail.com";
      };

      init.defaultBranch = "main";

      alias = {
        co = "checkout";
        br = "branch";
        st = "status";
      };
    };
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.tmux.enable = true;
}
