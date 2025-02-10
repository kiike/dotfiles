# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../all
    ./samba
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "ehonda-pool" ];

  networking.hostName = "ehonda"; # Define your hostname.
  networking.hostId = "31f26065";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kiike = {
    isNormalUser = true;
    description = "Enric Morales";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgdjDdqEwsLigkba9C26oRW3ATZIYS5OcFLtlBzoOL7 kiike@balrog.megis.lan"
    ];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "kiike";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    helix
    #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.zrepl = {
    enable = true;
    settings = {
      jobs = [
        {
          name = "snapjob";
          type = "snap";
          filesystems = {
            "ehonda-pool<" = true;
          };
          snapshotting = {
            type = "periodic";
            interval = "15m";
            prefix = "zrepl_";
          };
          pruning = {
            keep = [
              {
                type = "grid";
                grid = "1x1h(keep=all) | 24x1h | 30x1d | 6x30d";
                regex = "^zrepl_.*";
              }
              {
                type = "regex";
                negate = true;
                regex = "^zrepl_.*";
              }
            ];
          };
        }
      ];
    };

  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
