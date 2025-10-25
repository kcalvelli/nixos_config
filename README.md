# Personal NixOS Configurations

Personal NixOS machine configurations based on [axiOS](https://github.com/kcalvelli/axios).

## Structure

This repository contains only personal machine-specific configurations:

- `hosts/` - Host configurations (edge, pangolin)
- `keith.nix` - User definition
- `flake.nix` - Entry point that imports axiOS as a library

All system modules, home-manager configs, packages, and documentation come from the [axiOS framework](https://github.com/kcalvelli/axios).

## Usage

### Switch to this configuration

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

### Update axiOS framework

```bash
nix flake update
```

### Pin to specific axiOS version

Edit `flake.lock` or specify version in `flake.nix`:
```nix
axios.url = "github:kcalvelli/axios/<commit-or-tag>";
```

## Adding a New Host

1. Create `hosts/<hostname>.nix` based on `hosts/TEMPLATE.nix`
2. Create disk configuration in `hosts/<hostname>/disks.nix`
3. Add to `flake.nix`:
```nix
# User module path
userModule = self.outPath + "/keith.nix";  # or your user file name

<hostname>Cfg = (import ./hosts/<hostname>.nix { 
  lib = nixpkgs.lib;
  userModulePath = userModule;
}).hostConfig;
```
4. Register in outputs:
```nix
nixosConfigurations = {
  <hostname> = axios.lib.mkSystem <hostname>Cfg;
};
```

## Documentation

See the [axiOS documentation](https://github.com/kcalvelli/axios/tree/master/docs) for:
- Installation guides
- Package lists
- Configuration options
- Module reference

## License

MIT
