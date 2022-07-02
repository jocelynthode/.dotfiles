{ pkgs, ... }:
{
  imports = [
    ./kitty
    ./dunst
    ./rofi
    ./autorandr.nix
    ./gammastep.nix
    ./picom.nix
    ./polybar.nix
    ./screen-locker.nix
    ./xresources.nix
  ];

  home.packages = with pkgs; [
    xdotool
    xsel
  ];
}
