{
  description = "My systems configs. Following the patterns of github:Misterio77/nix-starter-configs";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    papis = {
      url = "github:papis/papis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    papis-zotero = {
      url = "github:kiike/papis-zotero/?ref=feat/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:helix-editor/helix/";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    autofirma-nix.url = "git+https://github.com/nilp0inter/autofirma-nix/";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-index-database,
      autofirma-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      lib = nixpkgs.lib // home-manager.lib;
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in
    {
      inherit lib;
      packages = forEachSystem (pkgs: import ./packages { inherit pkgs; });
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        dhalsim = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/dhalsim ];
        };

        balrog = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/balrog ];
        };
        ehonda = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./hosts/ehonda ];
        };
      };
      homeConfigurations = {
        "kiike@dhalsim" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            nix-index-database.hmModules.nix-index
            autofirma-nix.homeManagerModules.default
            ./home/kiike/dhalsim
            ./home/features/nvidia.nix
          ];
        };
        "kiike@ehonda" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            nix-index-database.hmModules.nix-index
            ./home/kiike/ehonda
          ];
        };
        "kiike@balrog" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            autofirma-nix.homeManagerModules.default
            nix-index-database.hmModules.nix-index
            ./home/kiike/balrog
          ];
        };
      };
    };
}
