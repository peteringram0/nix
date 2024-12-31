{ config, pkgs, ... }:

{
  # Xserver
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "mac";
    };
    # videoDrivers = ["displaylink"]; doesnt work in the VM
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };
}
