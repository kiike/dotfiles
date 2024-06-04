{ outputs, ... }:
rec {
  nixpkgs = {
    config.allowUnfree = true;
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
  xdg.userDirs = {
    enable = true;
    download = "${home.homeDirectory}/downloads";
    documents = "${home.homeDirectory}/documents";
  };
}
