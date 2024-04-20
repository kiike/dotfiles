{
  pkgs ? import <nixpkgs> { },
}:
{
  symbols-nerd-font = pkgs.callPackage ./symbols-nerd-font { };
  hyprland-activewindow = pkgs.callPackage ./hyprland-activewindow.nix { };
  hyprland-workspaces = pkgs.callPackage ./hyprland-workspaces.nix { };
}
