{
  inputs,
  pkgs,
  lib,
  outputs,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [
      alejandra
      nil
      nixd
      nixfmt-rfc-style
      python311Packages.python-lsp-ruff
      python311Packages.python-lsp-server
      python312
      python312Packages.debugpy
      typst-lsp
      pyright
    ];
    settings = {
      theme = "monokai_pro";
      editor = {
        line-number = "relative";
        cursor-shape.insert = "bar";
      };
    };

    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.alejandra;
      }
      {
        name = "python";

        debugger = {
          name = "debugpy";
          transport = "stdio";
          command = "python3";
          args = ["-m" "debugpy.adapter"];
          templates = [
            {
              name = "source";
              request = "launch";
              completion = [
                {
                  name = "entrypoint";
                  completion = "filename";
                  default = ".";
                }
              ];
              args = {
                mode = "debug";
                program = "{0}";
              };
            }
          ];
        };
      }
    ];
  };
}
