{ var, ... }:{

# imports = [
#   ./ags
#   ./anyrun
#   ./hyprland
#   ./nixvim
#   ./rofi
#   ./swaync
#   ./waybar
#   ./wofi
#   ./yazi

#   ./btop.nix
#   ./git.nix
#   ./helix.nix
#   ./kitty.nix
#   ./stylix.nix
#   ./zathura.nix
# ];
imports = [
  <home-manager/nixos>
  ./waybar/default.nix
];

users.users.peter.isNormalUser = true;
home-manager.users.peter = { pkgs, ... }: {
  home.packages = [ pkgs.waybar ];
  programs.bash.enable = true;

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.11";
};


# programs.home-manager.users.peter = { pkgs, ... }: {
#   home = {
#     username = "peter";
#     homeDirectory = "/home/peter";  
#     stateVersion = "23.11";
#     # sessionVariables = {
#     #   BROWSER  = "firefox";
#     #   TERMINAL = "kitty";
#     # };
#   };
# };

}
