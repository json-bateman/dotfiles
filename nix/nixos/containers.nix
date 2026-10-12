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
  # UserNS=auto picks each container's UID range from the "containers" entry in
  # /etc/subuid and /etc/subgid.
  users.groups.containers = { };
  users.users.containers = {
    isSystemUser = true;
    group        = "containers";
    subUidRanges = [ { startUid = 2147483647; count = 2147483648; } ];
    subGidRanges = [ { startGid = 2147483647; count = 2147483648; } ];
  };

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
      jsonbateman = {
        containerConfig = updating // {
          image        = "docker.io/jsonbateman/jsonbateman:latest";
          publishPorts = [ "127.0.0.1:3022:3022" ];
        };
      };

      basicauth = {
        containerConfig = updating // {
          image        = "docker.io/jsonbateman/basicauth:latest";
          publishPorts = [ "127.0.0.1:3033:3033" ];
          # Container root maps to an unprivileged host UID instead of real root.
          # :U chowns the volume to that UID, since the range can change between starts.
          userns       = "auto";
          volumes      = [ "basicauth-data:/app/data:U" ];
          environments = { BASICAUTH_PRODUCTION = "true"; };
          environmentFiles = [ "/etc/secrets/basicauth.env" ];
        };
      };

      kanban = {
        containerConfig = updating // {
          image        = "docker.io/jsonbateman/kanban:latest";
          publishPorts = [ "127.0.0.1:3044:3044" ];
          volumes      = [ "kanban-data:/app/data" ];
          environmentFiles = [ "/etc/secrets/kanban.env" ];
        };
      };

      crabspy = {
        containerConfig = updating // {
          image        = "docker.io/jsonbateman/crabspy:latest";
          publishPorts = [ "127.0.0.1:3012:3012" ];
          volumes      = [ "crabspy-data:/app/data" ];
          environmentFiles = [ "/etc/secrets/crabspy.env" ];
        };
      };

      pokermon = {
        containerConfig = updating // {
          image        = "docker.io/jsonbateman/poker_stats:latest";
          publishPorts = [ "127.0.0.1:7778:7777" ];
          volumes      = [ "pokermon-data:/data" ];
        };
      };

      dragonwilds = {
        containerConfig = updating // {
          image        = "docker.io/indifferentbroccoli/runescape-dragonwilds-server-docker:latest";
          publishPorts = [ "7777:7777/udp" ];
          volumes      = [ "dragonwilds-data:/home/steam/server-files" ];
          podmanArgs   = [ "--memory=12g" ];
          environmentFiles = [ "/etc/secrets/dragonwilds.env" ];
        };
      };
    };
  };
}
