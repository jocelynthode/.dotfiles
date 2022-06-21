#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   └─   └─ configuration.nix *
#

{ config, lib, pkgs, inputs, user, location, nix-colors, ... }:

{

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    
    loader = {                                  # For legacy boot:
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 5;                 # Limit the amount of configurations
      };
      timeout = 5;                              # Grub auto select time
    };
  };

  users.users.${user} = {                   # System User
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "scanner" ];
    shell = pkgs.fish;                       # Default shell
    openssh.authorizedKeys.keys = [];
  };

  time.timeZone = "Europe/Zurich";        # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {                 # Extra locale settings that need to be overwritten
      LC_TIME = "fr_CH.UTF-8";
      LC_MONETARY = "fr_CH.UTF-8";
      LC_MEASUREMENT = "fr_CH.UTF-8";
      LC_COLLATE = "fr_CH.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";	                    # or us/azerty/etc
  };

  security.rtkit.enable = true;
  sound = {                                 # ALSA sound enable
    enable = true;
    mediaKeys = {                           # Keyboard Media Keys (for minimal desktop)
      enable = true;
    };
  };

  fonts.fonts = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    jetbrains-mono
    noto-fonts
    font-awesome                            # Icons
    corefonts                               # MS
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "JetBrainsMono"
      ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [           # Default packages install system-wide
      vim
      git
      killall
      wget
      curl
      gcc
      fzf

      libsForQt5.full
    ];
  };

  hardware = {
    bluetooth.enable = true;
  };

  programs = {
    dconf.enable = true;
    steam.enable = true;
  };

  services = {
    sshd.enable = true;
    pipewire = {                            # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {                                 # In case, multi monitor support
      enable = true;
      layout = "us";
      xkbVariant = "altgr-intl";
      displayManager = {
          sddm.enable = true;
          defaultSession = "plasma+i3";
          session = [
              {
                  manage = "desktop";
                  name = "plasma+i3";
                  start = ''exec env KDEWM=${pkgs.i3-gaps}/bin/i3 ${pkgs.plasma-workspace}/bin/startplasma-x11'';
              }
          ];
      };
      desktopManager = {
        xterm.enable = false;
        plasma5.enable = true;
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

  nixpkgs.overlays = [                          # This overlay will pull the latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz"; 
          sha256 = "1bhjalv1c0yxqdra4gr22r31wirykhng0zglaasrxc41n0sjwx0m";
        };}
      );
    })
  ];

  nix = {                                   # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;               # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.

  system = {                                # NixOS settings
    autoUpgrade = {                         # Allow auto update
      enable = true;
    channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.11";
  };

  networking.networkmanager.enable = true;
}


