{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      "add_newline" = true;

      # You can also replace your username with a neat symbol like   or disable this
      # and use the os module below
      "username" = {
        "show_always" = true;
        "style_user" = "bg:#9A348E";
        "style_root" = "bg:#9A348E";
        "format" = "[$user ]($style)";
        "disabled" = false;
      };
      # An alternative to the username module which displays a symbol that
      # represents the current operating system
      "os" = {
        "style" = "bg:#9A348E";
        "disabled" = true; # Disabled by default
      };
      "directory" = {
        "style" = "bg:#DA627D";
        "format" = "[ $path ]($style)";
        "truncation_length" = 3;
        "truncation_symbol" = "…/";
      };
      "c" = {
        "style" = "bg:#86BBD8";
        "symbol" = " ";
        "format" = "[ $symbol ($version) ]($style)";
      };
      "docker_context" = {
        "style" = "bg:#06969A";
        "format" = "[ $symbol $context ]($style)";
      };
      "git_branch" = {
        "style" = "bg:#FCA17D";
        "format" = "[ $symbol $branch ]($style)";
      };
      "git_status" = {
        "style" = "bg:#FCA17D";
        "format" = "[$all_status$ahead_behind ]($style)";
      };
      "golang" = {
        "style" = "bg:#86BBD8";
        "symbol" = " ";
        "format" = "[ $symbol ($version) ]($style)";
      };
      "nodejs" = {
        "symbol" = " ";
        "style" = "bg:#86BBD8";
        "format" = "[ $symbol ($version) ]($style)";
      };
      "rust" = {
        "symbol" = " ";
        "style" = "bg:#86BBD8";
        "format" = "[ $symbol ($version) ]($style)";
      };
      "time" = {
        "disabled" = false;
        "time_format" = "%R"; # Hour:Minute Format
        "style" = "bg:#33658A";
        "format" = "[ ♥ $time ]($style)";
      };
      "aws" = {
        "symbol" = "  ";
      };
      "directory" = {
        "read_only" = " 󰌾";
      };
      "docker_context" = {
        "symbol" = " ";
      };
      "git_branch" = {
        "symbol" = " ";
      };
      "hg_branch" = {
        "symbol" = " ";
      };
      "hostname" = {
        "ssh_symbol" = " ";
      };
      "memory_usage" = {
        "symbol" = "󰍛 ";
      };
      "nix_shell" = {
        "symbol" = " ";
        "style" = "bg:#33658A";
        "format" = "[ $symbol ($version) ]($style)";
      };
      os.symbols = {
        "Alpine" = " ";
        "Amazon" = " ";
        "Arch" = " ";
        "Artix" = " ";
        "CentOS" = " ";
        "Debian" = " ";
        "Fedora" = " ";
        "FreeBSD" = " ";
        "Linux" = " ";
        "NetBSD" = " ";
        "NixOS" = " ";
        "OpenBSD" = "󰈺 ";
        "openSUSE" = " ";
        "OracleLinux" = "󰌷 ";
        "Raspbian" = " ";
        "Redhat" = " ";
        "RedHatEnterprise" = " ";
        "SUSE" = " ";
        "Ubuntu" = " ";
        "Unknown" = " ";
        "Windows" = "󰍲 ";
      };
      "package" = {
        "symbol" = "󰏗 ";
        "format" = "[ $symbol ($version) ]($style)";
      };
      "python" = {
        "symbol" = " ";
        "style" = "bg:#86BBD8";
        "format" = "[ $symbol ($version) ]($style)";
      };
      "format" =
        (builtins.replaceStrings [ "\n" ] [ "" ] ''
          [](#9A348E)
          $os
          $username
          [](bg:#DA627D fg:#9A348E)
          $directory
          [](fg:#DA627D bg:#FCA17D)
          $git_branch
          $git_status
          [](fg:#FCA17D bg:#86BBD8)
          $c
          $golang
          $python
          $nodejs
          $rust
          [](fg:#86BBD8 bg:#06969A)
          $docker_context
          [](fg:#06969A bg:#33658A)
          $nix_shell
          [ ](fg:#33658A)
        '')
        + "\n[ ](fg:#33658A)";
    };
  };
}
