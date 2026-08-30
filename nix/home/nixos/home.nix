{ config, pkgs, lib, ... }:

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
    configType = "lua"; # Hyprland >= 0.55 deprecated hyprlang (.conf) in favor of Lua

    settings = {
      mod = { _var = "SUPER"; };

      config = {
        general = {
          gaps_in     = 5;
          gaps_out    = 10;
          border_size = 2;
        };
        input = {
          kb_layout  = "us";
          kb_options = "caps:swapescape";
        };
      };

      bind =
        [
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + RETURN"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wezterm")'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + Q"'')      (lib.generators.mkLuaInline "hl.dsp.window.close()") ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + M"'')      (lib.generators.mkLuaInline "hl.dsp.exit()") ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + V"'')      (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + F"'')      (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()") ]; }
        ]
        ++ (lib.concatLists (lib.genList
          (i:
            let ws = toString (i + 1); in [
              { _args = [ (lib.generators.mkLuaInline ''mod .. " + ${ws}"'')         (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = ${ws} })") ]; }
              { _args = [ (lib.generators.mkLuaInline ''mod .. " + SHIFT + ${ws}"'') (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = ${ws} })") ]; }
            ]
          )
          5));

      on = {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("waybar")
              hl.exec_cmd("swaybg -c '#1e1e2e'")
              hl.exec_cmd("hyprpolkitagent")
            end
          '')
        ];
      };
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
