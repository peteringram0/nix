{ config, pkgs, ... }:

{
  # This adds to GIT global config at /etc/gitconfig (works alongside my file at ~/.gitconfig)
  programs.git = {
    enable = true;
    config = {
      gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
    };
  };
}
