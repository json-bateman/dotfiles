{ config, pkgs, ... }:

# home.username / home.homeDirectory are set per Mac in flake.nix (mkMac).
{
  imports = [ ../common.nix ../dev.nix ];

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono   # provides "JetBrainsMono Nerd Font"
  ];

  # Caps Lock -> Escape, Right Command -> Right Control.
  # hidutil mappings don't survive a reboot, so reapply at every login.
  launchd.agents.key-remap = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/hidutil" "property" "--set"
        (builtins.toJSON {
          UserKeyMapping = [
            { HIDKeyboardModifierMappingSrc = 30064771129; HIDKeyboardModifierMappingDst = 30064771113; } # 0x700000039 Caps Lock -> 0x700000029 Escape
            { HIDKeyboardModifierMappingSrc = 30064771303; HIDKeyboardModifierMappingDst = 30064771300; } # 0x7000000E7 Right Cmd -> 0x7000000E4 Right Ctrl
          ];
        })
      ];
      RunAtLoad = true;
    };
  };
}
