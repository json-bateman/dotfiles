{ config, pkgs, lib, ... }:

{
  imports = [ ../common.nix ];

  home.username = "jack";
  home.homeDirectory = "/home/jack";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    spotify
    fuzzel
    networkmanagerapplet
    pavucontrol
    blueman
  ];

  home.file.".local/bin/hypr-keybinds" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      cat <<'EOF' | fuzzel --dmenu --width 60 --prompt "Keybinds  "
      SUPER + Return         Terminal (wezterm)
      SUPER + Space          App launcher (fuzzel)
      SUPER + Shift + S      Audio mixer (pavucontrol)
      SUPER + Q              Close window
      SUPER + V              Toggle floating
      SUPER + F              Fullscreen
      SUPER + M              Exit Hyprland
      SUPER + Arrow keys     Move focus between windows
      SUPER + H/J/K/L        Move focus between windows (vim-style)
      SUPER + ?              Show this list
      SUPER + 1..5           Switch workspace
      SUPER + Shift + 1..5   Move window to workspace
      EOF
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua"; # Hyprland >= 0.55 deprecated hyprlang (.conf) in favor of Lua

    settings = {
      mod = { _var = "SUPER"; };

      config = {
        general = {
          gaps_in     = 3;
          gaps_out    = 5;
          border_size = 1;
        };
        xwayland = {
          force_zero_scaling = true;
        };
        input = {
          kb_layout  = "us";
          kb_options = "caps:swapescape";
        };
      };

      animation = [
        { leaf = "windows";     enabled = true; speed = 3; bezier = "default"; style = "popin 80%"; }
        { leaf = "windowsMove"; enabled = true; speed = 3; bezier = "default"; }
        { leaf = "fade";        enabled = true; speed = 3; bezier = "default"; }
        { leaf = "workspaces";  enabled = false; }
      ];

      bind =
        [
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + RETURN"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wezterm")'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + SPACE"'')      (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("fuzzel")'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + SHIFT + S"'')  (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pavucontrol")'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + question"'')   (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("$HOME/.local/bin/hypr-keybinds")'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + Q"'')      (lib.generators.mkLuaInline "hl.dsp.window.close()") ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + M"'')      (lib.generators.mkLuaInline "hl.dsp.exit()") ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + V"'')      (lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + F"'')      (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()") ]; }

          { _args = [ (lib.generators.mkLuaInline ''mod .. " + LEFT"'')  (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "l" })'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + RIGHT"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "r" })'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + UP"'')    (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "u" })'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + DOWN"'')  (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "d" })'') ]; }

          { _args = [ (lib.generators.mkLuaInline ''mod .. " + H"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "l" })'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + J"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "d" })'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + K"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "u" })'') ]; }
          { _args = [ (lib.generators.mkLuaInline ''mod .. " + L"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "r" })'') ]; }
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
              hl.exec_cmd("nm-applet")
              hl.exec_cmd("blueman-applet")
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
      height   = 16;

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
