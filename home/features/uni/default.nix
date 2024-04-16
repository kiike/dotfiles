{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    inputs.papis.packages.${system}.papis
    inputs.papis-zotero.packages.${system}.papis-zotero
    typst
    hayagriva
    zotero_7
  ];
}
