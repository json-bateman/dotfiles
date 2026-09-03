{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/gui.nix
    ../../nixos/webserver.nix
  ];

  networking.hostName = "basement";

  system.stateVersion = "26.05";
}
