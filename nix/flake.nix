{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";
    nix-colors.url = "github:misterio77/nix-colors";
    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, nix-colors, flake-utils, hardware, ... }:
    let
      inherit (builtins) attrValues mapAttrs;
      inherit (nixpkgs.lib) genAttrs systems nixosSystem;
      forAllSystems = genAttrs systems.flakeExposed;
      system = "x86_64-linux";                             	    # System architecture
    in
    rec {
      overlays = {
        default = import ./overlay { inherit inputs; };
        nur = nur.overlay;
      };

      packages = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = attrValues overlays;
          config.allowUnfree = true;
        }
      );

      nixosConfigurations = {
        archfixe = nixosSystem {
          inherit system;
          pkgs = packages.${system};
          specialArgs = {
            inherit inputs system home-manager nix-colors;
          };
          modules = [
            ./hosts/archfixe
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = { inherit inputs nix-colors; }; # Pass flake variable

              home-manager.users.jocelyn = {
                imports = [ 
                  ./home/jocelyn 
                ];
              };
            }

          ];
        };
      };
    };
}
