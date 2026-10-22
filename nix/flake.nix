{
  description = "Basic Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Only used for the Go toolchain, which moves faster than stable
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, quadlet-nix, ... }:
  let
    unstableFor = system: import nixpkgs-unstable { inherit system; };

    mkHome = system: module:
      home-manager.lib.homeManagerConfiguration {
        pkgs    = import nixpkgs { inherit system; config.allowUnfree = true; };
        extraSpecialArgs.unstable = unstableFor system;
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
            home-manager.extraSpecialArgs.unstable = unstableFor "x86_64-linux";
            home-manager.users.jack       = { ... }: {
              imports = [ ./home/nixos/home.nix ./home/dev.nix ];
              home.sessionVariables.PROMPT_COLOR = "196"; # neon red
            };
          }
        ];
      };

      basement = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/basement/configuration.nix
          quadlet-nix.nixosModules.quadlet
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs    = true;
            home-manager.useUserPackages  = true;
            home-manager.users.jack       = { ... }: {
              imports = [ ./home/nixos/home.nix ];
              home.sessionVariables.PROMPT_COLOR = "39"; # neon blue
            };
          }
        ];
      };

      vmtest = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vmtest/configuration.nix
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
