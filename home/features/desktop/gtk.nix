{ pkgs, ... }:
{
  home.packages = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      gtk = {
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
    };
  };
  gtk = {
    enable = true;
    font = {
      name = "Source Sans 3";
      size = 11;
    };
    iconTheme = {
      package = pkgs.breeze-icons;
      name = "breeze-dark";
    };
    theme = {
      name = "Breeze-Dark";
      package = pkgs.breeze-gtk;
    };
  };
}
