# Nix


```/etc/nixos/configuration.nix
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/peter/Code/nix/configuration.nix
    ];
}
```
