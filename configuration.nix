{ config, pkgs, ... }:

{
    
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
      };
      permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
    overlays = [ # Rust Overlay
      (import "${fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz"}/overlay.nix")
    ];
  };

  system = {
    stateVersion = "24.11"; # DONT EDIT
    autoUpgrade.enable = true;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    # System
    ./modules/networking.nix
    ./modules/audio.nix
    ./modules/xserver.nix

    # User
    ./modules/users.nix
    ./modules/locale.nix

    # Programs
    ./modules/packages.nix
    ./programs/1_password.nix
    ./programs/git.nix
    ./programs/zsh.nix
    # ./programs/polybar.nix
    
  ];

  fonts.packages = [
    pkgs.nerd-fonts.meslo-lg
  ];

  # https://www.reddit.com/r/NixOS/comments/15y3v6p/how_do_you_automate_deletion_of_old_generations/
  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   delete_generations = "+5"; # Option added by nix-gc-env
  # };

  # # Virtualization settings
  # virtualisation.docker.enable = true;

}
