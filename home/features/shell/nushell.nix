{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner: false
        completions: {
          algorithm: "fuzzy"
        }
      }
    '';
  };
}
