{
  description = "A nix-flake for a supercollider dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {self, nixpkgs, ...}: let
    system = "x86_64-linux";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs {
        inherit system;
      };
    in pkgs.mkShell {
      packages = with pkgs; [
        supercollider
      ];

      shellHook = ''
	echo "Launching SuperCollider IDE"
	scide
	#exec fish
      '';
    };
  };
}
