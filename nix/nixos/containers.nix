{ ... }:

# Podman app containers, managed by quadlet-nix (real quadlet units, same
# format as the .container files podman documents upstream).
#
# Secrets are NOT committed: each container that needs one reads an env
# file from /etc/secrets/<name>.env
let
  # AutoUpdate=registry opts the container into podman-auto-update:
  updating = { autoUpdate = "registry"; };
in
{
  virtualisation.podman.autoPrune = {
    enable = true;
    dates  = "weekly";
  };

  virtualisation.quadlet = {
    enable = true;

    autoUpdate = {
      enable   = true;
      calendar = "*:30";   # hourly at :30, clear of system.autoUpgrade at 04:00
    };

    containers = {
      basicauth = {
        containerConfig = updating // {
          image        = "docker.io/jsonbateman/basicauth:latest";
          publishPorts = [ "127.0.0.1:3033:3033" ];
          volumes      = [ "basicauth-data:/app/data" ];
          environments = { BASICAUTH_PRODUCTION = "true"; };
          # BASICAUTH_COOKIE_STORE_SECRET_KEY
          environmentFiles = [ "/etc/secrets/basicauth.env" ];
        };
      };

      crabspy = {
        containerConfig = updating // {
          image        = "docker.io/jsonbateman/crabspy:latest";
          publishPorts = [ "127.0.0.1:3012:3012" ];
          volumes      = [ "crabspy-data:/app/data" ];
          # CRABSPY_COOKIE_STORE_SECRET_KEY (kept out of this public repo)
          environmentFiles = [ "/etc/secrets/crabspy.env" ];
        };
      };

      pokermon = {
        containerConfig = updating // {
          image        = "docker.io/jsonbateman/poker_stats:latest";
          publishPorts = [ "127.0.0.1:7777:7777" ];
          volumes      = [ "pokermon-data:/data" ];
        };
      };
    };
  };
}
