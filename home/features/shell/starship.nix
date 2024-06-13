let
  colors = {
    # primary colors
    "red" = "#ff657a";
    "orange" = "#ff9b5e";
    "yellow" = "#ffd76d";
    "green" = "#bad761";
    "blue" = "#9cd1bb";
    "purple" = "#c39ac9";
    # base colors
    "base0" = "#161821";
    "base1" = "#1e1f2b";
    "base2" = "#282a3a";
    "base3" = "#3a3d4b";
    "base4" = "#535763";
    "base5" = "#696d77";
    "base6" = "#767b81";
    "base7" = "#b2b9bd";
    "base8" = "#eaf2f1";
    # variants
    "base8x0c" = "#303342";
    # gradient
    gradient = [
      "#282a39"
      "#353f50"
      "#415667"
      "#4d6e7c"
      "#5b8690"
      "#6ca0a1"
      "#82b9af"
      "#9dd2bc"
    ];
  };
  styles = {
    programmingLanguages = "bg:${colors.base0}";
  };
in
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
        "format" = "$user";
        "disabled" = false;
      };
      "directory" = {
        "format" = "$path";
        "truncation_length" = 3;
        "truncation_symbol" = "…/";
      };
      "c" = {
        "symbol" = " ";
        "format" = "$symbol ($version)";
      };
      "docker_context" = {
        "format" = "$symbol $context";
      };
      "git_branch" = {
        "format" = "$symbol $branch";
      };
      "git_status" = {
        "format" = "$all_status$ahead_behind";
      };
      "golang" = {
        "symbol" = " ";
        "format" = "$symbol ($version)";
      };
      "nodejs" = {
        "symbol" = " ";
        "format" = "$symbol ($version)";
      };
      "rust" = {
        "symbol" = " ";
        "format" = "$symbol ($version)";
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
        "ssh_only" = false;
        "format" = "$hostname";
      };
      "memory_usage" = {
        "symbol" = "󰍛 ";
      };
      "nix_shell" = {
        "symbol" = " ";
        "format" = "$symbol $state $name";
      };
      "package" = {
        "symbol" = "󰏗 ";
        "format" = "$symbol ($version)";
      };
      "python" = {
        "symbol" = " ";
        "format" = "$symbol ($version)";
      };
      "format" =
        with builtins;
        (replaceStrings [ "\n" ] [ "" ] ''
          [](${elemAt colors.gradient 0})
          [$username ](bg:${elemAt colors.gradient 0})

          [](fg:${elemAt colors.gradient 0} bg:${elemAt colors.gradient 1})
          [ $hostname ](bg:${elemAt colors.gradient 1})

          [](fg:${elemAt colors.gradient 1} bg:${elemAt colors.gradient 2})
          [ $directory ](bg:${elemAt colors.gradient 2})

          [](fg:${elemAt colors.gradient 2} bg:${elemAt colors.gradient 3})
          [ $git_branch $git_commit $git_status ](bg:${elemAt colors.gradient 3})

          [](fg:${elemAt colors.gradient 3} bg:${elemAt colors.gradient 4})
          [ ${
            builtins.concatStringsSep "" [
              "$golang"
              "$python"
              "$nodejs"
              "$rust"
            ]
          } ](bg:${elemAt colors.gradient 4})
          [](fg:${elemAt colors.gradient 5} bg:${elemAt colors.gradient 6})
          $docker_context
          [](fg:${elemAt colors.gradient 6})
          $nix_shell
        '')
        + "\n[ ](fg:${elemAt colors.gradient 7})";
    };
  };
}
