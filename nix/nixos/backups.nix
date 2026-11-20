{ ... }:

{
  services.restic.backups.server-state = {
    initialize = true;

    repository = "s3:https://s3.us-east-005.backblazeb2.com/jsonbateman-backups";

    passwordFile    = "/etc/secrets/restic-password";
    environmentFile = "/etc/secrets/restic-env";

    paths = [
      "/var/lib/containers/storage/volumes"
      "/etc/secrets"
      "/var/www/html"
      "/etc/cloudflared"
    ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];

    createWrapper = true;
  };
}
