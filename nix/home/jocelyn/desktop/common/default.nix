{ pkgs, ... }:
{
  imports = [
    ./bitwarden.nix
    ./discord.nix
    ./dragon.nix
    ./easyeffects
    ./firefox.nix
    ./gnome-keyring.nix
    ./gtk.nix
    ./kdeconnect.nix
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
  ];
}
