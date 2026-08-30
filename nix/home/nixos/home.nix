{ config, pkgs, ... }:

{
  imports = [ ../common.nix ];

  home.username = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    spotify
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = [ ",preferred,auto,1" ];

      input = {
        kb_layout  = "us";
        kb_options = "caps:swapescape";
      };

      general = {
        gaps_in     = 5;
        gaps_out    = 10;
        border_size = 2;
      };

      "exec-once" = [
        "waybar"
        "swaybg -c '#1e1e2e'"
        "hyprpolkitagent"
      ];

      "$terminal" = "wezterm";
      "$mainMod"  = "SUPER";

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, Q, killactive"
        "$mainMod, M, exit"
        "$mainMod, V, togglefloating"
        "$mainMod, F, fullscreen"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
      ];
    };
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer    = "top";
      position = "top";
      height   = 30;

      modules-left   = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [ "pulseaudio" "battery" "tray" ];

      "hyprland/workspaces" = { };
      clock                 = { format = "{:%H:%M  %a %b %d}"; };
      pulseaudio            = { format = "{volume}% {icon}"; format-muted = "muted"; };
      battery               = { format = "{capacity}% {icon}"; };
      tray                  = { icon-size = 16; };
    };
  };
}
