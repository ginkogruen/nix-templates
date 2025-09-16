{ pkgs, ... }:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    rusty-man
    cargo-info
  ];

  # https://devenv.sh/languages/
  languages.rust = {
    enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
