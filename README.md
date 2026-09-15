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

## MacOS - Initial Install

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

---

## Common Nix Commands

### Garbage collection (free disk space)

| Command | What it does |
|---|---|
| `nix-collect-garbage` | Deletes unreferenced store paths. Old generations still hold a reference, so run this after deleting old generations (below) for real savings. |
| `nix-collect-garbage -d` | Deletes old generations of the current user's profile *and* garbage-collects. Most common one-liner for reclaiming space. |
| `sudo nix-collect-garbage -d` | Same, but for the system-wide profile (NixOS generations) — needed since `nixos-rebuild switch` creates root-owned generations. |
| `nix-collect-garbage --delete-older-than 14d` | Deletes generations older than 14 days instead of all but the current one. |

### Listing and deleting old generations

| Command | What it does |
|---|---|
| `nixos-rebuild list-generations` | Lists system generations (NixOS only), with the currently booted one marked. |
| `home-manager generations` | Lists home-manager generations (standalone macOS/Red Hat only — see note below). |
| `sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system` | Deletes all system generations except the current one (NixOS). |
| `nix-env --delete-generations old` | Deletes all but the current generation of the calling user's profile. |
| `nix-env --delete-generations 30d` | Deletes generations older than 30 days from the calling user's profile. |
| `nixos-rebuild boot --flake ~/dotfiles/nix#laptop` | Remove extra generations from boot menu | 

> On NixOS (`laptop`/`basement`), home-manager is applied as part of `nixos-rebuild switch` (`useGlobalPkgs`/`useUserPackages`), so there's no separate home-manager generation to manage — deleting system generations covers both. The standalone `home-manager` command is still installed there for read-only inspection (`home-manager generations`, `home-manager news`), just not for switching.

### Store maintenance

| Command | What it does |
|---|---|
| `nix store optimise` | Hard-links identical files across the store to save space (safe, can be slow on a large store). |
| `nix store gc` | Newer-style garbage collection, equivalent to `nix-collect-garbage`. |
| `du -sh /nix/store` | Check current store size. |
| `df -h /nix` | Check free disk space on the filesystem backing the store. |

### Flake/channel bookkeeping

| Command | What it does |
|---|---|
| `nix flake update` | Updates all flake inputs (`flake.lock`) to their latest revisions. |
| `nix flake update <input>` | Updates just one input, e.g. `nix flake update nixpkgs`. |
| `nix flake check ~/dotfiles/nix` | Evaluates all flake outputs without building, catching config errors early. |
| `nix flake metadata ~/dotfiles/nix` | Shows resolved input revisions and last-modified dates. |

### Rollback

| Command | What it does |
|---|---|
| `sudo nixos-rebuild switch --rollback` | Rolls the system back to the previous generation (NixOS). |
| `sudo nix-env --rollback --profile /nix/var/nix/profiles/system` | Same, lower-level equivalent. |
| Select an older entry at the systemd-boot menu | Boots directly into any previous generation without touching the current one — useful if a rebuild leaves the system unbootable. |

### Test on VM

| Command | What it does |
|---|---|
| `nixos-rebuild build-vm --flake .#vmtest` | Builds and starts a virtual machine with your flake config |
| `./result/bin/run-\*-vm` | runs the output, result is built where you run the nixos-rebuild command |
