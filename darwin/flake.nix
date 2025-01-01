{
  description = "Work and home";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    # nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };
    # homebrew-bundle = {
    #   url = "github:homebrew/homebrew-bundle";
    #   flake = false;
    # };
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
      
      # nix-homebrew = {
      #   # Install Homebrew under the default prefix
      #   enable = true;

      #   # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
      #   enableRosetta = true;

      #   # User owning the Homebrew prefix
      #   # user = "yourname";

      #   # Optional: Declarative tap management
      #   # taps = {
      #   #   "homebrew/homebrew-core" = homebrew-core;
      #   #   "homebrew/homebrew-cask" = homebrew-cask;
      #   #   "homebrew/homebrew-bundle" = homebrew-bundle;
      #   # };

      #   # Optional: Enable fully-declarative tap management
      #   #
      #   # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
      #   mutableTaps = false;
      # };

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
