{ config, pkgs, ... }:

{
  services.caddy = {
    enable     = true;
    configFile = /home/jack/dotfiles/Caddyfile;
  };
}
