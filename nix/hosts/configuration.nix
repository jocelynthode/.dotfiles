#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   └─   └─ configuration.nix *
#

{ config, lib, pkgs, inputs, user, location, nix-colors, ... }:
let
  feathers = import ./feathers/default.nix {
    inherit lib;
    fetchurl = pkgs.fetchurl;
  };
in
{

  boot = {
    # Boot options
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      # For legacy boot:
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Limit the amount of configurations
      };
      timeout = 5; # Grub auto select time
    };
  };

  # See https://github.com/NixOS/nixpkgs/commit/15d761a525a025de0680b62e8ab79a9d183f313d 
  systemd.targets.network-online.wantedBy = pkgs.lib.mkForce [ ]; # Normally ["multi-user.target"]
  systemd.services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce [ ]; # Normally ["network-online.target"]

  users.users.${user} = {
    # System User
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "scanner" ];
    shell = pkgs.fish; # Default shell
    openssh.authorizedKeys.keys = [ ];
  };

  time.timeZone = "Europe/Zurich"; # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      # Extra locale settings that need to be overwritten
      LC_TIME = "fr_CH.UTF-8";
      LC_MONETARY = "fr_CH.UTF-8";
      LC_MEASUREMENT = "fr_CH.UTF-8";
      LC_COLLATE = "fr_CH.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us"; # or us/azerty/etc
  };

  security = {
    rtkit.enable = true;
    pam.services.lightdm.enableGnomeKeyring = true;
  };
  sound = {
    # ALSA sound enable
    enable = true;
    mediaKeys = {
      # Keyboard Media Keys (for minimal desktop)
      enable = true;
    };
  };

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      # Fonts
      carlito # NixOS
      vegur # NixOS
      jetbrains-mono
      noto-fonts
      font-awesome # Icons
      corefonts # MS
      material-design-icons
      material-icons
      feathers
      (nerdfonts.override {
        # Nerdfont Icons override
        fonts = [
          "JetBrainsMono"
        ];
      })
    ];
  };

  environment = {
    variables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "nvim";
      GTK_THEME = "Adwaita:dark";
    };
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
    };
    systemPackages = with pkgs; [
      # Default packages install system-wide
      vim
      git
      killall
      wget
      curl
      gcc
      fzf
      pulseaudio
      pamixer
      gnome3.gnome-keyring
      blueberry
      any-nix-shell
      exa
    ];
  };

  hardware = {
    bluetooth.enable = true;
  };

  programs = {
    dconf.enable = true;
    steam.enable = true;
    nm-applet.enable = true;
    ssh = {
      startAgent = true;
      askPassword = "";
    };
  };

  services = {
    dbus.packages = [ pkgs.gcr ];
    gnome.gnome-keyring.enable = true;
    pipewire = {
      # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    xserver = {
      # In case, multi monitor support
      enable = true;
      layout = "us";
      xkbVariant = "altgr-intl";
      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          enable = true;
          greeters.gtk.theme = {
            package = pkgs.gnome3.adwaita-icon-theme;
            name = "Adwaita";
          };
          greeters.gtk.iconTheme = {
            package = pkgs.papirus-icon-theme;
            name = "Papirus";
          };
          greeters.gtk.cursorTheme = {
            package = pkgs.gnome3.adwaita-icon-theme;
            name = "Adwaita";
          };
        };
        setupCommands = ''
          ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --off
          ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --primary --mode 2560x1440 --pos 1920x0 --right-of HDMI-0 
        '';
      };
      desktopManager = {
        xterm.enable = false;
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          dex
        ];
      };
    };
  };

  nixpkgs.overlays = [
    # This overlay will pull the latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: {
          src = builtins.fetchTarball {
            url = "https://discord.com/api/download?platform=linux&format=tar.gz";
            sha256 = "1bhjalv1c0yxqdra4gr22r31wirykhng0zglaasrxc41n0sjwx0m";
          };
        }
      );
    })
  ];

  nix = {
    # Nix Package Manager settings
    settings = {
      auto-optimise-store = true; # Optimise syslinks
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes; # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.config.allowUnfree = true; # Allow proprietary software.

  system = {
    # NixOS settings
    autoUpgrade = {
      # Allow auto update
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.11";
  };

  networking.networkmanager.enable = true;
}


