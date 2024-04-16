{ pkgs, ... }:
{
  home.packages = with pkgs; [
    source-serif
    source-sans
    lmodern
    nerdfonts
    symbols-nerd-font
  ];
  fonts.fontconfig.enable = true;
}
