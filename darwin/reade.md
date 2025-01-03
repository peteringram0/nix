Install:
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install --determinate
```

Setup:
```bash
nix run nix-darwin -- switch --flake ~/nix#simple
```

Run To Apply Updated Config:
```bash
darwin-rebuild switch --flake ~/nix#simple
```
