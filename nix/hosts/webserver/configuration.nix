{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/webserver.nix
  ];

  system.stateVersion = "26.05";
}
