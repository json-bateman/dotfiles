{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session.command =
      "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
  };

  # Boot status lines ("[ OK ] Started …", "A start job is running …") print to
  # tty1, the same tty as tuigreet, so late ones land on top of the login screen.
  # They're still in the journal (journalctl -b).
  systemd.settings.Manager.ShowStatus = "no";

  console.keyMap = "us";

  security.polkit.enable = true;

  hardware.bluetooth = {
    enable       = true;
    powerOnBoot  = true;
  };
  services.blueman.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };

  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono   # provides "JetBrainsMono Nerd Font"
  ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
    wezterm
    swaybg
    hyprpolkitagent
    google-chrome
  ];
}
