{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/gui.nix
  ];

  networking.hostName = "laptop";

  system.stateVersion = "26.05";
}
