{
  programs.bash = {
    enable = true;
    profileExtra = ''
      export XDG_DATA_DIRS="/home/kiike/.nix-profile/share:$XDG_DATA_DIRS"
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
    '';
  };
}
