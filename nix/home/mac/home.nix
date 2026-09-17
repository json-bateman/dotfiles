{ config, pkgs, ... }:

{
  imports = [ ../common.nix ];

  home.username = "jack";
  home.homeDirectory = "/Users/jack";
  home.stateVersion = "26.05";

  home.sessionVariables.PROMPT_COLOR = "33";
}
