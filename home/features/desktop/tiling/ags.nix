{ inputs, pkgs, ... }:
let
  ags = inputs.ags.packages.${pkgs.system}.ags;
in
{
  home.packages = [ ags ];

  systemd.user.services."ags" = {
    Unit = {
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
      PartOf = [
        "graphical-session.target"
        "tray.target"
      ];
    };
    Service = {
      ExecStart = "${ags}/bin/ags";
    };
    Install = {
      WantedBy = [
        "graphical-session.target"
      ];
    };
  };
}
