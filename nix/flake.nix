{
  description = "Basic Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    nixosConfigurations.webserver = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/webserver/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs    = true;
          home-manager.useUserPackages  = true;
          home-manager.users.jack       = import ./home/nixos/home.nix;
        }
      ];
    };

    homeConfigurations = {
      redhat = mkHome "x86_64-linux"   ./home/redhat/home.nix;
      mac    = mkHome "aarch64-darwin" ./home/mac/home.nix;
    };
  };
}
