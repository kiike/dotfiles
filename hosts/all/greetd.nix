{ ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "niri-session";
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
