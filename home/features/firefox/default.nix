{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = [
        pkgs.tridactyl-native
      ];
    };
  };
}
