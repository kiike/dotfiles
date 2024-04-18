{
  inputs,
  pkgs,
  ...
}: {
  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.system}.default;
    configDir = ./ewwFiles;
  };
}
