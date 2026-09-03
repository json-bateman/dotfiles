{
  description = "Basic Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    mkHome = system: module:
      home-manager.lib.homeManagerConfiguration {
        pkgs    = import nixpkgs { inherit system; config.allowUnfree = true; };
        modules = [ module ];
      };
  in
  {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs    = true;
            home-manager.useUserPackages  = true;
            home-manager.users.jack       = import ./home/nixos/home.nix;
          }
        ];
      };

      basement = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/basement/configuration.nix
          home-manager.nixosModules.home-manager
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
