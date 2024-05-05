{ pkgs, lib, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = lib.getExe pkgs.hyprland;
        user = "kiike";
      };
    };
  };
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
}
