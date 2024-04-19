{pkgs, ...}: {
  services.dunst = with pkgs; {
    enable = true;
    iconTheme = {
      name = "breeze-dark";
      package = breeze-icons;
      size = "32";
    };
    settings = {
      global = {
        transparency = 20;
        font = "Source Sans 3, 11";
        frame_width = 0;
        offset = "10x10";
        corner_radius = 10;
      };
      urgency_low = {
        background = "#000";
        foreground = "#f0f0f0";
      };
      urgency_normal = {
        background = "#000";
        foreground = "#f0f0f0";
      };
      urgency_critical = {
        background = "#200000";
        foreground = "#f0f0f0";
      };
    };
  };
}
