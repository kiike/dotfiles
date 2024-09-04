{
  programs.waybar = {
    enable = false;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = {
      mainBar = {
        "position" = "top";
        "layer" = "top";
        "height" = 40;
        "spacing" = 4;
        "modules-left" = [
          "hyprland/workspaces"
          "hyprland/window"
          "custom/media"
        ];
        "modules-center" = [ "clock" ];
        "modules-right" = [
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "power-profiles-daemon"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "keyboard-state"
          "battery"
          "tray"
        ];
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "tray" = {
          "icon-size" = 24;
          "spacing" = 10;
        };
        "clock" = {
          "format" = "{:%a %B %d %H:%M}  ";
          "format-alt" = "{:%A, %B %d, %Y (%R)}  ";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "on-click-right" = "mode";
            "format" = {
              "months" = "<span color='#ffead3'><b>{}</b></span>";
              "days" = "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
              "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
              "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          "actions" = {
            "on-click-right" = "mode";
            "on-click-forward" = "tz_up";
            "on-click-backward" = "tz_down";
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };
        "cpu" = {
          "format" = "{usage}% ";
          "tooltip" = false;
        };
        "memory" = {
          "format" = "{}% ";
        };
        "temperature" = {
          #// "thermal-zone"= 2;
          #// "hwmon-path"= "/sys/class/hwmon/hwmon#2/temp1_input";
          "critical-threshold" = 80;
          #// "format-critical"= "{temperatureC}°C {icon}";
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = [
            ""
            ""
            ""
          ];
        };
        "backlight" = {
          #// "device"= "acpi_video1",
          "format" = "{percent}% {icon}";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "battery" = {
          "states" = {
            #"good"= 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-full" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          #// "format-good"= "";, // An empty format will hide the module
          #// "format-full"= "";,
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "battery#bat2" = {
          "bat" = "BAT2";
        };
        "power-profiles-daemon" = {
          "format" = "{icon}";
          "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
          "tooltip" = true;
          "format-icons" = {
            "default" = "";
            "performance" = "";
            "balanced" = "";
            "power-saver" = "";
          };
        };
        "network" = {
          # "interface"= "wlp2*", // (Optional) To force the use of this interface
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };
        "pulseaudio" = {
          "scroll-step" = 5;
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format;source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
        };
        "custom/media" = {
          "format" = "{icon} {}";
          "return-type" = "json";
          "max-length" = 40;
          "format-icons" = {
            "spotify" = "";
            "default" = "🎜";
          };
          "escape" = true;
          "exec" = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null"; # // Script in resources folder
        };
      };
    };
    style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "Symbols Nerd Font", "Source Sans 3";
          font-size: 16px;
        }
        window#waybar {
        background: transparent;
          color: @theme_text_color;
      }
        #workspaces button {
          padding: 0 5px;
        }
        #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
      }

      .modules-right {
            background: alpha(@theme_base_color, 0.7);
            border-radius: 12;
            margin: 7px 14px;
      }

      #workspaces button.focused {
          background-color: #64727D;
          box-shadow: inset 0 -3px #ffffff;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      label.module {
        padding: 7px;
      }

      .modules-right > widget:first-child > label.module {
        padding-left: 14px;
      }

    '';
  };
}
