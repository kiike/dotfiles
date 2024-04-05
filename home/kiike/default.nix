{outputs, ...}: rec {
  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions
    ];
  };
  programs.home-manager.enable = true;
  home.username = "kiike";
  home.homeDirectory = "/home/kiike";
  home.stateVersion = "23.11";
  home.sessionVariables = {
    XDG_DATA_DIRS = "${home.homeDirectory}/.nix-profile/share:$XDG_DATA_DIRS";
  };
}
