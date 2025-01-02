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
        pkgs.rectangle
        pkgs.starship
        pkgs.raycast
        pkgs.google-chrome
        pkgs.slack

        # Companies
        pkgs.flyctl
        
        # Dev Tools        
        pkgs.ghostty
        pkgs.zellij
        pkgs.yazi
        pkgs.chezmoi
        pkgs.eza
        pkgs.bat
        pkgs.lazygit
        pkgs.delta
        pkgs.docker
        pkgs.ripgrep
        pkgs.fzf

        # Shell
        pkgs.oh-my-zsh
        pkgs.zsh
        pkgs.zsh-completions

        # Language Tools
        pkgs.cargo
        pkgs.cargo-tauri
        pkgs.trunk

        # Language Servers
        pkgs.nil
        pkgs.typescript-language-server
        pkgs.typos-lsp
        pkgs.svelte-language-server
        pkgs.superhtml
        pkgs.rust-analyzer
        pkgs.tailwindcss
        pkgs.astro-language-server
        pkgs.marksman
        pkgs.bash-language-server
      ];

      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = "nix-command flakes";

      fonts.packages = [
        pkgs.nerd-fonts.meslo-lg
      ];

      programs.zsh = {
        enable = true;
      };

      system.activationScripts.simpleCompletionLanguageServerInstall.text = ''
        #!/usr/bin/env bash
        cargo install --git https://github.com/estin/simple-completion-language-server.git
      '';

      system.defaults = {
        dock = {
          autohide = true;
          persistent-apps = [
            "/Applications/Nix Apps/Ghostty.app"
            "/Applications/Nix Apps/Chrome.app"
            "/Applications/Nix Apps/Obsidian.app"
            "/Applications/Nix Apps/Slack.app"
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
        casks = [
          "1password"
          "whatsapp"
        ];
        # taps = [ "fujiapple852/trippy" ];
        brews = [ "tailwindcss-language-server" ];
      };
           
      # imports = [
      #  ./dock
      # ];

      # Scroll direction
      system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

      # Show hidden files in finder
      system.defaults.NSGlobalDomain.AppleShowAllFiles = true;

      # Dark mode
      system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";

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
