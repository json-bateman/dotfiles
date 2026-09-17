{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/gui.nix
    ../../nixos/webserver.nix
  ];

  networking.hostName = "basement";

  # Disable WiFi — hardwired via ethernet; two NICs on the same subnet causes routing issues
  # Remove this later if we want to use the machine via wifi
  networking.networkmanager.unmanaged = [ "wlo1" ];

  swapDevices = [{
    device = "/var/lib/swapfile";
    size   = 8192; # 8 GB
  }];

  networking.firewall.allowedUDPPorts = [ 7777 ];

  system.stateVersion = "26.05";
}
