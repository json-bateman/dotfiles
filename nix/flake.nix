{
  description = "Basic Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixos-lima = {
      url = "github:nixos-lima/nixos-lima";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-lima, home-manager, ... }:
  {
    nixosConfigurations.basicnix =
      nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        modules = [
          nixos-lima.nixosModules.lima
          ./hosts/basicnix/configuration.nix
        ];
      };

    homeConfigurations.lima =
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
        };

        modules = [
          ./home/lima/home.nix
        ];
      };
  };
}
