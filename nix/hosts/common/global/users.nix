{ pkgs, config, lib, home-manager, ... }: {

  users.users.jocelyn = {
    isNormalUser = true;
    shell = pkgs.fish;
    initialPassword = "nixos";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "camera"
    ]
    ++ (lib.optional config.networking.networkmanager.enable "networkmanager")
    ++ (lib.optional config.hardware.sane.enable "scanner")
    ++ (lib.optional config.virtualisation.docker.enable "docker")
    ++ (lib.optional config.virtualisation.podman.enable "podman");
  };

  services.geoclue2.enable = true;


  home-manager.users.jocelyn = {
    imports = builtins.attrValues (import ../../../modules/home-manager) ++ [
      ../../../home/jocelyn
    ];
  };

}
