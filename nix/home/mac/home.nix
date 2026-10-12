{ config, pkgs, ... }:

{
  imports = [ ../common.nix ../dev.nix ];

  home.username = "jack";
  home.homeDirectory = "/Users/jack";
  home.stateVersion = "26.05";
}
