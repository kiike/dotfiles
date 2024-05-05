{
  pkgs ? import <nixpkgs> { },
}:
{
  symbols-nerd-font = pkgs.callPackage ./symbols-nerd-font { };
}
