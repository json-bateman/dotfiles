{ config, pkgs, ... }:

{
  imports = [ ../common.nix ];

  home.username    = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion  = "26.05";

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:swapescape" ];
    };
  };
}
