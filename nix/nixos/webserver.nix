{ config, pkgs, ... }:

{
  services.caddy = {
    enable     = true;
    configFile = ../../Caddyfile;   # repo-root Caddyfile, relative to this file → part of the flake
  };

  system.autoUpgrade = {
    enable      = true;
    flake       = "github:json-bateman/dotfiles?dir=nix";  # builds .#webserver via hostname
    flags       = [ "--refresh" ];                          # re-fetch the flake ref each run
    dates       = "04:00";                                  # daily (systemd.time format)
    randomizedDelaySec = "45min";                           # avoid an exact-time stampede
    operation   = "switch";                                 # apply immediately
    persistent  = true;                                     # catch up if the box was off
    allowReboot = false;                                    # never auto-reboot
  };

  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 30d";
  };
}
