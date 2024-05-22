{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
      preload = ~/Pictures/wallpapers/simpsons/homer_sky_upscaled_3440x1440.png
      wallpaper = ,~/Pictures/wallpapers/simpsons/homer_sky_upscaled_3440x1440.png
      splash = false
    '';
    # ".config/xdg-desktop-portal/hyprland-portals.conf".text = ''
    #   [preferred]
    #   default=hyprland;gtk
    #   org.freedesktop.impl.portal.FileChooser=kde
    # '';
  };
  home.packages = with pkgs; [
    grim
    slurp
    satty
    hyprlock
    hyprpicker
    hyprpaper
    xdg-desktop-portal-hyprland
    xdg-desktop-portal
    hyprland-activewindow
    hyprland-workspaces
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config = {
      common = {
        default = [ "hyprland" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
      hyprland = {
        default = [ "hyprland" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      };
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.outputs.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    settings = {
      exec-once = [
        "hyprpaper"
        "eww open bar"
        "sleep 5s; dex -a"
        "sleep 10s; nheko"
      ];

      "monitor" = ",preferred,auto,1";
      "$terminal" = "alacritty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";

      env = [
        "XCURSOR_SIZE,24"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "intl";
        kb_options = "caps:swapescape";
        follow_mouse = 1;
      };

      general = {
        gaps_in = "10";
        gaps_out = "15";
        border_size = "2";
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 10;

        blur = {
          enabled = "true";
          size = 3;
          passes = 1;
        };

        drop_shadow = "yes";
        shadow_range = "4";
        shadow_render_power = "3";
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = "yes"; # you probably want this
      };

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
      };

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$mainMod" = "SUPER";

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind =
        let
          pacmd = lib.getExe' pkgs.pulseaudio "pacmd";
          satty = lib.getExe pkgs.satty;
          grim = lib.getExe pkgs.grim;
          brightnessctl = lib.getExe pkgs.brightnessctl;
        in
        [
          "$mainMod, RETURN, exec, $terminal"
          "$mainMod, ESCAPE, killactive, "
          "$mainMod SHIFT, ESCAPE, exit, "
          "$mainMod, E, exec, $fileManager"
          "$mainMod, F, togglefloating,"
          "$mainMod, SPACE, exec, $menu"
          "$mainMod SHIFT, S, pseudo,"
          "$mainMod, S, togglesplit,"

          # Use satty for screenshots
          ",Print,exec,${grim} - | ${satty} --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png"

          # Volume
          ",XF86AudioRaiseVolume,exec,${pacmd} --increase 5"
          ",XF86AudioLowerVolume,exec,${pacmd} --decrease 5"
          ",XF86AudioMute,exec,${pacmd} --toggle-mute"

          # Brightness
          ",XF86MonBrightnessUp,exec,${brightnessctl} set +5%"
          ",XF86MonBrightnessDown,exec,${brightnessctl} set 5%-"

          # Move focus with mainMod + arrow keys
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

          # Switch workspaces with mainMod + [0-9]"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Example special workspace (scratchpad)"
          "$mainMod, P, togglespecialworkspace, magic"
          "$mainMod SHIFT, P, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mainMod + scroll"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Move/resize windows with mainMod + LMB/RMB and dragging"
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:272, resizeactive"

          "$mainMod, V, exec, clipman pick -t wofi"
        ];
    };
    extraConfig = ''
      bind=$mainMod,R,submap,resize
      submap=resize
      binde=,l,resizeactive,20 0
      binde=,h,resizeactive,-20 0
      binde=,k,resizeactive,0 -20
      binde=,j,resizeactive,0 20
      bind=,escape,submap,reset
      submap=reset

      bind=$mainMod,M,submap,move
      submap=move
      binde=,h,swapwindow,l
      binde=,l,swapwindow,r
      binde=,k,swapwindow,u
      binde=,j,swapwindow,d
      bind=,escape,submap,reset
      submap=reset
    '';
  };
}
