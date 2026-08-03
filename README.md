# dotfiles

Nix-managed configuration for macOS, NixOS, and Red Hat.

## Structure

```
nix/
  flake.nix
  home/
    common.nix        # shared packages, shell, editor config
    linux.nix         # linux-specific home config
    mac/home.nix
    redhat/home.nix
    nixos/home.nix
  nixos/
    common.nix        # shared NixOS system config
    webserver.nix     # caddy
  hosts/
    webserver/
      configuration.nix
      hardware-configuration.nix
```

---

## NixOS

Nix is the OS — no installation needed.

1. Clone this repo:
   ```bash
   git clone https://github.com/json-bateman/dotfiles ~/dotfiles
   ```

2. Apply the configuration:
   ```bash
   sudo nixos-rebuild switch --flake ~/dotfiles/nix#webserver --impure
   ```

This configures both the system and the user environment (via home-manager) in one command.

---

## macOS

```bash
bash ~/dotfiles/bootstrap-mac.sh
```

Installs Homebrew, Nix, and applies home-manager. GUI apps (WezTerm, Spotify, Chrome, Telegram, Docker) are installed via Homebrew Cask.

---

## Red Hat

```bash
sudo bash ~/dotfiles/bootstrap-redhat.sh
```

Sets up the system (packages, user, SSH hardening, mDNS), then prints next steps to install Nix and apply home-manager as your user.

---

## Updating

| Machine | Command |
|---|---|
| NixOS webserver | `sudo nixos-rebuild switch --flake ~/dotfiles/nix#webserver --impure` |
| macOS | `home-manager switch --flake ~/dotfiles/nix#mac` |
| Red Hat | `home-manager switch --flake ~/dotfiles/nix#redhat` |
