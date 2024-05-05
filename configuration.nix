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
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Networking
  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    # nameservers = ["1.1.1.1" "8.8.8.8"];
    hostName = "nixos";
    # defaultGateway = "192.168.0.1";
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
    layout = "gb";
    xkbVariant = "mac";
    # videoDrivers = ["displaylink"]; doesnt work in the VM
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
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
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPZxjYSlHvWpQ6VPPMwfJX8NfzQUXkqV8zhUg5cy3AIB"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHYPVBU8Bf1c/fOV9pv1TmAAPDZsVojogSuAU+tAgmD1"
    ];
  };

  # users.users.peter.home.".ssh/config".text = ''
  #   # PI TEST
  #   Host *
  #     IdentityAgent ~/.1password/agent.sock
  # '';

  # Virtualization settings
  virtualisation.docker.enable = true;

  # needed for 1password
  # nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    unstable.helix
    openssh
    screenfetch
    git
    chezmoi
    oh-my-zsh
    zsh
    zsh-completions
    xclip
    gtkmm3 # neded for vmware tools clipboard to work
    lazygit
    delta # pager for git
    unstable.zellij
    bat
    yazi
    eza

    rustup
    gcc

    # pkg-config
    # openssl.dev
    nerdfonts
    # glib
    # glib.dev
    # gobject-introspection
    _1password
    _1password-gui
    # google-chrome
    nil # .nix files
    starship
    obsidian
    docker

    (if pkgs.system != "aarch64-linux" then google-chrome else null)
    
  ];

  # Enable the 1Password CLI, this also enables a SGUID wrapper so the CLI can authorize against the GUI app
  programs._1password = {
    enable = true;
  };

  # this doesnt seem to work
  # programs.git = {
  #   config = {
  #     gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
  #   };
  # };

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
    ports = [ 22];
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
      X11Forwarding = true;
    };
    # This part is not working
    # extraConfig = ''
    #   # PI TEST
    #   # Host *
    #   	IdentityAgent ~/.1password/agent.sock
    # '';
  };

  # SSH
  programs.ssh = {
    forwardX11 = true;
    setXAuthLocation = true;

    # This part is not working
    extraConfig = ''
      # PI TEST
      Host *
      	IdentityAgent ~/.1password/agent.sock
    '';
  };

  networking.firewall.enable = false;

  # DONT EDIT !!
  system.stateVersion = "23.11";

}

# new latest 3
