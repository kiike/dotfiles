{pkgs, ...}: {
  home.packages = [
    pkgs.qt6ct
    pkgs.kdePackages.breeze
  ];
  qt = {
    enable = true;
    platformTheme = "qtct";
  };
}
