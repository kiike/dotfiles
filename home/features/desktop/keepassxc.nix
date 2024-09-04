{ pkgs, ... }:
{
  home.packages = [ pkgs.keepassxc ];
  systemd.user.services."keepassxc" = {
    Unit = {
      PartOf = "graphical-session.target";
      After = [
        "graphical-session.target"
        "tray.target"
      ];
      Requisite = "graphical-session.target";
    };
    Service = {
      # Delay start by a bit to let the tray settle
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2s";
      ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
