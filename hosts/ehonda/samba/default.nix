{
  services.samba = {
    enable = true;
    shares = {
      shadaloo = {
        path = "/mnt/ehonda-pool/shadaloo";
        browsable = "yes";
        writable = "yes";
      };
    };
    openFirewall = true;
  };
}
