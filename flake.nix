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

        lustre.path = ./templates/lustre;
        lustre.description = "Lustre + TailwindCSS + Gleam + nix-gleam";

        p5js.path = ./templates/p5js;
        p5js.description = "Processing (p5.js) + Vite";

        rust.path = ./templates/rust;
        rust.description = "Rust";

        supercollider.path = ./templates/supercollider;
        supercollider.description = "SuperCollider + IDE";
      };
    });
}
