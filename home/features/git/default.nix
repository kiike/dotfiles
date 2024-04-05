{pkgs, ...}: {
  home.packages = [
    pkgs.pre-commit
  ];
  programs.git = {
    enable = true;
    userName = "Enric Morales";
    userEmail = "me@enric.me";
  };
}
