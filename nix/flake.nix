{
  description = "Basic Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      # Track master to stay compatible with unstable nixpkgs.
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    mkHome = system: module:
      home-manager.lib.homeManagerConfiguration {
        pkgs    = import nixpkgs { inherit system; };
        modules = [ module ];
      };
  in
  {
    nixosConfigurations = {
      # Personal laptop: full desktop + home-manager.
      personal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/personal/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs    = true;
            home-manager.useUserPackages  = true;
            home-manager.users.jack       = import ./home/nixos/home.nix;
          }
        ];
      };

      # Headless server: system config only, kept minimal (no desktop, no home-manager).
      webserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/webserver/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      redhat = mkHome "x86_64-linux"   ./home/redhat/home.nix;
      mac    = mkHome "aarch64-darwin" ./home/mac/home.nix;
    };
  };
}
