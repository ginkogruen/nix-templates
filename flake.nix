{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (_: {
      flake.templates = {
        gleam.path = ./templates/gleam;
        gleam.description = "Gleam + nix-gleam";

        rust.path = ./templates/rust;
        rust.description = "Rust + devenv";
      };
    });
}
