{ pkgs, ... }:
{
  home.pointerCursor = {
    size = 24;
    package = pkgs.breeze-gtk;
    name = "breeze_cursors";
    gtk.enable = true;
    x11.enable = true;
  };
}
