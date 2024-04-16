{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry_qt5;
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };
}
