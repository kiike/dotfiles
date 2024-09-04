{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xdg-desktop-portal
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [ "niri" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
      niri = {
        default = [ "gnome" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
    };
  };
}
