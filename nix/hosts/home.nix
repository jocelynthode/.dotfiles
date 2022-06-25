#
#  General Home-manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix *
#

{ config, lib, pkgs, user, nix-colors, ... }:
let
  mod = "Mod4";
  alt = "Mod1";
  bluetooth = import ./polybar/scripts/bluetooth.nix {
    inherit pkgs config;
  };
  toggle-bluetooth = import ./polybar/scripts/toggle_bluetooth.nix {
    inherit pkgs;
  };

  mic= import ./polybar/scripts/mic.nix {
    inherit pkgs config;
  };
in
{ 

  imports = [
    nix-colors.homeManagerModule
  ];

  colorScheme = nix-colors.colorSchemes.gruvbox-dark-hard;

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      x11.enable = true;
    };


    packages = with pkgs; [
      # Terminal
      htop              # Resource Manager
      fd
      ripgrep
      delta
      libnotify
      xsel
      
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

      flavours
      spotify
      signal-desktop
      pavucontrol
      betterlockscreen
      networkmanager_dmenu
      rofi-power-menu
      rofi-pulse-select
      rofi-rbw
      networkmanagerapplet
      bluetooth
      toggle-bluetooth
      mic
      ponymix
      playerctl
    ];
    stateVersion = "22.11";
  };

  # Fix polybar not starting up
  systemd.user.services.polybar = {
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      bars = [ ]; # use kde panels instead
      workspaceOutputAssign = [
        { workspace = "1"; output = "DP4 eDP1 DP-2"; }
        { workspace = "2"; output = "DP4 eDP1 DP-2"; }
        { workspace = "3"; output = "DP4 eDP1 DP-2"; }
        { workspace = "4"; output = "DP4 eDP1 DP-2"; }
        { workspace = "5"; output = "DP4 eDP1 DP-2"; }
        { workspace = "6"; output = "eDP1 DP4 HDMI-0"; }
        { workspace = "7"; output = "eDP1 DP4 HDMI-0"; }
        { workspace = "8"; output = "eDP1 DP4 HDMI-0"; }
        { workspace = "9"; output = "eDP1 DP4 HDMI-0"; }
        { workspace = "10"; output = "eDP1 DP4 HDMI-0"; }
      ];
      window = {
        titlebar = false;
        border = 2;
        commands = [
          { command = "move to workspace 8"; criteria = { class = "Spotify"; }; }
        ];
      };
      colors = {
        focused = {
          border = "#${config.colorScheme.colors.base05}";
          background = "#${config.colorScheme.colors.base0D}";
          text = "#${config.colorScheme.colors.base00}";
          indicator= "#${config.colorScheme.colors.base0D}";
          childBorder = "#${config.colorScheme.colors.base0C}";
        };
        focusedInactive = {
          border = "#${config.colorScheme.colors.base01}";
          background = "#${config.colorScheme.colors.base01}";
          text = "#${config.colorScheme.colors.base05}";
          indicator= "#${config.colorScheme.colors.base03}";
          childBorder = "#${config.colorScheme.colors.base01}";
        };
        unfocused = {
          border = "#${config.colorScheme.colors.base01}";
          background = "#${config.colorScheme.colors.base00}";
          text = "#${config.colorScheme.colors.base05}";
          indicator= "#${config.colorScheme.colors.base01}";
          childBorder = "#${config.colorScheme.colors.base01}";
        };
        urgent = {
          border = "#${config.colorScheme.colors.base08}";
          background = "#${config.colorScheme.colors.base08}";
          text = "#${config.colorScheme.colors.base00}";
          indicator= "#${config.colorScheme.colors.base08}";
          childBorder = "#${config.colorScheme.colors.base08}";
        };
        placeholder = {
          border = "#${config.colorScheme.colors.base00}";
          background = "#${config.colorScheme.colors.base00}";
          text = "#${config.colorScheme.colors.base05}";
          indicator= "#${config.colorScheme.colors.base00}";
          childBorder = "#${config.colorScheme.colors.base00}";
        };
        background = "#${config.colorScheme.colors.base07}";
      };

      floating = {
        border = 0;
        criteria = [
          { window_role = "pop-up"; }
          { window_role = "task_dialog"; }
          { window_type = "notification"; }
          { window_type = "dialog"; }
          { class = "easyeffects"; }
          { class = "ProtonUp-Qt"; }
          { class = "mullvad vpn"; }
          { class = "Solaar"; }
          { class = "org.remmina.Remmina"; }
          { class = "Nm-connection-editor"; }
          { class = "Pavucontrol"; }
        ];
      };

      workspaceAutoBackAndForth = true;
      focus = {
        followMouse = true;
        newWindow = "focus";
      };


      gaps = {
        inner = 10;
        outer = -3;
        smartGaps = false;
        smartBorders = "off";
      };
      
      startup = [
      { command = "${pkgs.autorandr}/bin/autorandr --change --force"; always = true; notification = false; }
      { command = "${pkgs.dex}/bin/dex --autostart --environment i3"; notification = false; }
      ];
      keybindings = {
        "${mod}+Return" = "exec kitty";
        "${mod}+Shift+q" = "kill";
        "${mod}+x" = "[urgent=latest] focus";
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        "${mod}+Ctrl+Shift+l" = "move workspace to output right";
        "${mod}+Ctrl+Shift+h" = "move workspace to output left";
        "${mod}+Ctrl+Shift+j" = "move workspace to output down";
        "${mod}+Ctrl+Shift+k" = "move workspace to output up";
        "${mod}+${alt}+h" = "split h";
        "${mod}+${alt}+v" = "split v";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show drun -modi drun -theme launcher";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        "${mod}+a" = "focus parent";
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";
        "${mod}+Shift+1" = "move container to workspace number 1; workspace 1";
        "${mod}+Shift+2" = "move container to workspace number 2; workspace 2";
        "${mod}+Shift+3" = "move container to workspace number 3; workspace 3";
        "${mod}+Shift+4" = "move container to workspace number 4; workspace 4";
        "${mod}+Shift+5" = "move container to workspace number 5; workspace 5";
        "${mod}+Shift+6" = "move container to workspace number 6; workspace 6";
        "${mod}+Shift+7" = "move container to workspace number 7; workspace 7";
        "${mod}+Shift+8" = "move container to workspace number 8; workspace 8";
        "${mod}+Shift+9" = "move container to workspace number 9; workspace 9";
        "${mod}+Shift+0" = "move container to workspace number 10; workspace 10";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show menu -modi \"menu:rofi-power-menu\" -theme powermenu";
        "${mod}+r" = "mode resize";
      };
      assigns = {
        "2" = [
          { class = "Firefoxdeveloperedition"; }
        ];
        "3" = [
          { class = "Falendar"; }
          { class = "Kmail"; }
        ];
        "4" = [
          { class = "Steam"; }
        ];
        "7" = [
          { class = "Signal"; }
          { class = "Slack"; }
          { class = "Discord"; }
          { class = "Mumble"; }
        ];
        "9" = [
          { class = "Bitwarden"; }
        ];
      };
      modes = {
        resize = {
          "j" = "resize shrink width 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "l" = "resize shrink height 10 px or 10 ppt";
          "semicolon" = "resize grow width 10 px or 10 ppt";
          "Return" = "mode default";
          "Escape" = "mode default";
          "$mod+r" = "mode default";
        };
      };
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
  };

  services = {
    screen-locker = {
      enable = true;
      inactiveInterval = 15;
      lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
      xautolock.extraOptions = [
        "Xautolock.killer: systemctl suspend"
      ];
    };
    dunst = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome3.adwaita-icon-theme;
        size = "16x16";
      };
      settings = {
        global = {
          monitor = 0;
          geometry = "0x0-50+65";
          font = "JetBrainsMono Nerd Font 10";
          line_height = 4;
          frame_width = 2;
          padding = 16;
          horizontal_padding = 12;
          format = ''<b>%s</b>\n%b'';
          frame_color = "#${config.colorScheme.colors.base0C}FF";
          separator_color = "frame";
        };
        urgency_low = {
          background = "#${config.colorScheme.colors.base01}CC";
          foreground = "#${config.colorScheme.colors.base06}CC";
        };

        urgency_normal = {
          background = "#${config.colorScheme.colors.base01}CC";
          foreground = "#${config.colorScheme.colors.base06}CC";
        };

        urgency_critical = {
          background = "#${config.colorScheme.colors.base01}DD";
          foreground = "#${config.colorScheme.colors.base06}DD";
        };
      };
    };
    polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3GapsSupport = true;
        pulseSupport = true;
      };
      settings = {
            colors = {
              base00 = "#${config.colorScheme.colors.base00}";
              base01 = "#${config.colorScheme.colors.base01}";
              base02 = "#${config.colorScheme.colors.base02}";
              base03 = "#${config.colorScheme.colors.base03}";
              base04 = "#${config.colorScheme.colors.base04}";
              base05 = "#${config.colorScheme.colors.base05}";
              base06 = "#${config.colorScheme.colors.base06}";
              base07 = "#${config.colorScheme.colors.base07}";
              base08 = "#${config.colorScheme.colors.base08}";
              base09 = "#${config.colorScheme.colors.base09}";
              base0A = "#${config.colorScheme.colors.base0A}";
              base0B = "#${config.colorScheme.colors.base0B}";
              base0C = "#${config.colorScheme.colors.base0C}";
              base0D = "#${config.colorScheme.colors.base0D}";
              base0E = "#${config.colorScheme.colors.base0E}";
              base0F = "#${config.colorScheme.colors.base0F}";

              transparent-base00 = "#CC${config.colorScheme.colors.base00}";
            };

            bar = {
              fill = "⏽";
              empty = "⏽";
              indicator = "";
            };

            "bar/main" = {
              width = "100%";
              height = "24pt";
              radius = 0;
              background = ''''${colors.transparent-base00}'';
              foreground = ''''${colors.base07}'';
              padding = 2;
              line = {
                size = 3;
                color = ''''${colors.base00}'';
              };
              border.bottom = {
                size = 0;
                color = ''''${colors.base07}'';
              };

              module.margin = {
                left = 1;
                right = 1;
              };  

              modules = {
                left = "xworkspaces sep cpu memory fs";
                center = "player date";
                right = "battery eth wifi bluetooth sep mic volume brightness";
              };
              separator = "";
              dim-value = "1.0";
              tray-position = "none";
              font = ["JetBrainsMono Nerd Font:size=11;4" "feather:size=12;3"];
              enable-ipc = true;
            };

            settings = {
              screenchange.reload = false;
              compositing = {
                background = "source";
                foreground = "over";
                overline = "over";
                underline = "over";
                border = "over";
              };
              pseudo-transparency=false;
            };

            "module/date" = {
              type = "internal/date";
              internal = 5;
              date = "%a, %d %b %Y";
              time = "%H:%M:%S";
              label = "%date% at %time%";
              format = {
                text = "<label>";
                prefix = {
                  text = " ";
                  foreground = ''''${colors.base0E}'';
                };
              };
            };

            "module/xworkspaces" = {
              type = "internal/xworkspaces";

              label = {
                active = {
                  text = "%name%";
                  background = ''''${colors.base01}'';
                  underline = ''''${colors.base0C}'';
                  padding = 1;
                };
                occupied = {
                  text = "%name%";
                  padding = 1;
                };
                urgent = {
                  text = "%name%";
                  background = ''''${colors.base00}''; 
                  underline = ''''${colors.base08}'';
                  padding = 1;
                };
                empty = {
                  text = "%name%";
                  padding = 1;
                };
              };
            };
            
            "module/volume" = {
              type = "internal/pulseaudio";
              interval = 5; 
              format = {
                volume = "<ramp-volume> <bar-volume>";
                muted = {
                  text = "<label-muted>";
                  prefix = {
                    text = "";
                    foreground = ''''${colors.base08}'';
                  };
                };
              };

              label = {
                volume = "%percentage%%";
                muted = {
                    text = " Muted";
                    foreground = ''''${colors.base03}'';
                  };
              };

              ramp = {
                volume = {
                  text = ["" "" ""];
                  foreground = ''''${colors.base0D}'';
                };
                headphones = [""];
              };
              
              bar.volume = {
                  format = "%fill%%indicator%%empty%";
                  width = 11;
                  gradient = false;
                  foreground = [''''${colors.base0B}'' ''''${colors.base0B}'' ''''${colors.base09}'' ''''${colors.base09}'' ''''${colors.base08}''];

                  indicator = {
                    text = ''''${bar.indicator}'';
                    foreground = ''''${colors.base07}'';
                    font = 2;
                  };

                  fill = {
                    text = ''''${bar.fill}'';
                    font = 2;
                  };

                  empty = {
                    text = ''''${bar.empty}'';
                    font = 2;
                    foreground = ''''${colors.base01}'';
                  };
              };
            };

            "module/fs" = {
              type = "internal/fs";
              interval = 30;
              mount = ["/"];
              fixed.values = true;

              format = {
                mounted = {
                  text = "<label-mounted>";
                  prefix = {
                    text = "";
                    foreground = ''''${colors.base0C}'';
                  };
                };

                unmounted = {
                  text = "<label-unmounted>";
                  prefix = {
                    text = "";
                    foreground = ''''${colors.base08}'';
                  };
                };
              };
              label = {
                mounted = " %free%";
                unmounted = " %mountpoint%: NA";
              };
            };

            "module/memory" = {
              type = "internal/memory";
              interval = 5;
              format = {
                text = "<label>";
                prefix = {
                  text = ""; 
                  foreground = ''''${colors.base0D}'';
                };
              };
              label = "%percentage_used:2%%";
            };

            "module/cpu" = {
              type = "internal/cpu";
              interval = 1;

              format = {
                text = "<label>";
                prefix = {
                  text = ""; 
                  foreground = ''''${colors.base0A}'';
                };
              };

              label = " %percentage%%";
            };

            "network-base" = {
              type = "internal/network";
              interval = 2;
              format = {
                connected = "<label-connected>";
                disconnected = "<label-disconnected>";
              };
              label.disconnected = "";
            };

            "module/eth" = {
              "inherit" = "network-base";
              interface.type = "wired";
              label.connected = {
                text = "%{A1:${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu &:} %{F#${config.colorScheme.colors.base0C}} %downspeed%%{F-} %{F#${config.colorScheme.colors.base0D}}祝 %upspeed%%{F-}%{A}";
                foreground = ''''${colors.base0B}''; 
              };
              label.disconnected = {
                text = "%{A1:${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu &:} %{A}";
                foreground = ''''${colors.base03}''; 
              };
            };

            "module/wifi" = {
              "inherit" = "network-base";
              interface.type = "wireless";
              label.connected = {
                text = "%{A1:${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu &:}  %essid% %{F#${config.colorScheme.colors.base0C}} %downspeed%%{F-} %{F#${config.colorScheme.colors.base0D}}祝 %upspeed%%{F-}%{A}";
                foreground = ''''${colors.base0B}''; 
              };
              label.disconnected = {
                text = "%{A1:${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu &:}睊%{A}";
                foreground = ''''${colors.base03}''; 
              };
            };

            "module/bluetooth" = {
              type = "custom/script";
              exec = "/etc/profiles/per-user/jocelyn/bin/bluetooth";
              interval = 2;
              click-right = "/etc/profiles/per-user/jocelyn/bin/toggle_bluetooth";
            };

            "module/sep" = {
              type = "custom/text";
              content = {
                text = "|";
                foreground = ''''${colors.base03}'';
              };
            };

            "module/mic" = {
              type = "custom/script";
              exec = "/etc/profiles/per-user/jocelyn/bin/mic --listen";
              tail = true;
              click-left = "/etc/profiles/per-user/jocelyn/bin/mic --toggle &";
            };
            
            "module/player" = {
              type = "custom/script";
              interval = 3;
              format.prefix = {
                text = "阮 ";
                foreground =''''${colors.base0B}''; 
              };
              exec = {
                text = "${pkgs.playerctl}/bin/playerctl --player spotify metadata --format '{{artist}} - {{title}}  %{F#${config.colorScheme.colors.base03}}|%{F-}'";
                "if" = ''[[ "$(${pkgs.playerctl}/bin/playerctl --player spotify status)" = "Playing" ]]'';
              };
            };
          };
      script = "polybar main &";
    };
    easyeffects = {
      enable = true;
    };
    picom = {
      enable = true;
      experimentalBackends = true;
      blur = true;
      vSync = true;
      activeOpacity = "1.0";
      inactiveOpacity = "1.0";
      backend = "glx";
      fade = false;
      opacityRule = [ 
        "100:fullscreen"
        "100:name *= 'i3lock'"
        "85:class_g = 'Spotify'"
        "85:class_g *?= 'Rofi'"
      ];
      
      shadow = true;
      shadowOpacity = "0.65";
      shadowExclude = [
        "name = 'Notification'"
        "class_g = 'lattedock'"
      ];
      extraOptions = ''
        blur-method = "dual_kawase";
        blur-strength = 5;
        blur-kern = "3x3box";
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
      '';
    };
  };


  xdg.configFile."kitty/tab_bar.py" = {
    text = ''
      # pyright: reportMissingImports=false
      from kitty.fast_data_types import Screen
      from kitty.rgb import Color
      from kitty.tab_bar import (
          DrawData,
          ExtraData,
          TabBarData,
          as_rgb,
          draw_title,
      )
      from kitty.utils import color_as_int

      timer_id = None


      def calc_draw_spaces(*args) -> int:
          length = 0
          for i in args:
              if not isinstance(i, str):
                  i = str(i)
              length += len(i)
          return length


      def _draw_icon(screen: Screen, index: int, symbol: str = "") -> int:
          if index != 1:
              return 0

          fg, bg = screen.cursor.fg, screen.cursor.bg
          screen.cursor.fg = as_rgb(color_as_int(Color(255, 250, 205)))
          screen.cursor.bg = as_rgb(color_as_int(Color(60, 71, 77)))
          screen.draw(symbol)
          screen.cursor.fg, screen.cursor.bg = fg, bg
          screen.cursor.x = len(symbol)
          return screen.cursor.x


      def _draw_left_status(
          draw_data: DrawData,
          screen: Screen,
          tab: TabBarData,
          before: int,
          max_title_length: int,
          index: int,
          is_last: bool,
          extra_data: ExtraData,
      ) -> int:
          print(extra_data)
          if draw_data.leading_spaces:
              screen.draw(" " * draw_data.leading_spaces)

          draw_title(draw_data, screen, tab, index)
          trailing_spaces = min(max_title_length - 1, draw_data.trailing_spaces)
          max_title_length -= trailing_spaces
          extra = screen.cursor.x - before - max_title_length
          if extra > 0:
              screen.cursor.x -= extra + 1
              screen.draw("…")
          if trailing_spaces:
              screen.draw(" " * trailing_spaces)
          end = screen.cursor.x
          screen.cursor.bold = screen.cursor.italic = False
          screen.cursor.fg = 0
          screen.cursor.bg = 0
          if not is_last:
              screen.cursor.fg = (
                  as_rgb(color_as_int(Color(98, 114, 164)))
                  if tab.is_active
                  else as_rgb(color_as_int(Color(68, 71, 90)))
              )
              screen.draw(draw_data.sep)
          return end


      def draw_tab(
          draw_data: DrawData,
          screen: Screen,
          tab: TabBarData,
          before: int,
          max_title_length: int,
          index: int,
          is_last: bool,
          extra_data: ExtraData,
      ) -> int:
          _draw_icon(screen, index, symbol=" \uf120 ")
          _draw_left_status(
              draw_data,
              screen,
              tab,
              before,
              max_title_length,
              index,
              is_last,
              extra_data,
          )

          return screen.cursor.x
    '';
  };

  xdg.configFile."fish/conf.d/fzf-theme.fish" = {
    text = ''
      set -l color00 '#${config.colorScheme.colors.base00}'
      set -l color01 '#${config.colorScheme.colors.base01}'
      set -l color02 '#${config.colorScheme.colors.base02}'
      set -l color03 '#${config.colorScheme.colors.base03}'
      set -l color04 '#${config.colorScheme.colors.base04}'
      set -l color05 '#${config.colorScheme.colors.base05}'
      set -l color06 '#${config.colorScheme.colors.base06}'
      set -l color07 '#${config.colorScheme.colors.base07}'
      set -l color08 '#${config.colorScheme.colors.base08}'
      set -l color09 '#${config.colorScheme.colors.base09}'
      set -l color0A '#${config.colorScheme.colors.base0A}'
      set -l color0B '#${config.colorScheme.colors.base0B}'
      set -l color0C '#${config.colorScheme.colors.base0C}'
      set -l color0D '#${config.colorScheme.colors.base0D}'
      set -l color0E '#${config.colorScheme.colors.base0E}'
      set -l color0F '#${config.colorScheme.colors.base0F}'

      set -l FZF_NON_COLOR_OPTS

      for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
          if not string match -q -- "--color*" $arg
              set -a FZF_NON_COLOR_OPTS $arg
          end
      end

      set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
      " --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
      " --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
      " --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
    '';
  };

  xdg.configFile."easyeffects/input/Guitar.json" = {
    text = ''
      {
        "input": {
            "blocklist": [],
            "plugins_order": []
        }
      }
    '';
  };

  xdg.configFile."easyeffects/input/ImprovedMic.json" = {
    text = ''
      {
        "input": {
            "blocklist": [
                "Guitar Monitor"
            ],
            "gate": {
                "attack": 5.0,
                "detection": "RMS",
                "input-gain": 0.0,
                "knee": 9.0,
                "makeup": 0.0,
                "output-gain": 0.0,
                "range": -12.0,
                "ratio": 2.0,
                "release": 100.0,
                "stereo-link": "Average",
                "threshold": -18.0
            },
            "plugins_order": [
                "gate",
                "rnnoise"
            ],
            "rnnoise": {
                "input-gain": 0.0,
                "model-path": "",
                "output-gain": 0.0
            }
        }
      }
    '';
  };

  xdg.configFile."easyeffects/autoload/input/alsa_input.usb-Samson_Technologies_Samson_Meteor_Mic-00.analog-stereo:analog-input-mic.json" = {
    text = ''
      {
        "device": "alsa_input.usb-Samson_Technologies_Samson_Meteor_Mic-00.analog-stereo",
        "device-description": "Meteor condenser microphone Analog Stereo",
        "device-profile": "analog-input-mic",
        "preset-name": "ImprovedMic"
      }
    '';
  };

  xdg.configFile."easyeffects/autoload/input/alsa_input.usb-Hercules_Rocksmith_USB_Guitar_Adapter-00.mono-fallback:analog-input-mic.json" = {
    text = ''
      {
        "device": "alsa_input.usb-Hercules_Rocksmith_USB_Guitar_Adapter-00.mono-fallback",
        "device-description": "Rocksmith Guitar Adapter Mono",
        "device-profile": "analog-input-mic",
        "preset-name": "Guitar"
      }
    '';
  };


  xdg.configFile."networkmanager-dmenu/config.ini" = {
    text = ''
      [dmenu]
      dmenu_command = ${pkgs.rofi}/bin/rofi -dmenu -i -theme ~/.config/rofi/networkmenu.rasi
      rofi_highlight = True

      [dmenu_passphrase]
      obscure = True
    '';
  };

  xdg.configFile."rofi/colors.rasi" = {
    text = ''
      * {
        al:   #00000000;
        bg:   #${config.colorScheme.colors.base00}cc;
        bga:  #${config.colorScheme.colors.base01}cc;
        fg:   #${config.colorScheme.colors.base07}ff;
        ac:   #${config.colorScheme.colors.base08}ff;
        se:   #${config.colorScheme.colors.base0C}ff;
      }
    '';
  };

  xdg.configFile."rofi/launcher.rasi".source = ./rofi/themes/launcher.rasi;
  xdg.configFile."rofi/networkmenu.rasi".source = ./rofi/themes/networkmenu.rasi;
  xdg.configFile."rofi/powermenu.rasi".source = ./rofi/themes/powermenu.rasi;


  programs = {
    home-manager.enable = true;
    fzf.enable = true;
    rofi = {
      enable = true;
      font = "JetBrainsMono Nerd Font 12";
      terminal = "${pkgs.kitty}/bin/kitty";
      location = "center";
    };
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark"; 
      };
    };
    git = {
      enable = true;
      userName = "Jocelyn Thode";
      userEmail = "jocelyn.thode@gmail.com";
      extraConfig = {
        pull = {
          rebase = true;
        };
        diff = {
          colorMoved = "default";
        };
        merge = {
          conflictstyle = "diff3";
        };
        delta = {
          navigate = true;
          line-numbers = true;
          side-by-side = true;
        };
        core = {
          pager = "delta";
        };
        submodule = {
          recurse = true;
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
      };
    };
    htop = {
      enable = true;
      settings = {
        color_scheme = 6;
        cpu_count_from_one = 0;
        delay = 15;
        fields = with config.lib.htop.fields; [
          PID
          USER
          PRIORITY
          NICE
          M_SIZE
          M_RESIDENT
          M_SHARE
          STATE
          PERCENT_CPU
          PERCENT_MEM
          TIME
          COMM
        ];
        highlight_base_name = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;
        tree_view = 0;
      } // (with config.lib.htop; leftMeters [
        (bar "LeftCPUs2")
        (bar "CPU")
        (bar "Battery")
        (text "Blank")
        (text "Blank")
        (text "Blank")
        (graph "Memory")
        (text "NetworkIO")
        (text "DiskIO")
      ]) // (with config.lib.htop; rightMeters [
        (bar "RightCPUs2")
        (bar "Memory")
        (bar "Swap")
        (text "Blank")
        (text "Blank")
        (text "Blank")
        (graph "LoadAverage")
        (text "Uptime")
        (text "Systemd")
      ]);
    };

    kitty = {
      enable = true;
      font.name = "JetBrainsMono Nerd Font Mono";
      settings = {
        background_opacity  = "0.90";

        tab_bar_style  = "custom";
        tab_separator  = "\" ▎\"";
        tab_fade  = "0 0 0 0";
        tab_title_template  = "\"{fmt.fg._415c6d}{fmt.bg.default} ○ {index}:{f'{title[:6]}…{title[-6:]}' if title.rindex(title[-1]) + 1 > 13 else title}{' []' if layout_name == 'stack' else ''} \"";
        active_tab_title_template  = "\"{fmt.fg._83b6af}{fmt.bg.default} 綠{index}:{f'{title[:6]}…{title[-6:]}' if title.rindex(title[-1]) + 1 > 13 else title}{' []' if layout_name == 'stack' else ''} \"";
        tab_activity_symbol  = "none";
        tab_bar_edge  = "top";
        tab_bar_margin_height  = "0.0 0.0";
        active_tab_font_style  = "bold-italic";
        inactive_tab_font_style  = "normal";
        tab_bar_min_tabs  = "2";
        bell_on_tab  = "no";

        foreground = "#${config.colorScheme.colors.base05}";
        background = "#${config.colorScheme.colors.base00}";
        selection_background = "#${config.colorScheme.colors.base05}";
        selection_foreground = "#${config.colorScheme.colors.base00}";
        url_color = "#${config.colorScheme.colors.base04}";
        cursor = "#${config.colorScheme.colors.base05}";
        active_border_color = "#${config.colorScheme.colors.base03}";
        inactive_border_color = "#${config.colorScheme.colors.base01}";
        active_tab_background = "#${config.colorScheme.colors.base00}";
        active_tab_foreground = "#${config.colorScheme.colors.base05}";
        inactive_tab_background = "#${config.colorScheme.colors.base01}";
        inactive_tab_foreground = "#${config.colorScheme.colors.base04}";
        tab_bar_background = "#${config.colorScheme.colors.base00}";

        color0 = "#${config.colorScheme.colors.base01}";
        color1 = "#${config.colorScheme.colors.base08}";
        color2 = "#${config.colorScheme.colors.base0B}";
        color3 = "#${config.colorScheme.colors.base09}";
        color4 = "#${config.colorScheme.colors.base0D}";
        color5 = "#${config.colorScheme.colors.base0E}";
        color6 = "#${config.colorScheme.colors.base0C}";
        color7 = "#${config.colorScheme.colors.base06}";
        color8 = "#${config.colorScheme.colors.base02}";
        color9 = "#${config.colorScheme.colors.base08}";
        color10 = "#${config.colorScheme.colors.base0B}";
        color11 = "#${config.colorScheme.colors.base0A}";
        color12 = "#${config.colorScheme.colors.base0D}";
        color13 = "#${config.colorScheme.colors.base0E}";
        color14 = "#${config.colorScheme.colors.base0C}";
        color15 = "#${config.colorScheme.colors.base07}";
      };
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraPackages = with pkgs; [
        rnix-lsp
      ];

    };
    autorandr = {
      enable = true;
      hooks = {
        postswitch = {
          "notify-change" = "${pkgs.libnotify}/bin/notify-send -i display 'Display profile' -t 1000 \"$AUTORANDR_CURRENT_PROFILE\"";
          "change-background" = "${pkgs.feh}/bin/feh --bg-fill /home/${user}/Pictures/gruvbox/tropics.jpg";
        };
      };
      profiles = {
        "desktop" = {
          fingerprint = {
            DP-2 = "00ffffffffffff001e6d7f5bbb300800091d0104b53c22789f8cb5af4f43ab260e5054254b007140818081c0a9c0b300d1c08100d1cf28de0050a0a038500830080455502100001a000000fd003090e6e63c010a202020202020000000fc003237474c3835300a2020202020000000ff003930394e54435a46533736330a01ee02031a7123090607e305c000e606050160592846100403011f13565e00a0a0a029503020350055502100001a909b0050a0a046500820880c555021000000b8bc0050a0a055500838f80c55502100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a";
            HDMI-0 = "00ffffffffffff0009d1327f455400001018010380351e782e9de1a654549f260d5054a56b80d1c0317c4568457c6168617c953c3168023a801871382d40582c4500132a2100001e000000ff004a34453034383136534c300a20000000fd0018780f8711000a202020202020000000fc0042656e5120584c323431315a0a0171020323f15090050403020111121314060715161f202309070765030c00100083010000023a801871382d40582c4500132a2100001f011d8018711c1620582c2500132a2100009f011d007251d01e206e285500132a2100001f8c0ad08a20e02d10103e9600132a210000190000000000000000000000000000000000000000c7";
          };
          config = {
            DP-2 = {
              enable = true;
              crtc = 0;
              primary = true;
              position = "1920x0";
              mode = "2560x1440";
              gamma = "1.075:1.0:0.909";
              rate = "144.00";
            };
            HDMI-0 = {
              enable = true;
              crtc = 1;
              primary = false;
              position = "0x0";
              mode = "1920x1080";
              gamma = "1.075:1.0:0.909";
              rate = "60.00";
            };
          };
        };
      };
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

