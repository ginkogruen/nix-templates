{
  # TODO: Check if packaging via 'nix-gleam' works.
  description = "Lustre (with TailwindCSS) + Gleam development and packaging via 'nix-gleam'.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-gleam.url = "github:arnarg/nix-gleam";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (_: {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          lib,
          system,
          pkgs,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.nix-gleam.overlays.default
            ];
          };

          # Dev shell for 'direnv'
          devShells.default =
            let
              # This script sets up the needed files with some light templating
              # Mirroring 'gleam new .' to some extend
              # as it doesn't like existing '.gitignore' files.
              init-project =
                pkgs.writers.writeNuBin "init-project" # nu
                  ''
                    # Check if repo is initialized
                    if ('.git' | path exists) {
                      exit 0
                    }

                    # Read project folder name
                    # and convert it to snake_case to satisfy Gleam
                    let project_name = './' 
                    | path expand
                    | path basename
                    | str snake-case

                    # List of files where a placeholder should be replaced
                    const files = [
                      ./gleam.toml
                      ./README.md
                      ./src/@@@PROJECT@@@.gleam
                      ./test/@@@PROJECT@@@_test.gleam
                      ./index.html
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
              link-lustre-binaries =
                pkgs.writers.writeNuBin "link-lustre-binaries" # nu
                  ''
                    # Check if '.git' exists to prevent running this from a path thats not the repo root
                    if not ('.git' | path exists) {
                      exit 0
                    }

                    if not ('./build/.lustre/bin' | path exists) {
                      mkdir ./build/.lustre/bin
                    }

                    # FIX: I couldn't get lustre to pick up on the tailwindcss binary; It would still download it.
                    #if not (('./build/.lustre/bin/tailwind' | path type) == 'symlink') {
                    #  rm --force ./build/.lustre/bin/tailwind
                    #  ln --symbolic -T ${lib.getExe pkgs.tailwindcss_4} ./build/.lustre/bin/tailwind
                    #}

                    if not (('./build/.lustre/bin/esbuild' | path type) == 'symlink') {
                      rm --force ./build/.lustre/bin/esbuild
                      ln --symbolic -T ${lib.getExe pkgs.esbuild} ./build/.lustre/bin/esbuild
                    }
                  '';
              # NOTE: For running tailwindcss and lustre together
              # This is needed (or convenient) because I couldn't get supplying my own
              # TailwindCSS to work (neither pkg in path nor symlink shenanigans).
              #
              # NOTE: It is run with this command
              #concurrently --success first --raw \
              #'tailwindcss -i src/@@@PROJECT@@@.css -o priv/static/@@@PROJECT@@@.css -w' \
              #'gleam run -m lustre/dev start --detect-tailwind=false'
              run-dev-server = pkgs.writers.writeBashBin "run-dev-server" ''
                ${lib.getExe pkgs.concurrently} --sucess first --raw \
                '${lib.getExe pkgs.tailwindcss_4} -i src/styles.css -o priv/static/styles.css -w' \
                '${lib.getExe pkgs.gleam} run -m lustre/dev start --detect-tailwind=false'
              '';

            in
            pkgs.mkShell {
              packages = [
                # Gleam specific tooling
                pkgs.gleam
                pkgs.erlang
                pkgs.rebar3

                # Generic dev tooling
                pkgs.git
                pkgs.jujutsu

                # For lustre specifically
                pkgs.inotify-tools
                pkgs.tailwindcss_4
                pkgs.nodejs
                pkgs.esbuild

                run-dev-server
              ];

              shellHook = ''
                ${lib.getExe init-project}
                ${lib.getExe link-lustre-binaries}
              '';
            };

          # Packaging done through 'buildGleamApplication' from 'nix-gleam'
          packages.default = pkgs.buildGleamApplication {
            src = ./.;
          };
        };
    });
}
