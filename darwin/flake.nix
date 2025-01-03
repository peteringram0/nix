{
  description = "Work and home";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
  };
  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util }:
  let
    configuration = { pkgs, ... }: {

      mac-app-util.darwinModules.default

      environment.systemPackages = [

        # Generic System
        pkgs.wget
        pkgs.curl
        pkgs.obsidian
        pkgs.discord
        pkgs.rectangle
        pkgs.starship
        pkgs.raycast
        pkgs.google-chrome
        pkgs.slack
        pkgs.spotify

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
        # pkgs.oh-my-zsh
        pkgs.zsh
        # pkgs.zsh-completions
        # pkgs.zsh-autocomplete
        # pkgs.zsh-autosuggestions
        # pkgs.zsh-syntax-highlighting
        # pkgs.zsh-history

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
        enableCompletion = true;
        # autocd = true;
        # syntaxHighlighting.enable = true;
        # autosuggestion.enable = true;
        # history = {
        #   size = 10000000;
        #   save = 10000000;
        #   ignoreSpace = true;
        #   ignoreDups = true;
        #   ignoreAllDups = true;
        #   expireDuplicatesFirst = true;
        #   extended = true;
        #   share = true;
        #   path = "/Users/pingram/.zsh_history";
        # };
      };

      system.activationScripts.postActivation.text = ''
        #!/usr/bin/env bash

        export HOME=/Users/pingram

        HELIX_DIR="$HOME/code/helix"

        # Check if the directory exists
        if [ -d "$HELIX_DIR" ]; then
          echo "Directory $HELIX_DIR already exists. Doing nothing."
        else
          echo "Directory $HELIX_DIR does not exist. Cloning repository..."
          mkdir -p "$HOME/code"
          git clone https://github.com/helix-editor/helix "$HELIX_DIR"
          cargo install --path "$HELIX_DIR/helix-term" --locked
        fi

        # Simple completion language server install
        cargo install --git https://github.com/estin/simple-completion-language-server.git

        # Set desktop wallpaper
        /usr/bin/osascript -e 'tell application "Finder" to set desktop picture to POSIX file "${self}/lost-man.jpg"'
       
        # Install Oh My Zsh unattended
        if sudo -u pingram sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
            echo "Oh My Zsh installed successfully."
        else
            echo "Failed to install Oh My Zsh."
        fi

        # NVM install
        export NVM_DIR="$HOME/.nvm"
        sudo -u pingram mkdir -p "$NVM_DIR"
        if wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash; then
            echo "NVM installed successfully."
        else
            echo "Failed to install NVM."
        fi

      '';

      system.defaults = {
        dock = {
          autohide = true;
          persistent-apps = [
            "/Applications/Nix Apps/Ghostty.app"
            "/Applications/Nix Apps/Google Chrome.app"
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
          "sublime-text"
          "microsoft-teams"
        ];
        # taps = [ ];
        brews = [
          "tailwindcss-language-server"
        ];
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

      # Trackpad speed (3 is max)
      system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;

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
