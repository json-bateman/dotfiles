{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/desktop.nix
  ];

  networking.hostName = "nixos";

  system.stateVersion = "26.05";
}
