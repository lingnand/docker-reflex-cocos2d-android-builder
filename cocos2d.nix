{ pkgs, ghcAndroidPkgs, androidenv }:

with ghcAndroidPkgs;

let
  # cocos2d-hs
  cocos2d-hs = mkDerivation {
    pname = "cocos2d-hs";
    version = "0.1.0.0";
    libraryHaskellDepends = [ base hoppy-runtime colour linear ];
    homepage = "https://github.com/lynnard/cocos2d-hs";
    description = "cocos2d haskell binding";
    license = "unknown";
    src = pkgs.fetchFromGitHub {
      owner = "lynnard";
      repo = "cocos2d-hs";
      rev = "899124e80e7bf499b06eebafff082dd6b8e51975";
      sha256 = "1mkzv9a5af9msywqa99chq98gaa4130zxdlfjv28crzwwwda2gq2";
    };
    configureFlags = [
      "--extra-include-dirs=${androidenv.androidndk}/libexec/${androidenv.androidndk.name}/sources/cxx-stl/gnu-libstdc++/4.9/include"
      "--extra-include-dirs=${androidenv.androidndk}/libexec/${androidenv.androidndk.name}/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi/include"
      "--extra-lib-dirs=${androidenv.androidndk}/libexec/${androidenv.androidndk.name}/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi"
    ];
  };

  # Hipmunk
  Hipmunk = import ./Hipmunk.nix { inherit pkgs ghcAndroidPkgs androidenv; };
  # reflex
  reflex = import ./reflex.nix { inherit pkgs ghcAndroidPkgs androidenv; };

  # reflex-cocos2d
  reflex-cocos2d = mkDerivation {
    pname = "reflex-cocos2d";
    version = "0.1.0.0";
    libraryHaskellDepends =
      [ base colour containers semigroups mtl monad-control prim-uniq primitive dependent-map ref-tf dependent-sum diagrams-lib reflex lens time data-default contravariant exception-transformers free cocos2d-hs StateVar MonadRandom ]
      ++Hipmunk
      ++reflex;
    homepage = "https://github.com/lynnard/reflex-cocos2d";
    description = "reflex frp abstraction on top of cocos2d-hs";
    license = "unknown";
    src = pkgs.fetchFromGitHub {
      owner = "lynnard";
      repo = "reflex-cocos2d";
      rev = "842a3bf80e0e743b71c2d93600f0b245a348964d";
      sha256 = "0a0wkmii4faz5bqip4nkr8gsr2ciq2zhn9ava1lw7qi0plbwb4jl";
    };
  };
in [ cocos2d-hs reflex-cocos2d ]
