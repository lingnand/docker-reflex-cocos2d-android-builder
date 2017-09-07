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
      rev = "d3536e8e5d5eca6491b2dd3605ee61a3c089f43a";
      sha256 = "1wi9vbq9bw76ajlz3m8qy2kawzsmqq4l5kbsna2zm18swb6703na";
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
      [ base colour containers semigroups mtl monad-control prim-uniq primitive dependent-map ref-tf dependent-sum diagrams-lib lens time data-default contravariant exception-transformers free cocos2d-hs StateVar MonadRandom lifted-base ]
      ++Hipmunk
      ++reflex;
    homepage = "https://github.com/lynnard/reflex-cocos2d";
    description = "reflex frp abstraction on top of cocos2d-hs";
    license = "unknown";
    src = pkgs.fetchFromGitHub {
      owner = "lynnard";
      repo = "reflex-cocos2d";
      rev = "a69f5c1e2afe66cc9365c0eb9334e525f7f8b421";
      sha256 = "015hvm8nma5y5n71h4mcz7sn61p3iij07jvhmg6ybz3kzdg6gn72";
    };
  };
in [ cocos2d-hs reflex-cocos2d ]
