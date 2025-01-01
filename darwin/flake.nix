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

        # Generic System
        pkgs.wget
        pkgs.obsidian
        pkgs.discord
        
        pkgs.ghostty
        pkgs.yazi
        pkgs.chezmoi
        pkgs.eza
        pkgs.bat
        pkgs.rectangle
        pkgs.starship
        pkgs.raycast
        pkgs.lazygit
        pkgs.delta
        pkgs.docker
        pkgs.ripgrep
        pkgs.google-chrome

        pkgs.oh-my-zsh
        pkgs.zsh
        pkgs.zsh-completions
       
        pkgs.cargo

        pkgs.nil
      ];

      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh = {
        enable = true;
      };

      system.defaults = {
        dock = {
          autohide = true;
          persistent-apps = [
            "/Applications/Nix Apps/Ghostty.app"
          ];
          show-recents = false;
          tilesize = 20;
          mineffect = null;
        };
      };

      homebrew = {
        enable = true;
        caskArgs.no_quarantine = true;
        global.brewfile = true;
        masApps = { };
        casks = [ "1password" "whatsapp" ];
        # taps = [ "fujiapple852/trippy" ];
        # brews = [ "trippy" ];
      };
           
      # imports = [
      #  ./dock
      # ];

      # Scroll direction
      system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

      # Show hidden files in finder
      system.defaults.NSGlobalDomain.AppleShowAllFiles = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      nixpkgs.hostPlatform = "aarch64-darwin";
      
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
      ];
    };
  };
}
