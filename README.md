# My configs

My configuration managed by Nix. 

## Cheatsheet

### Installation

#### System config

```
sudo nixos-rebuild switch --flake dotfiles
```

#### User config

```
nix run home-manager/master -- switch
```

# Acknowledgements

Structure inspired/copied from [Misterio77's configs](https://github.com/Misterio77/nix-starter-configs).
