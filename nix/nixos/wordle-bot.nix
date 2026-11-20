{ pkgs, ... }:

# Secrets are NOT committed: DISCORD_TOKEN / CLIENT_ID live in
# /etc/secrets/wordle-bot.env
{
  systemd.services.wordle-bot = {
    description = "Wordle scoreboard Discord bot";
    wantedBy    = [ "multi-user.target" ];
    wants       = [ "network-online.target" ];
    after       = [ "network-online.target" ];

    serviceConfig = {
      User             = "jack";
      WorkingDirectory = "/home/jack/wordle-bot";   # scores.json is written here
      EnvironmentFile  = "/etc/secrets/wordle-bot.env";
      ExecStart        = "${pkgs.nodejs_24}/bin/node src/bot.ts";
      Restart          = "always";
      RestartSec       = 10;
    };
  };
}
