{ pkgs, lib, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      cat = "${lib.getExe pkgs.bat}";
    };
    extraConfig = ''
      $env.config = {
        show_banner: false
        shell_integration: {
          osc2: true
          osc8: true
          osc9_9: true
          osc133: true
          osc633: true
        }
        hooks: {
          env_change: {
            PWD: [{|before, after| print $'($after)'}]
          }
        }
      }
    '';
  };
}
