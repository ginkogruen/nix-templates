{
  description = "SuperCollider + IDE";

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
              supercollider
              self'.packages.neovim
              #supercollider-with-plugins
              #supercollider-with-sc3-plugins
            ];
          };

          packages.neovim =
            (inputs.nvf.lib.neovimConfiguration {
              pkgs = inputs'.nixpkgs.legacyPackages;
              modules = with inputs.nvf-kit.modules; [
                base
                scnvim
              ];
            }).neovim;
        };
    };
}
