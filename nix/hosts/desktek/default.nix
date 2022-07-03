{ pkgs, inputs, config, nix-colors, hostname, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.home-manager.nixosModule
    inputs.impermanence.nixosModules.impermanence

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

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/systemd"
      "/var/lib/bluetooth"
      "/etc/mullvad-vpn"
      "/var/log"
      "/etc/nixos"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.jocelyn = {
      directories = [
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        "Projects"
        "Liip"
        ".local/share/networkmanagement/certificates"
        "go"
	".config/fish"
	".local/share/fish"

        { directory = ".ssh"; mode = "0700"; }
        { directory = ".local/share/keyrings"; mode = "0700"; }
        ".local/share/Steam"
        ".steam"
        { directory = ".config/Signal"; mode = "0700"; }
        { directory = ".config/Bitwarden"; mode = "0700"; }
        { directory = ".kube"; mode = "0700"; }
        ".config/taxi"
        ".local/share/taxi"
        ".local/share/zebra"
        ".mozilla/firefox"
        ".config/discord"
        ".local/share/Mumble"
        ".config/Slack"
        ".config/spotify"
        ".config/kdeconnect"

	# TODO remove
	".dotfiles"
      ];
    };
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs nix-colors; }; # Pass flake variable
  };

  system.stateVersion = "22.11";
}

