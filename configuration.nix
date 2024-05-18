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

    # Rust overlay
    overlays = [
      (import "${fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz"}/overlay.nix")
    ];

  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Networking
  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    nameservers = ["1.1.1.1" "8.8.8.8"];
    hostName = "nixos";
  };
  
  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Xserver
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "gb";
      variant = "mac";
    };
    # videoDrivers = ["displaylink"]; doesnt work in the VM
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.peter = {
    isNormalUser = true;
    description = "peter";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPZxjYSlHvWpQ6VPPMwfJX8NfzQUXkqV8zhUg5cy3AIB"
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHYPVBU8Bf1c/fOV9pv1TmAAPDZsVojogSuAU+tAgmD1"
    ];
  };

  # users.users.peter.home.file.".ssh/config".text = ''
  #   # PI TEST
  #   Host *
  #     IdentityAgent ~/.1password/agent.sock
  # '';

  # Virtualization settings
  virtualisation.docker.enable = true;

  # needed for 1password
  # nixpkgs.config.allowUnfree = true;
  
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # Generic system
    wget
    openssh
    git
    screenfetch
    xclip
    _1password
    _1password-gui
    nerdfonts
    obsidian

    # Development
    unstable.helix
    unstable.zellij
    chezmoi
    oh-my-zsh
    zsh
    zsh-completions
    lazygit
    delta # pager for git
    bat
    yazi
    eza
    rustup
    gcc
    nil # .nix files
    starship
    docker
    httplz # serve alterntive
    flyctl
    ripgrep
    
    # ARM
    (lib.mkIf (pkgs.stdenv.hostPlatform.system == "aarch64-linux")
      gtkmm3 # needed for VMware Tools clipboard to work
    )

    # Intel
    (lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") 
      google-chrome
    )

    # RUST
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly

  ];

  # Enable the 1Password CLI, this also enables a SGUID wrapper so the CLI can authorize against the GUI app
  programs._1password = {
    enable = true;
  };

  # This adds to GIT global config at /etc/gitconfig (works alongside my file at ~/.gitconfig)
  programs.git = {
  enable = true;
     config = {
        gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
    };
  };

  # Enable the 1Passsword GUI with myself as an authorized user for polkit
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["peter"];
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = ["git"];
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
      X11Forwarding = true;
    };
  };

  # SSH
  programs.ssh = {
    forwardX11 = true;
    setXAuthLocation = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8000]; # httplz
    allowedUDPPorts = [8000]; # httplz
  };

  # DONT EDIT !!
  system.stateVersion = "23.11";

  system.autoUpgrade.enable = true;

}
