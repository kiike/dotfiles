{
  description = "My systems configs. Following the patterns of github:Misterio77/nix-starter-configs";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:kiike/ags/wip/rectangular-progress";

    autofirma-nix.url = "git+https://github.com/nilp0inter/autofirma-nix/";

    niri.url = "git+https://github.com/sodiboo/niri-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-index-database,
      niri,
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
          modules = [
            inputs.niri.nixosModules.niri
            ./hosts/balrog
          ];
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
            niri.homeModules.config
            ./home/kiike/dhalsim
            ./home/features/nvidia.nix
          ];
        };
        "kiike" = home-manager.lib.homeManagerConfiguration {
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
            niri.homeModules.config
            ./home/kiike/balrog
          ];
        };
      };
    };
}
