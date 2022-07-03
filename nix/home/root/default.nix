{ pkgs, config, inputs, lib, home-manager, nix-colors, ... }: {

  imports = [
    ../jocelyn/rice
    ../jocelyn/cli/nvim
    ../jocelyn/cli/bat.nix
    ../jocelyn/cli/fish.nix
  ];

  systemd.user.startServices = "sd-switch";
  programs = {
    home-manager.enable = true;
  };

  home = {
    username = "root";
    stateVersion = "22.11";
    homeDirectory = "/root";
  };
} 
