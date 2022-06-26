#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./archfixe OR ./frametek
#            ├─ ./default.nix
#            └─ ./home.nix 
#

{ lib, inputs, nixpkgs, home-manager, nur, nix-colors, user, location, ... }:

let
  system = "x86_64-linux";                             	    # System architecture

  pkgs = import nixpkgs {
    inherit system nur;
    config.allowUnfree = true; # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  archfixe = lib.nixosSystem {
    # Desktop profile
    inherit system;
    specialArgs = { inherit inputs user location nix-colors nur; }; # Pass flake variable
    modules = [
      # Modules that are used.
      home-manager.nixosModules.home-manager
      ./archfixe
      ./configuration.nix

      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.extraSpecialArgs = { inherit user nix-colors nur; }; # Pass flake variable

        home-manager.users.${user} = {
          imports = [ (import ./home.nix) ];
        };
      }
    ];
  };
}
