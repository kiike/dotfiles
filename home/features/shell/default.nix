{pkgs, ...}: {
  imports = [
    ./atuin.nix
    ./bash.nix
    ./carapace.nix
    ./direnv.nix
    ./nushell.nix
    ./starship.nix
  ];
}
