{
  networking.enableIPv6 = false;
  services.resolved.enable = true;
  services.avahi = {
    enable = true;
    allowInterfaces = null;
    publish.enable = true;
  };
  services.openssh = {
    enable = true;
    openFirewall = true;
  };
}
