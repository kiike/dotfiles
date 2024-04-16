{
  pkgs ? import <nixpkgs> { },
}:
rec {
  symbols-nerd-font = pkgs.callPackage ./symbols-nerd-font { };
}
