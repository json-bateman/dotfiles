{ config, pkgs, ... }:

{
  services.xserver.enable = true;

  services.displayManager.gdm.enable    = true;
  services.desktopManager.gnome.enable  = true;

  console.keyMap = "us";

  security.polkit.enable = true;

  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };

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
}
