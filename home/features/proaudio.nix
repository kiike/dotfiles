{ pkgs, lib, ... }:
let
  wrapperName = "reaper-session";
in
{
  home.packages = with pkgs; [

    reaper
    qjackctl
    (writeScriptBin wrapperName ''
      #!/usr/bin/env nix-shell
      #! nix-shell -i bash -p bash icewm

      DISPLAY=:$(${lib.getExe xwayland} -reset -terminate -displayfd 1 &)
      echo $DISPLAY
      ${lib.getExe' reaper "reaper"} &
      exec ${lib.getExe' icewm "icewm-session"} &
      wait $server
    '')
    (pkgs.makeDesktopItem {
      desktopName = wrapperName;
      name = wrapperName;
      exec = wrapperName;
      icon = "cockos-reaper";
    })
  ];
}
