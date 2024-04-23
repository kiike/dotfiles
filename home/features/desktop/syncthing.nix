{ pkgs, ... }:
{
  home.packages = [
    pkgs.syncthing-tray
    pkgs.qsyncthingtray
  ];
}
