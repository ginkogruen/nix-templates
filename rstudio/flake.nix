{
  description = "An RStudio setup with packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs {
        inherit system;
      };
      RStudio-with-my-packages = pkgs.rstudioWrapper.override {packages = with pkgs.rPackages; [ggplot2];};
    in
      pkgs.mkShell {
        packages = with pkgs; [
          RStudio-with-my-packages
        ];

        shellHook = /*bash*/ ''
          rstudio
        '';
      };
  };
}
