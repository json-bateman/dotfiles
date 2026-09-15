{ config, ... }:

# Podman containers migrated from the CentOS box's quadlet units
# (/etc/containers/systemd/*.container). Same images, ports, and named
# volumes; volume DATA must be imported once out-of-band (podman volume
# export on the old box -> podman volume import here).
#
# Secrets are NOT committed: each container that needs one reads an env
# file from /etc/secrets/<name>.env (root-owned 0600, placed on the box
# out-of-band like the cloudflared credentials).

let
  # Mirrors quadlet's io.containers.autoupdate=registry: the nightly
  # podman-auto-update run re-pulls :latest and restarts the unit named
  # by PODMAN_SYSTEMD_UNIT.
  autoUpdate = {
    labels = { "io.containers.autoupdate" = "registry"; };
  };
in
{
  virtualisation.podman = {
    enable = true;
    autoPrune = {
      enable = true;
      dates  = "weekly";
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      basicauth = autoUpdate // {
        image       = "docker.io/jsonbateman/basicauth:latest";
        ports       = [ "127.0.0.1:3033:3033" ];
        volumes     = [ "basicauth-data:/app/data" ];
        environment = { BASICAUTH_PRODUCTION = "true"; };
        # BASICAUTH_COOKIE_STORE_SECRET_KEY
        environmentFiles = [ "/etc/secrets/basicauth.env" ];
      };

      crabspy = autoUpdate // {
        image   = "docker.io/jsonbateman/crabspy:latest";
        ports   = [ "127.0.0.1:3012:3012" ];
        volumes = [ "crabspy-data:/app/data" ];
        # CRABSPY_COOKIE_STORE_SECRET_KEY (was inline in the quadlet;
        # kept out of this public repo on purpose)
        environmentFiles = [ "/etc/secrets/crabspy.env" ];
      };

      pokermon = autoUpdate // {
        image   = "docker.io/jsonbateman/poker_stats:latest";
        ports   = [ "127.0.0.1:7777:7777" ];
        volumes = [ "pokermon-data:/data" ];
      };
    };
  };

  # podman auto-update needs to know which systemd unit owns each
  # container so it can restart it after pulling a new image.
  systemd.services = {
    podman-basicauth.environment.PODMAN_SYSTEMD_UNIT = "%n";
    podman-crabspy.environment.PODMAN_SYSTEMD_UNIT   = "%n";
    podman-pokermon.environment.PODMAN_SYSTEMD_UNIT  = "%n";

    podman-auto-update = {
      description   = "Update containers labeled io.containers.autoupdate";
      serviceConfig = {
        Type      = "oneshot";
        ExecStart = "${config.virtualisation.podman.package}/bin/podman auto-update";
      };
    };
  };

  systemd.timers.podman-auto-update = {
    wantedBy    = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "04:30";   # after system.autoUpgrade at 04:00
      Persistent = true;
    };
  };
}
