{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.papis.packages.${system}.default
    typst
    hayagriva
    zotero_7
  ];
}
