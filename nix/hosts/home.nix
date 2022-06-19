#
#  General Home-manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix *
#

{ config, lib, pkgs, user, nix-colors, ... }:

{ 
  imports = [
    nix-colors.homeManagerModule
  ];


  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Terminal
      htop              # Resource Manager
      bat
      fd
      ripgrep
      delta
      
      # Video/Audio
      feh               # Image Viewer
      vlc               # Media Player

      # Apps
      firefox           # Browser
      google-chrome     # Browser
      remmina           # XRDP & VNC Client

      # File Management
      rsync             # Syncer $ rsync -r dir1/ dir2/
      unzip             # Zip files

      autorandr
      flavours
      latte-dock
      spotify
    ];
    stateVersion = "22.11";
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      fonts = ["JetBrains Mono"];
      bars = [ ]; # use latte instead

      gaps = {
        inner = 10;
        outer = -3;
        smartGaps = false;
        smartBorders = "off";
      };
      startup = [
      { command = "autorandr --change --force"; always = true; notification = true; }
      ];
    };
  };

  services.picom = {
    enable = true;
    vSync = true;
    activeOpacity = "1.0";
    inactiveOpacity = "1.0";
    backend = "glx";
    fade = false;
    opacityRule = [ 
      "100:fullscreen"
      "85:class_g = 'Spotify'"
    ];
    
    shadow = true;
    shadowOpacity = "0.65";
    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'lattedock'"
    ];
    extraOptions = ''
      blur-method = "dual_kawase"
      blur-strength = 5
      blur-kern = "3x3box";
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-rounded-corners = true;
      detect-client-opacity = true;
    '';
  };

  programs = {
    home-manager.enable = true;
    fzf.enable = true;
    kitty = {
      enable = true;
      # settings = {
      #   background = "#${config.colorScheme.colors.base00}";
      #   foreground = "#${config.colorScheme.colors.base05}";
      #   selection_background = "#${config.colorScheme.colors.base05}";
      #   selection_foreground = "#${config.colorScheme.colors.base00}";
      #   url_color = "#${config.colorScheme.colors.base04}";
      #   cursor = "#${config.colorScheme.colors.base05}";
      #   active_border_color = "#${config.colorScheme.colors.base03}";
      #   inactive_border_color = "#${config.colorScheme.colors.base01}";
      #   active_tab_background = "#${config.colorScheme.colors.base00}";
      #   active_tab_foreground = "#${config.colorScheme.colors.base05}";
      #   inactive_tab_background = "#${config.colorScheme.colors.base01}";
      #   inactive_tab_foreground = "#${config.colorScheme.colors.base04}";
      #
      #   color0 = "#${config.colorScheme.colors.base01}";
      #   color1 = "#${config.colorScheme.colors.base08}";
      #   color2 = "#${config.colorScheme.colors.base0B}";
      #   color3 = "#${config.colorScheme.colors.base09}";
      #   color4 = "#${config.colorScheme.colors.base0D}";
      #   color5 = "#${config.colorScheme.colors.base0E}";
      #   color6 = "#${config.colorScheme.colors.base0C}";
      #   color7 = "#${config.colorScheme.colors.base06}";
      #   color8 = "#${config.colorScheme.colors.base02}";
      #   color9 = "#${config.colorScheme.colors.base12}";
      #   color10 = "#${config.colorScheme.colors.base14}";
      #   color11 = "#${config.colorScheme.colors.base13}";
      #   color12 = "#${config.colorScheme.colors.base16}";
      #   color13 = "#${config.colorScheme.colors.base17}";
      #   color14 = "#${config.colorScheme.colors.base15}";
      #   color15 = "#${config.colorScheme.colors.base07}";
      # };
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    fish = {
      enable = true;
      shellAliases = {
        cat = "bat";
        find = "fd";
        keti = "kubectl exec -ti";
      };
      shellAbbrs = {
        k = "kubectl";
        t = "terraform";
        n = "nvim";
      };
      shellInit = ''
        set -U fish_greeting
        set -gx fish_key_bindings fish_user_key_bindings

   
        if test -z (pgrep ssh-agent | string collect)
          eval (ssh-agent -c)
          set -Ux SSH_ASKPASS "/usr/bin/ksshaskpass"
        end
      '';
      functions = {
        fish_user_key_bindings = {
          body = ''
            fish_vi_key_bindings
            bind -M insert -m default jk backward-char force-repaint
          '';
        };
      };
      plugins = [
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "v5";
            sha256 = "14bdvrnd1v8ffac6fmpfs2cy4q19a4w02yrkc2xjiyqhj9lazgzy";
          };
        }
        { 
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
        {
          name = "colored_man_pages";
          src = pkgs.fetchFromGitHub {
            owner = "patrickf1";
            repo = "colored_man_pages.fish";
            rev = "f885c2507128b70d6c41b043070a8f399988bc7a";
            sha256 = "0ifqdbaw09hd1ai0ykhxl8735fcsm0x2fwfzsk7my2z52ds60bwa";
          };
        }
        {
          name = "autopair";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "autopair.fish";
            rev = "1.0.3";
            sha256 = "0lxfy17r087q1lhaz5rivnklb74ky448llniagkz8fy393d8k9cp";
          };
        }
      ];
    };
  };
}

