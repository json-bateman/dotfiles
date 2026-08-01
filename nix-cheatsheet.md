# Nix Cheatsheet

## Packages (nix-env / imperative)

```sh
nix-env -qa 'pattern'          # search available packages
nix-env -i <package>           # install package
nix-env -e <package>           # uninstall package
nix-env -u                     # upgrade all installed packages
nix-env -u <package>           # upgrade specific package
nix-env -q                     # list installed packages
nix-env --rollback             # roll back last install/upgrade
nix-env --list-generations     # list profile generations
nix-env --switch-generation N  # switch to generation N
```

## Channels

```sh
nix-channel --list                        # list channels
nix-channel --add <url> <name>            # add a channel
nix-channel --remove <name>              # remove a channel
nix-channel --update                      # update all channels
```

## Nix Store / Garbage Collection

```sh
nix-store --gc                # garbage collect unreferenced store paths
nix-collect-garbage           # same as above
nix-collect-garbage -d        # also delete old profile generations
nix-store -q --references <path>   # show dependencies of a store path
nix-store -q --referrers <path>    # show what depends on a store path
```

## Flakes

```sh
nix flake show                    # show outputs of a flake
nix flake update                  # update flake.lock
nix flake update <input>          # update a specific input
nix build .#<output>              # build a flake output
nix run .#<app>                   # run a flake app
nix develop                       # enter dev shell from flake
nix develop .#<shell>             # enter a named dev shell
```

## Home Manager (if using flake-based setup)

```sh
home-manager switch               # apply home.nix config
home-manager switch --flake .#    # apply from flake
home-manager generations          # list generations
home-manager expire-generations '-30 days'  # clean old generations
```

## NixOS (if applicable)

```sh
sudo nixos-rebuild switch         # apply system config
sudo nixos-rebuild switch --flake .#<host>
sudo nixos-rebuild test           # apply without making it the boot default
sudo nixos-rebuild boot           # apply on next reboot only
nixos-version                     # show current system version
```

## Nix Shell (one-off environments)

```sh
nix shell nixpkgs#<package>       # temp shell with package available
nix run nixpkgs#<package>         # run a package without installing
nix-shell -p <package>            # legacy: drop into shell with package
```

## Inspecting Packages

```sh
nix eval nixpkgs#<pkg>.version    # check version in nixpkgs
nix path-info nixpkgs#<pkg>       # show store path
nix show-derivation nixpkgs#<pkg> # show build recipe
```

## Useful Flags

| Flag | Effect |
|------|--------|
| `--dry-run` | Show what would happen without doing it |
| `--verbose` / `-v` | More output |
| `--no-sandbox` | Disable build sandboxing (use sparingly) |
| `--impure` | Allow impure flake evaluation |
| `--keep-going` | Continue on build failure |
