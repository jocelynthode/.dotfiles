{ config, pkgs, ... }:

let
  inherit (config.colorscheme) colors;
in
rec {

  home.packages = with pkgs; [
    kubectl
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
      ls = "${pkgs.lsd}/bin/lsd -l";
      tree = "${pkgs.lsd}/bin/lsd --tree";
      find = "${pkgs.fd}/bin/fd";
      keti = "${pkgs.kubectl}/bin/kubectl exec -ti";
    };
    shellAbbrs = {
      k = "kubectl";
      t = "terraform";
      n = "nvim";
    };
    shellInit = ''
      set -U fish_greeting
      set -gx fish_key_bindings fish_user_key_bindings
    '';
    interactiveShellInit = ''
      any-nix-shell fish | source
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

  xdg.configFile."fish/conf.d/fzf-theme.fish" = {
    text = ''
      set -l color00 '#${colors.base00}'
      set -l color01 '#${colors.base01}'
      set -l color02 '#${colors.base02}'
      set -l color03 '#${colors.base03}'
      set -l color04 '#${colors.base04}'
      set -l color05 '#${colors.base05}'
      set -l color06 '#${colors.base06}'
      set -l color07 '#${colors.base07}'
      set -l color08 '#${colors.base08}'
      set -l color09 '#${colors.base09}'
      set -l color0A '#${colors.base0A}'
      set -l color0B '#${colors.base0B}'
      set -l color0C '#${colors.base0C}'
      set -l color0D '#${colors.base0D}'
      set -l color0E '#${colors.base0E}'
      set -l color0F '#${colors.base0F}'

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
}
