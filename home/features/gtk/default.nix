{pkgs, ...}: {
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
