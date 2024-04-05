{pkgs, ...}: {
  home.packages = [
    pkgs.xdg-desktop-portal-gtk
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config = {
      common = {
        default = [
          "hyprland"
        ];
      };
      gtk = {
        "org.freedesktop.impl.portal.Settings" = [
          "gtk"
        ];
      };
    };
  };
  gtk = {
    enable = true;
    font = {
      name = "Source Sans 3";
      size = 11;
    };
    cursorTheme = {
      size = 24;
      package = pkgs.breeze-gtk;
      name = "breeze_cursors";
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
