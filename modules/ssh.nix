# { config, pkgs, ... }:

# Enable the OpenSSH daemon.
# services.openssh = {
#   enable = true;
#   ports = [22];
#   settings = {
#     PasswordAuthentication = true;
#     PermitRootLogin = "yes";
#     X11Forwarding = true;
#   };
# };

# SSH
# programs.ssh = {
#   forwardX11 = true;
#   setXAuthLocation = true;
# };

