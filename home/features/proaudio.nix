{ pkgs, ... }:
{
  home.packages = with pkgs; [
    reaper
    qjackctl
  ];
}
