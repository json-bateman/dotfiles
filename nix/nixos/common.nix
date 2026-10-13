{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  programs.zsh.enable = true;

  users.users."jack" = {
    isNormalUser = true;
    description  = "Jack";
    extraGroups  = [ "networkmanager" "wheel" ];
    shell        = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 30d";
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    jq
    curl
    wget
  ];

  services.openssh.enable = true;

  # Without resolved, tailscale overwrites /etc/resolv.conf with 100.100.100.100
  # and all DNS breaks whenever MagicDNS can't answer. With it, tailscale only
  # handles tailnet names and everything else uses the network's DNS.
  services.resolved = {
    enable = true;
    settings.Resolve = {
      MulticastDNS = false;   # mDNS is Avahi's job, and only basement runs it
      LLMNR        = false;
    };
  };

  services.tailscale.enable = true;
  services.tailscale.authKeyFile = "/etc/tailscale/authkey";

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ 41641 ];
}
