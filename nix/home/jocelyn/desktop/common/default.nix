{ pkgs, ... }:
{
  imports = [
    ./bitwarden.nix
    ./discord.nix
    ./dragon.nix
    ./easyeffects
    ./firefox.nix
    ./gammastep.nix
    ./gtk.nix
    ./kdeconnect.nix
    ./kitty
    ./mpv.nix
    ./mumble.nix
    ./pavucontrol.nix
    ./playerctl.nix
    ./qt.nix
    ./screenshot.nix
    ./signal.nix
    ./slack.nix
    ./solaar.nix
    ./spotify.nix
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "ranger.desktop";
      "application/pdf" = "firefox.desktop";
    };
  };
  home.packages = with pkgs; [
    xdg-utils
    networkmanagerapplet
  ];
}
