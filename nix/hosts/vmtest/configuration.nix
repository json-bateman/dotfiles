{ config, pkgs, ... }:

{
  imports = [
    ../laptop/hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/gui.nix
  ];

  networking.hostName = "vmtest";

  # VM has a fresh disk with no password set for jack; give it one so GDM can log in.
  users.users.jack.initialPassword = "vmtest";

  system.stateVersion = "26.05";
}
