{
  imports = [
    ./i18n
    ./avahi
  ];
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];

      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://helix.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];
    };
  };
}
