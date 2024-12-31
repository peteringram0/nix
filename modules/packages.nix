{ config, pkgs, ... }:

environment.systemPackages = with pkgs; [

  # WIP
  # polybar

  # Generic system
  wget
  openssh
  git
  screenfetch
  xclip
  _1password
  _1password-gui
  obsidian
  discord

  # Dev Enviroment
  oh-my-zsh
  zsh
  zsh-completions
  delta
  bat
  yazi
  eza
  starship
  docker
  httplz # serve alterntive
  flyctl
  ripgrep

  # Dev Tooling
  unstable.zellij
  unstable.ghostty
  chezmoi
  lazygit

  # Language Servers
  nil # .nix LS

  # Yew project
  cargo-tauri
  trunk
  
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
  rustup
  gcc

];
