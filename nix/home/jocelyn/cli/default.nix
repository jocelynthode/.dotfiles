{ pkgs, ... }: {
  imports = [
    ./nvim
    ./bat.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./htop.nix
    ./kubernetes.nix
    ./lsd.nix
    ./ranger.nix
    ./rbw.nix
    ./taskwarrior.nix
  ];
  home.packages = with pkgs; [
    fd
    ripgrep
    delta
    rsync
    unzip
    terraform
    libnotify
  ];
}
