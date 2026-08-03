# New Webserver Setup

## 1. Generate hardware config on the new machine

```bash
nixos-generate-config
```

## 2. Add host to dotfiles

Copy `/etc/nixos/hardware-configuration.nix` into the repo:

```
hosts/webserver2/hardware-configuration.nix
```

Create `hosts/webserver2/configuration.nix`:

```nix
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/common.nix
    ../../nixos/webserver.nix
  ];

  system.stateVersion = "26.05"; # version the machine was installed on
}
```

## 3. Register in flake.nix

```nix
nixosConfigurations.webserver2 = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hosts/webserver2/configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs   = true;
      home-manager.useUserPackages = true;
      home-manager.users.jack      = import ./home/nixos/home.nix;
    }
  ];
};
```

## 4. Apply

Push dotfiles, clone on the new machine, then run:

```bash
sudo nixos-rebuild switch --flake ~/dotfiles/nix#webserver2 --impure
```
