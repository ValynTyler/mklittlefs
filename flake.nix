{
  description = "An empty nix devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
        packages.default = self.packages.${system}.mklittlefs;
        packages.mklittlefs = pkgs.stdenv.mkDerivation {
          name = "mklittlefs";
          src = fetchGit {
            url = "https://github.com/ValynTyler/mklittlefs.git";
            rev = "2887dead1fd78197bed706ed78afb32521b0af6c";
            submodules = true;
          };
          buildInputs = with pkgs; [ gcc git ];
          buildPhase = ''
            make dist
          '';
          installPhase = ''
            mkdir -p $out/bin/
            cp mklittlefs $out/bin/mklittlefs
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ gcc ];
        };
      }
    );
}
