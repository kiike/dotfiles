{
  programs.alacritty = {
    enable = true;
    settings = {
      shell = "nu";
      font.normal.family = "SauceCodePro NF Medium";
      window.opacity = 0.8;
      bell = {
        duration = 1;
        color = "#ff0000";
        animation = "EaseOut";
      };
    };
  };
}
