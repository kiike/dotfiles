{
  inputs,
  pkgs,
  ...
}: {
  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    package = inputs.atuin.packages.${pkgs.system}.default;
    settings = {
      key = "~/Documents/keys/atuin.key";
    };
  };
}
