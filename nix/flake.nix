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
  let
    mkHome = system: module:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [ module ];
      };
  in
  {
    nixosConfigurations.basicnix =
      nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        modules = [
          nixos-lima.nixosModules.lima
          ./hosts/basicnix/configuration.nix
        ];
      };

    homeConfigurations = {
      lima   = mkHome "aarch64-linux"  ./home/lima/home.nix;
      nixos  = mkHome "x86_64-linux"   ./home/nixos/home.nix;
      centos = mkHome "x86_64-linux"   ./home/centos/home.nix;
      mac    = mkHome "aarch64-darwin" ./home/mac/home.nix;
    };
  };
}
