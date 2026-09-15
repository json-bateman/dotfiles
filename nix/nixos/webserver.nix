{ config, pkgs, ... }:

{
  imports = [ ./containers.nix ];   # podman app containers behind Caddy

  # CLI for managing tunnels (login, create, route dns); the daemon itself
  # comes from services.cloudflared below.
  environment.systemPackages = [ pkgs.cloudflared ];

  services.caddy = {
    enable     = true;
    configFile = ../../Caddyfile-tunnel;   # tunnel-specific Caddyfile (legacy CentOS box uses ./Caddyfile)
  };

  # Cloudflare Tunnel: the box makes an OUTBOUND connection to Cloudflare's edge,
  # so no router port-forward and no open inbound ports are needed. All public
  # hostnames are routed here and handed to Caddy on localhost:80, which does the
  # real vhost routing / file serving. Cloudflare terminates public TLS.
  services.cloudflared = {
    enable = true;
    tunnels = {
      # Tunnel UUID from `cloudflared tunnel create webserver`.
      "180d87ed-a1df-4f6d-bc50-c4a58d0e0dc1" = {
        # Secret — NOT committed to the repo. Place the JSON on the box out-of-band
        # (or manage it with sops-nix / agenix) and point at its absolute path.
        #
        # The unit runs with DynamicUser=true and reads this via systemd
        # LoadCredential=, i.e. as root before dropping privileges. So the file
        # must be root-owned 0600 — do NOT chown it to a service user.
        credentialsFile = "/etc/cloudflared/webserver.json";

        # Every site lives on this one Caddy box, so send everything to Caddy.
        ingress = {
          "jsonbateman.com"   = "http://localhost:80";
          "*.jsonbateman.com" = "http://localhost:80";
          "alug.us"           = "http://localhost:80";
          "tsukinominori.com" = "http://localhost:80";
          "pokermon.club"     = "http://localhost:80";
          "api.pokermon.club" = "http://localhost:80";
          "crabspy.com"       = "http://localhost:80";
        };

        # Catch-all for anything that doesn't match above.
        default = "http_status:404";
      };
    };
  };

  system.autoUpgrade = {
    enable      = true;
    flake       = "github:json-bateman/dotfiles?dir=nix";  # builds .#basement via hostname
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
