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
      "Mod+L".action = focus-window-down-or-column-right;
      "Mod+H".action = focus-window-up-or-column-left;
      "Mod+Shift+H".action = move-column-left;
      "Mod+Shift+L".action = move-column-right;
      "Mod+Control+H".action = set-column-width "-10%";
      "Mod+Control+L".action = set-column-width "+10%";
      "Mod+y".action = consume-or-expel-window-left;
      "Mod+p".action = consume-or-expel-window-right;
      "Mod+Space".action = spawn "fuzzel";
      "Print".action = sh ''${grim} | ${satty} --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png'';
      "Mod+A".action = show-hotkey-overlay;

      "Mod+Shift+J".action = move-window-to-monitor-left;
      "Mod+Shift+K".action = move-window-to-monitor-right;

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
      options = "caps:swapescape";
    };
    spawn-at-startup = [
      { command = [ "hyprpaper" ]; }
      { command = [ "ags" ]; }
    ];
  };
}
