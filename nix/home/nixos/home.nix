{ config, pkgs, ... }:

{
  imports = [ ../linux.nix ];

  home.username = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion = "25.11";

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:swapescape" ];
    };
  };
}
