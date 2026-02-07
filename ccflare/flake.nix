{
  description = "Claude API proxy with intelligent load balancing";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        ccflare = pkgs.stdenv.mkDerivation rec {
          pname = "ccflare";
          version = "0.1.0";

          src = pkgs.fetchFromGitHub {
            owner = "snipeship";
            repo = "ccflare";
            rev = "688921203f5035e09740ad4f8208d222122d9ea9";
            hash = "sha256-JDrk+BDGMI535JGTwZdf+iYAwHouLi9Yq+cRIxc/3Yk=";
          };

          nativeBuildInputs = [ pkgs.bun pkgs.makeWrapper ];

          buildPhase = ''
            runHook preBuild

            export HOME=$TMPDIR
            bun install --frozen-lockfile
            bun run build

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/lib/ccflare
            cp -r . $out/lib/ccflare

            mkdir -p $out/bin
            makeWrapper ${pkgs.bun}/bin/bun $out/bin/ccflare \
              --add-flags "run" \
              --add-flags "--cwd $out/lib/ccflare" \
              --add-flags "ccflare"

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Claude API proxy with intelligent load balancing across multiple accounts";
            homepage = "https://github.com/snipeship/ccflare";
            license = licenses.mit;
            maintainers = [ ];
            platforms = platforms.all;
          };
        };
        dockerImage = pkgs.dockerTools.buildLayeredImage {
          name = "ccflare";
          tag = "latest";
          contents = [ ccflare pkgs.bun pkgs.cacert ];
          config = {
            Cmd = [ "${ccflare}/bin/ccflare" ];
            ExposedPorts = {
              "8080/tcp" = { };
            };
            Env = [
              "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
            ];
          };
        };
      in
      {
        packages = {
          default = ccflare;
          ccflare = ccflare;
          docker = dockerImage;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.bun ];
        };
      }
    );
}
