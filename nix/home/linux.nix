{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  home.packages = with pkgs; [
    go
    gcc
  ];

  programs.zsh = {
    oh-my-zsh.theme = "murilasso";
    initExtra = ''
      export PATH="$HOME/dotfiles/scripts:$PATH"
      export PATH="/usr/local/bin:$PATH"
    '';
  };
}
