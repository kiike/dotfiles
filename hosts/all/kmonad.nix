{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.kmonad ];
  users.groups.uinput = { };
  services.udev.extraRules = ''
    # KMonad user access to /dev/uinput
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';
}
