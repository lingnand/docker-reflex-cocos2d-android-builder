{ pkgs, ghcAndroidPkgs, androidenv }:

with ghcAndroidPkgs;

let
  # cocos2d
  cocos2d = import ./cocos2d.nix { inherit pkgs ghcAndroidPkgs androidenv; };
  # Hipmunk
  Hipmunk = import ./Hipmunk.nix { inherit pkgs ghcAndroidPkgs androidenv; };
  # reflex
  reflex = import ./reflex.nix { inherit pkgs ghcAndroidPkgs androidenv; };

  # reflex-cocos2d
  reflex-cocos2d = mkDerivation {
    pname = "reflex-cocos2d";
    version = "0.1.0.0";
    libraryHaskellDepends =
      [ base colour containers semigroups mtl monad-control prim-uniq primitive dependent-map ref-tf dependent-sum diagrams-lib lens time data-default contravariant exception-transformers free StateVar MonadRandom lifted-base ]
      ++Hipmunk
      ++reflex
      ++cocos2d;
    homepage = "https://github.com/lynnard/reflex-cocos2d";
    description = "reflex frp abstraction on top of cocos2d-hs";
    license = "unknown";
    src = pkgs.fetchFromGitHub {
      owner = "lynnard";
      repo = "reflex-cocos2d";
      rev = "07d822a9d4b6cb529437bff6c12be8a845e1fc88";
      sha256 = "0w7jwh1igfj05ca5pmn2vbqbyz82jd21nb08hpxw7b646rcr42fl";
    };
  };

in [ reflex-cocos2d ]