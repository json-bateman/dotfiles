{
  description = "Basic Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      # Track master to stay compatible with unstable nixpkgs.
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, home-manager-stable, ... }:
  let
    mkHome = system: module:
      home-manager.lib.homeManagerConfiguration {
        pkgs    = import nixpkgs { inherit system; };
        modules = [ module ];
      };
  in
  {
    nixosConfigurations = {
      laptop = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/configuration.nix
          home-manager-stable.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs    = true;
            home-manager.useUserPackages  = true;
            home-manager.users.jack       = import ./home/nixos/home.nix;
          }
        ];
      };

      basement = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/basement/configuration.nix
          home-manager-stable.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs    = true;
            home-manager.useUserPackages  = true;
            home-manager.users.jack       = import ./home/nixos/home.nix;
          }
        ];
      };
    };

    homeConfigurations = {
      redhat = mkHome "x86_64-linux"   ./home/redhat/home.nix;
      mac    = mkHome "aarch64-darwin" ./home/mac/home.nix;
    };
  };
}
