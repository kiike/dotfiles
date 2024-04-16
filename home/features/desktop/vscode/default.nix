{ pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "vscode" ];
  programs.vscode.enable = true;
}
