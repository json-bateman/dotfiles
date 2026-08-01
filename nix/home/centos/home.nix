{ config, pkgs, ... }:

{
  imports = [ ../linux.nix ];

  home.username = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion = "25.11";
}
