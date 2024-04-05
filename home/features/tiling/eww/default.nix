{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.eww.packages.${pkgs.system}.default
  ];
}
