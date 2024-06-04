# This file defines overlays https://nixos.wiki/wiki/Overlays
{ ... }:
{
  # This one brings our custom packages from the 'packages' directory
  additions = final: _prev: import ../packages { pkgs = final; };

  modifications = final: prev: {
    nerdfonts = prev.nerdfonts.override {
      fonts = [
        "SourceCodePro"
        "Hack"
      ];
    };
    lmodern = prev.lmodern.overrideAttrs (
      {
        postInstall ? "",
        ...
      }:
      {
        postInstall =
          postInstall
          + ''
            rm -rf $out/texmf-dist
          '';
      }
    );
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  # unstable-packages = final: _prev: {
  #   unstable = import inputs.nixpkgs-unstable {
  #     system = final.system;
  #     config.allowUnfree = true;
  #   };
  # };
}
