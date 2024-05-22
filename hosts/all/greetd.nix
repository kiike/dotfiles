{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = lib.getExe inputs.hyprland.packages.${pkgs.system}.hyprland;
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
