{
  security = {
    pam.services.lightdm.enableGnomeKeyring = true;
  };
  services.gnome.gnome-keyring.enable = true;
}
