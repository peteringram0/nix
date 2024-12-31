{ config, pkgs, ... }:

networking = {
  networkmanager.enable = true;
  useDHCP = false;
  interfaces.eth0.useDHCP = true;
  nameservers = ["1.1.1.1" "8.8.8.8"];
  hostName = "nixos";
  
  firewall = {
    enable = true;
    allowedTCPPorts = [8000]; # httplz
    allowedUDPPorts = [8000]; # httplz
  };
  
};
