{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [
      nil
      nixfmt-rfc-style
    ];
    settings = {
      theme = "monokai_pro_octagon";
      editor = {
        file-picker = {
          ignore = true;
          hidden = false;
        };
        line-number = "relative";
        cursor-shape.insert = "bar";
        auto-save = true;
        soft-wrap = {
          enable = true;
          max-indent-retain = 90;
        };
      };
      keys = {
        normal = {
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
          esc = [
            "collapse_selection"
            ":w"
          ];
        };
        insert = {
          "esc" = [
            "normal_mode"
            ":w"
          ];
        };
        select = {
          "esc" = [
            "collapse_selection"
            "normal_mode"
            ":w"
          ];
        };
      };
    };

    languages."language-server" = {
      basedpyright = {
        command = "basedpyright-langserver";
        args = [ "--stdio" ];
        config = { };
      };
      rust-analyzer.config.check.command = "clippy";
    };

    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
      }
      {
        name = "rust";
        debugger = {
          name = "lldb-dap";
          transport = "stdio";
          command = "lldb-dap";
          templates = [
            {
              name = "binary";
              request = "launch";
              completion = [
                {
                  name = "binary";
                  completion = "filename";
                }
              ];
              args = {
                program = "{0}";
                initCommands = [ "command script import /home/kiike/.config/helix/lldb_dap_rustc_primer.py" ];
              };
            }
            {
              name = "attach";
              request = "attach";
              completion = [ "pid" ];
              args = {
                pid = "{0}";
                initcommands = [
                  "command script import ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/etc/lldb_lookup.py"
                  "command source -s 0 ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/etc/lldb_commands"
                ];
                #initCommands = [ "command script import /home/kiike/.config/helix/lldb_dap_rustc_primer.py" ];
              };
            }
          ];
        };
      }
      {
        name = "python";

        debugger = {
          name = "debugpy";
          transport = "stdio";
          command = "python3";
          args = [
            "-m"
            "debugpy.adapter"
          ];
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
