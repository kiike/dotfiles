{
  pkgs,
  config,
  lib,
  ...
}:
let
  pacmd = lib.getExe' pkgs.pulseaudio "pacmd";
  satty = lib.getExe pkgs.satty;
  grim = lib.getExe pkgs.grim;
  brightnessctl = lib.getExe pkgs.brightnessctl;
  sh = config.lib.niri.actions.spawn "sh" "-c";
  wallpaper = "/home/kiike/Pictures/wallpapers/simpsons/homer_sky_upscaled_3440x1440.png";
in
{
  home.packages = [
    pkgs.niri-unstable
    pkgs.fuzzel
  ];
  programs.niri.settings = {
    binds = with config.lib.niri.actions; {
      "Mod+Return".action = spawn "kitty";
      "Mod+Shift+E".action = quit;

      "Mod+L".action = focus-column-or-monitor-right;
      "Mod+H".action = focus-column-or-monitor-left;
      "Mod+K".action = focus-window-up;
      "Mod+J".action = focus-window-down;

      "Mod+Shift+H".action = move-column-left;
      "Mod+Shift+L".action = move-column-right;
      "Mod+Shift+J".action = move-window-to-monitor-left;
      "Mod+Shift+K".action = move-window-to-monitor-right;

      "Mod+Y".action = focus-workspace-up;
      "Mod+U".action = focus-workspace-down;
      "Mod+I".action = focus-monitor-left;
      "Mod+P".action = focus-monitor-right;

      "Mod+C".action = consume-or-expel-window-left;

      "Mod+Control+H".action = set-column-width "-10%";
      "Mod+Control+L".action = set-column-width "+10%";
      "Mod+Space".action = spawn "fuzzel";
      "Print".action = sh ''${grim} | ${satty} --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png'';
      "Mod+A".action = show-hotkey-overlay;

      "Mod+Escape".action = close-window;

      # Volume
      "XF86AudioRaiseVolume".action = spawn pacmd "--increase" "5";
      "XF86AudioLowerVolume".action = spawn pacmd "--decrease" "5";
      "XF86AudioMute".action = spawn pacmd "--toggle-mute";

      # Brightness
      "XF86MonBrightnessUp".action = spawn brightnessctl "set" "+5%";
      "XF86MonBrightnessDown".action = spawn brightnessctl "set" "5%-";
    };
    input.keyboard.xkb = {
      layout = "us";
      variant = "intl";
      options = "caps:swapescape,numpad:mac";
    };

    outputs = {
      "eDP-1".position = {
        x = 0;
        y = 0;
      };
    };

    environment = {
      QT_QPA_PLATFORM = "wayland";
      DISPLAY = null;
    };

    prefer-no-csd = false;

    layout.focus-ring.active.gradient = {
      from = "#0080A0";
      to = "#00A0A0";
    };
  };

  systemd.user.services."swaybg" = {
    Unit = {
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${wallpaper}";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
