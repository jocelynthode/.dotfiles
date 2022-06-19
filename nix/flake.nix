{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";                                   # NUR packages
    };

    nixgl = {                                                             #OpenGL 
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    base16-schemes = {
    	url = "github:Base24/base24-schemes-source";
    	flake = false;
    };
    nix-colors = {
    	url = "github:misterio77/nix-colors";
    	inputs.base16-schemes.follows = "base16-schemes";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nur, nixgl, nix-colors, ... }:
  let
  	user = "jocelyn";
    location = "$HOME/.setup";
  in {
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager nur nix-colors user location;
      }
    );
  }; 
}
