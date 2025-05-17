{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          pkgs,
          config,
          lib,
          self',
          ...
        }:
        {
          packages.stk =
            with pkgs;
            stdenv.mkDerivation (finalAttrs: {
              pname = "stk";
              version = "5.0.1";

              src = fetchFromGitHub {
                owner = "thestk";
                repo = "stk";
                rev = finalAttrs.version;
                hash = "sha256-y84OfOWFdARZApm8VHz4yjl8/7SActNVUHgvSUkwJnw=";
              };

              nativeBuildInputs = [
                pkg-config
                cmake
              ];

              meta = {
                description = "Set of Open-Source audio signal processing and algorithmic synthesis tools";
                homepage = "https://ccrma.stanford.edu/software/stk/";
                license = lib.licenses.stk; # STK is GPL-licensed
                maintainers = with lib.maintainers; [ eveeifyeve ];
                platforms = lib.platforms.unix;
              };
            });
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              cmake
              gnumake
              stdenv.cc
              clang-tools
              libsForQt5.full
              pkg-config
              libsndfile
              fftwFloat
              libsamplerate
              SDL2
              lv2
              lilv
              suil
              # slibGuile
              portaudio
              lame
              libvorbis
              fltk
              fluidsynth
              sndio
              doxygen
              bash-completion
			  self'.packages.stk
			  libsysprof-capture
			  carla
            ];
          };

          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
