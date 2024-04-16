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
    atuin = prev.atuin.overrideAttrs (oldAttrs: rec {
      version = "18.2.0";

      src = prev.fetchFromGitHub {
        owner = "atuinsh";
        repo = "atuin";
        rev = "v${version}";
        hash = "sha256-TTQ2XLqng7TMLnRsLDb/50yyHYuMSPZJ4H+7CEFWQQ0=";
      };

      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (
        prev.lib.const {
          name = "atuin-${version}-vendor.tar.gz";
          inherit src;
          outputHash = "sha256-KMH19Op7uyb3Z/cjT6bdmO+JEp1o2n6rWRNYmn1+0hE=";
        }
      );

      checkFlags = [
        # tries to make a network access
        "--skip=registration"
        # No such file or directory (os error 2)
        "--skip=sync"
        # PermissionDenied (Operation not permitted)
        "--skip=change_password"
        "--skip=multi_user_test"
        # Tries to touch files
        "--skip=build_aliases"
      ];
    });
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
