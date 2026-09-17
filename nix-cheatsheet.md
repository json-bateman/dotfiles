# Nix Cheatsheet

## Updating / Upgrading

`flake.lock` pins exact git commits for all inputs. `nixos-rebuild switch` always uses the lock file as-is — you must run `nix flake update` first to pull in newer commits (whether that's new packages on the same channel, or a full channel upgrade).

| Command | What it does |
|---|---|
| `nix flake update` | Updates all flake inputs (`flake.lock`) to their latest revisions. |
| `nix flake update <input>` | Updates just one input, e.g. `nix flake update nixpkgs`. |
| `sudo nixos-rebuild switch --flake ~/dotfiles/nix#<host>` | Apply system + home-manager config (NixOS). |
| `sudo nixos-rebuild test` | Apply without making it the boot default. |
| `sudo nixos-rebuild boot` | Apply on next reboot only. |
| `home-manager switch --flake ~/dotfiles/nix#<target>` | Apply home-manager config (macOS/Red Hat). |

To upgrade to a new channel, edit `flake.nix` first (e.g. `nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"`), then run the same commands above.

Note: `stateVersion` in `configuration.nix` and `home.nix` should **not** be changed on upgrades — it marks the version the system was first installed on and controls backwards-compatible state migrations.

## Garbage Collection

| Command | What it does |
|---|---|
| `nix-collect-garbage -d` | Deletes old user profile generations and garbage-collects. Most common one-liner. |
| `sudo nix-collect-garbage -d` | Same, but for system-wide NixOS generations. |
| `nix-collect-garbage --delete-older-than 14d` | Deletes generations older than 14 days instead of all. |
| `sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage` | Keeps the 3 most recent system generations, deletes the rest, then garbage-collects. |
| `nix store optimise` | Hard-links identical files across the store to save space. |
| `du -sh /nix/store` | Check current store size. |
| `df -h /nix` | Check free disk space on the store filesystem. |

## Generations and Rollback

| Command | What it does |
|---|---|
| `nixos-rebuild list-generations` | Lists system generations (NixOS), with current one marked. |
| `home-manager generations` | Lists home-manager generations (standalone macOS/Red Hat only). |
| `sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system` | Deletes all system generations except the current one. |
| `nix-env --delete-generations old` | Deletes all but the current generation of the user's profile. |
| `nix-env --delete-generations 30d` | Deletes generations older than 30 days. |
| `nixos-rebuild boot --flake ~/dotfiles/nix#<host>` | Remove extra generations from boot menu. |
| `sudo nixos-rebuild switch --rollback` | Roll back to the previous generation (NixOS). |
| Select an older entry at the systemd-boot menu | Boot into any previous generation without touching the current one. |

> On NixOS (`laptop`/`basement`), home-manager is applied as part of `nixos-rebuild switch` (`useGlobalPkgs`/`useUserPackages`), so there's no separate home-manager generation to manage — deleting system generations covers both.

## Flakes

| Command | What it does |
|---|---|
| `nix flake show` | Show outputs of a flake. |
| `nix flake check ~/dotfiles/nix` | Evaluate all outputs without building — catches config errors early. |
| `nix flake metadata ~/dotfiles/nix` | Show resolved input revisions and last-modified dates. |
| `nix build .#<output>` | Build a flake output. |
| `nix run .#<app>` | Run a flake app. |
| `nix develop` | Enter dev shell from flake. |
| `nix develop .#<shell>` | Enter a named dev shell. |

## One-Off Environments

| Command | What it does |
|---|---|
| `nix shell nixpkgs#<package>` | Temp shell with package available. |
| `nix run nixpkgs#<package>` | Run a package without installing. |
| `nix-shell -p <package>` | Legacy: drop into shell with package. |

## Inspecting Packages

| Command | What it does |
|---|---|
| `nix eval nixpkgs#<pkg>.version` | Check version in nixpkgs. |
| `nix path-info nixpkgs#<pkg>` | Show store path. |
| `nix show-derivation nixpkgs#<pkg>` | Show build recipe. |
| `nix-store -q --references <path>` | Show dependencies of a store path. |
| `nix-store -q --referrers <path>` | Show what depends on a store path. |

## Imperative Packages (nix-env)

| Command | What it does |
|---|---|
| `nix-env -qa 'pattern'` | Search available packages. |
| `nix-env -i <package>` | Install package. |
| `nix-env -e <package>` | Uninstall package. |
| `nix-env -u` | Upgrade all installed packages. |
| `nix-env -q` | List installed packages. |

## Channels (legacy, non-flake)

| Command | What it does |
|---|---|
| `nix-channel --list` | List channels. |
| `nix-channel --add <url> <name>` | Add a channel. |
| `nix-channel --remove <name>` | Remove a channel. |
| `nix-channel --update` | Update all channels. |

## Useful Flags

| Flag | Effect |
|---|---|
| `--dry-run` | Show what would happen without doing it. |
| `--verbose` / `-v` | More output. |
| `--impure` | Allow impure flake evaluation. |
| `--keep-going` | Continue on build failure. |
| `--no-sandbox` | Disable build sandboxing (use sparingly). |

## Setting Up a New Machine (check `new-webserver-setup.md`)

`hardware-configuration.nix` is machine-specific (generated by `nixos-generate-config` during install). To add a new host:

1. Run `nixos-generate-config` on the new machine
2. Create `hosts/<hostname>/` with the generated `hardware-configuration.nix`
3. Add a `hosts/<hostname>/configuration.nix` importing the hardware config + shared modules
4. Register it in `flake.nix` under `nixosConfigurations.<hostname>`
5. Set `system.stateVersion` to the NixOS version the machine was installed on

`nixos/common.nix` and `home/` are the portable parts. `hosts/` is intentionally machine-specific.

## Test on VM

| Command | What it does |
|---|---|
| `nixos-rebuild build-vm --flake .#vmtest` | Build and start a VM with your flake config. |
| `./result/bin/run-*-vm` | Run the output (result is built where you run the command). |
