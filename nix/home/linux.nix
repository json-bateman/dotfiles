{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  programs.zsh = {
    oh-my-zsh.theme = "murilasso";
    initContent = ''
      export PATH="$HOME/dotfiles/scripts:$PATH"
      export PATH="/usr/local/bin:$PATH"
    '';
  };
}
