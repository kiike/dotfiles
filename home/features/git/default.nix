{ pkgs, ... }:
{
  home.packages = [
    pkgs.pre-commit
    pkgs.lazygit
  ];
  programs.git = {
    enable = true;
    userName = "Enric Morales";
    userEmail = "me@enric.me";
    signing = {
      signByDefault = true;
      key = null;
    };
    aliases = {
      "s" = "status --short";
      "l" = "log --pretty=oneline --abbrev-commit";
    };
    ignores = [
      ".vscode"
      ".helix"
    ];
  };
}
