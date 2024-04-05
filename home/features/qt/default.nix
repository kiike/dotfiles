{pkgs, ...}: {
  home.packages = [
    pkgs.qt6ct
  ];
  qt = {
    enable = true;
    platformTheme = "qtct";
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
  };
}
