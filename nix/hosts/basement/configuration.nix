{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/gui.nix
    ../../nixos/webserver.nix
    ../../nixos/wordle-bot.nix
  ];

  networking.hostName = "basement";

  # Broadcast hostname via mDNS so we can ssh jack@basement.local, a way in
  # from the home network when tailscale is down. 
  # nssmdns4 lets basement look up other machines' .local names too.
  services.avahi = {
    enable            = true;
    nssmdns4          = true;
    publish.enable    = true;
    publish.addresses = true;
  };

  # Disable WiFi — hardwired via ethernet; two NICs on the same subnet causes routing issues
  # Remove this later if we want to use the machine via wifi
  networking.networkmanager.unmanaged = [ "wlo1" ];

  swapDevices = [{
    device = "/var/lib/swapfile";
    size   = 8192; # 8 GB
  }];

  # This is for Runescape Dragonwilds... Terraria is also on this port
  networking.firewall.allowedUDPPorts = [ 7777 ];

  system.stateVersion = "26.05";
}
