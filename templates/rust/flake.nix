{
  description = "Rust development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (_: {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { lib, pkgs, ... }:
        {
          devShells.default =
            let
              # This script sets up the needed files with some light templating
              # Mirroring 'cargo init' to some extend.
              init-project =
                pkgs.writers.writeNuBin "init-project" # nu
                  ''
                    # Check if repo is initialized
                    if ('.git' | path exists) {
                      exit 0
                    }

                    # Read project folder name
                    # and convert it to kebab-case
                    let project_name = './' 
                    | path expand
                    | path basename
                    | str kebab-case

                    # List of files where a placeholder should be replaced
                    const files = [
                      ./Cargo.toml
                    ]

                    def replace-placeholder-name [input: string] {
                      $input | str replace --all '@@@PROJECT@@@' $'($project_name)'
                    }

                    for file in $files { 
                      let new_path = (replace-placeholder-name $file)
                      open --raw $file
                      | decode utf-8
                      | replace-placeholder-name $in
                      | save -f $new_path

                      # Clean up files with placeholder names
                      if $file != $new_path {
                        rm $file
                      }
                    }

                    # Initialize git repository
                    ^${lib.getExe pkgs.git} init

                    # Initialize jj repository
                    ^${lib.getExe pkgs.jujutsu} git init --colocate
                  '';
            in
            pkgs.mkShell {
              packages = [
                # Rust specific tooling
                pkgs.cargo
                pkgs.cargo-info
                pkgs.rusty-man
                pkgs.clippy
                pkgs.rustfmt
                pkgs.rust-analyzer
                pkgs.rustc

                # Generic dev tooling
                pkgs.git
                pkgs.jujutsu

                # Custom setup script
                init-project
              ];

              shellHook = ''
                ${lib.getExe init-project}
              '';
            };
        };
    });
}
