{ pkgs, config }:

pkgs.writeShellApplication {
  name = "mic";
  checkPhase = "";

  runtimeInputs = with pkgs; [ pulseaudio coreutils gnugrep gawk ];

  text = ''
    get_mic_default() {
        pactl get-default-source
    }

    is_mic_muted() {
        mic_name="''$(get_mic_default)"
        pactl get-source-mute @DEFAULT_SOURCE@  | awk '{print ''$2}'
    }

    get_mic_status() {
        is_muted="''$(is_mic_muted)"

        if [ "''${is_muted}" = "yes" ]; then
            printf "%s\n" "%{F#${config.colorScheme.colors.base08}}%{F-}"
        else
            printf "%s\n" ""
        fi
    }

    listen() {
        get_mic_status

        LANG=EN; /nix/store/5y6l804z4gmngrxf0sbdpbf821rnc34c-pulseaudio-15.0/bin/pactl subscribe | while read -r event; do
            if printf "%s\n" "''${event}" | grep --quiet "source" || printf "%s\n" "''${event}" | grep --quiet "server"; then
                get_mic_status
            fi
        done
    }

    toggle() {
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
    }

    case "''$1" in
        --toggle)
            toggle
            ;;
        *)
            listen
            ;;
    esac
  '';
}

