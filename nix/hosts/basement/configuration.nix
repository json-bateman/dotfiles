{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/gui.nix
    ../../nixos/webserver.nix
  ];

  networking.hostName = "basement";

  swapDevices = [{
    device = "/var/lib/swapfile";
    size   = 8192; # 8 GB
  }];

  networking.firewall.allowedUDPPorts = [ 7777 ];

  system.stateVersion = "26.05";
}
