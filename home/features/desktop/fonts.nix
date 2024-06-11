{ pkgs, ... }:
{
  home.packages = with pkgs; [
    source-serif
    source-sans
    source-code-pro
    lmodern
    symbols-nerd-font
  ];
  fonts.fontconfig.enable = true;
}
