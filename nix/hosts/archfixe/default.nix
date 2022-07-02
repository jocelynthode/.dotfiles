{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ../common/global
    ../common/optional/gnome-keyring.nix
    ../common/optional/pipewire.nix
    ../common/optional/podman.nix
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
    ssh = {
      startAgent = true;
      askPassword = "";
    };
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  services.dbus.packages = [ pkgs.gcr ];

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
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

  system.stateVersion = "22.11";
}

