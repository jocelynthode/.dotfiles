{ inputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/systemd"
      "/var/lib/bluetooth" # Store registered bluetooth devices
      "/etc/mullvad-vpn"
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
        ".config/pavucontrol-qt"
        ".cache/betterlockscreen"
        { directory = ".cache/rbw"; mode = "0700"; }
        ".local/state/wireplumber" # Store default sinks/sources

        # TODO remove
        ".dotfiles"
      ];
    };
  };

}
