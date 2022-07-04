{ pkgs, ... }: {
  security = {
    pam.services.login.enableGnomeKeyring = true;
    pam.services.lightdm.enableGnomeKeyring = true;
  };
  environment.systemPackages = [ pkgs.gnome.gnome-keyring ];
  services.dbus.packages = with pkgs; [ gnome.gnome-keyring gcr ];
}
