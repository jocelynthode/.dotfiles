{ pkgs, inputs, config, nix-colors, lollypops, hostname, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.home-manager.nixosModule

    ./hardware-configuration.nix
    ../common/global
    ../common/optional/gnome-keyring.nix
    ../common/optional/pipewire.nix
    ../common/optional/podman.nix
    ../common/optional/scanner.nix
    ../common/optional/steam.nix
    ../common/optional/xserver.nix
  ];

  networking = {
    networkmanager.enable = true;
    wireguard.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };

  programs = {
    gamemode = {
      enable = true;
    };
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  services.dbus.packages = [ pkgs.gcr ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  hardware = {
    bluetooth.enable = true;
    logitech.wireless.enable = true;
  };

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
    };
  };

  lollypops.deployment.local-evaluation = true;
  lollypops.deployment.config-dir = "/etc/nixos";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs nix-colors; }; # Pass flake variable
  };


  system.stateVersion = "22.11";
}

