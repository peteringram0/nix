{
  description = "Work and home";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {

      environment.systemPackages = [
        pkgs.vim
        pkgs.helix
        pkgs.ghostty
        pkgs.yazi
        pkgs.dockutil
        pkgs.stdenv
      ];

      nix.settings.experimental-features = "nix-command flakes";

      imports = [
       ./dock
      ];

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      nixpkgs.hostPlatform = "aarch64-darwin";

      # Fully declarative dock using the latest from Nix Store
      # local = {
      #   dock.enable = true;
      #   dock.entries = [
      #     { path = "/System/Applications/Facetime.app/"; }
      #   ];
      # };

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
