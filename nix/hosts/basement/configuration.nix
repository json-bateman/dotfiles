{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/webserver.nix
    ../../nixos/desktop.nix     # this box is beefy — give it the full GUI too
  ];

  networking.hostName = "basement";

  system.stateVersion = "26.05";
}
