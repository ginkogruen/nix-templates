{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (_: {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      flake.templates = {
        gleam.path = ./templates/gleam;
        gleam.description = "Gleam + nix-gleam";
      };
    });
}
