{ config, pkgs, ... }:

{
  imports = [ ../linux.nix ];

  home.username = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    spotify
  ];

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:swapescape" ];
    };
  };
}
