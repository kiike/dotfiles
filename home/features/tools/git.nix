{ pkgs, ... }:
{
  home.packages = [
    pkgs.pre-commit
    pkgs.lazygit
  ];
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions = [ pkgs.gh-dash ];
  };
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
      "review-pr" = "!f() { git fetch -fu \${2:-origin} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f";
    };
    ignores = [
      ".vscode"
      ".helix"
    ];
  };
}
