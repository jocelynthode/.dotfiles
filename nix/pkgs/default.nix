{ pkgs }: {
  # My wallpaper collection
  wallpapers = pkgs.callPackage ./wallpapers { };

  # Packages with an actual source
  feathers = pkgs.callPackage ./feathers { };

  # Personal scripts
  rofi-pulse = pkgs.callPackage ./rofi-pulse { };
  toggle-bluetooth = pkgs.callPackage ./toggle-bluetooth { };
}

