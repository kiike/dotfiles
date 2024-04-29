{
  users.users.kiike = {
    isNormalUser = true;
    description = "Enric Morales";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
      "libvirtd"
      "input"
      "video"
      "audio"
      "qemu-libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgdjDdqEwsLigkba9C26oRW3ATZIYS5OcFLtlBzoOL7 kiike@balrog.megis.lan"
    ];
  };
}
