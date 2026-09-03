# Adding a New NixOS Host

Run these on the **already-installed, booted machine**. Each host = shared modules
+ its own `hardware-configuration.nix` (machine-specific; Nix does **not**
auto-detect it).

Shared modules to compose per host:
- `nixos/common.nix`   — baseline (boot, locale, user, ssh, zsh, base pkgs)
- `nixos/webserver.nix`— server role (Caddy, autoUpgrade, gc, cloudflared)
- `nixos/gui.nix`      — full GUI (GNOME, pipewire, printing, firefox)

## Steps (example host: `basement`)

```bash
# 1. get the repo (installer/base image may lack git: `nix-shell -p git`)
git clone https://github.com/json-bateman/dotfiles ~/dotfiles

# 2. use this machine's real hardware config (install already made it)
mkdir -p ~/dotfiles/nix/hosts/basement
cp /etc/nixos/hardware-configuration.nix \
   ~/dotfiles/nix/hosts/basement/hardware-configuration.nix
```

Create `nix/hosts/basement/configuration.nix`:

```nix
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/webserver.nix   # server role
    ../../nixos/gui.nix         # optional GUI
  ];

  networking.hostName = "basement";  # must match the flake attr (autoUpgrade uses it)
  system.stateVersion = "26.05";     # release installed on — never bump
}
```

Register in `nix/flake.nix` under `nixosConfigurations` (add the home-manager block only if this host should get jack's dotfiles — see `laptop`):

```nix
basement = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [ ./hosts/basement/configuration.nix ];
};
```

Stage, switch, then commit (might have to add SSH key to github):

```bash
git -C ~/dotfiles add -A
sudo nixos-rebuild switch --flake ~/dotfiles/nix#basement
git -C ~/dotfiles commit -am "add basement" && git -C ~/dotfiles push
```

Future rebuilds: `sudo nixos-rebuild switch --flake ~/dotfiles/nix#basement`
