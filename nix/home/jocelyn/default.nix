{ pkgs, config, inputs, lib, home-manager, nix-colors, ... }:

let
  inherit (lib) optional mkIf;
  inherit (builtins) map pathExists filter;
in
{
  imports = [
    ./cli
    ./rice
    ./desktop/i3
  ];

  systemd.user.startServices = "sd-switch";
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = "jocelyn";
    stateVersion = "22.11";
    homeDirectory = "/home/jocelyn";
    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 16;
      x11.enable = true;
    };
  };
} 
