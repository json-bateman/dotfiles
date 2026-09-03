# dotfiles

Nix-managed configuration for macOS, NixOS, and Red Hat.

## NixOS

Nix is the OS — no installation needed.

1. Clone this repo (have to use nix-shell because nix doesn't ship with git):
   ```bash
   nix-shell -p git
   git clone https://github.com/json-bateman/dotfiles ~/dotfiles
   ```

2. Apply the configuration:
   ```bash
   sudo nixos-rebuild switch --flake ~/dotfiles/nix#basement
   ```

This configures both the system and the user environment (via home-manager) in one command.

---

## macOS - Initial Install

1. Download Homebrew (find on homebrew website)
2. Clone this repo
   ```bash
   git clone https://github.com/json-bateman/dotfiles ~/dotfiles
   ```
3. Run the bootstrap script
    ```bash
    bash ~/dotfiles/bootstrap-mac.sh
    ```

Installs Homebrew, Nix, and applies home-manager. GUI apps (WezTerm, Spotify, Chrome, Telegram, Docker) are installed via Homebrew Cask.

---

## Red Hat - Initial Install

```bash
sudo bash ~/dotfiles/bootstrap-redhat.sh
```

Sets up the system (packages, user, SSH hardening, mDNS), then prints next steps to install Nix and apply home-manager as your user.

---

## Updating

| Machine | Command |
|---|---|
| NixOS | `sudo nixos-rebuild switch --flake ~/dotfiles/nix#basement` |
| macOS | `home-manager switch --flake ~/dotfiles/nix#mac` |
| Red Hat | `home-manager switch --flake ~/dotfiles/nix#redhat` |
