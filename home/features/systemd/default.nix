{pkgs, ...}: {
  systemd.user.startServices = "sd-switch";
  systemd.user.sessionVariables = {
    XDG_DATA_DIRS = "/home/kiike/.nix-profile/share:$XDG_DATA_DIRS";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent.socket";
  };

  # KeePassXC-managed SSH agent
  systemd.user.services.ssh-agent = {
    Unit = {
      ConditionEnvironment = "!SSH_AGENT_PID";
      Description = "OpenSSH key agent";
      Documentation = ["man:ssh-agent(1)" "man:ssh-add(1)" "man:ssh(1)]"];
    };

    Service = {
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
      PassEnvironment = "SSH_AGENT_PID";
      SuccessExitStatus = "2";
      Type = "simple";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
