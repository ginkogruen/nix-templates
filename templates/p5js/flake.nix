{
  description = "Processing (p5.js) + Vite";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nvf.url = "github:notashelf/nvf";
    nvf-kit.url = "git+ssh://forgejo@forgejo.ginkogruen.net/ginkogruen/nvf-kit";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          inputs',
          pkgs,
          self',
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              git
              nodejs
              patch-package
              #self'.packages.neovim
            ];
          };

          #packages.neovim =
          #  (inputs.nvf.lib.neovimConfiguration {
          #    pkgs = inputs'.nixpkgs.legacyPackages;
          #    modules = with inputs.nvf-kit.modules; [
          #      base
          #    ];
          #  }).neovim;
        };
    };
}
