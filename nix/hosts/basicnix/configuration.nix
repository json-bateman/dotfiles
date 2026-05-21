{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  services.lima.enable = true;

  networking.hostName = "basicnix";

  time.timeZone = "America/New_York";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.openssh.enable = true;

  users.users.lima = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    curl
    wget
    htop
    go
    nodejs
  ];

  virtualisation.podman.enable = true;

  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  fileSystems."/boot" = {
    device = lib.mkForce "/dev/vda1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  system.stateVersion = "25.11";
}
