{ pkgs, ghcAndroidPkgs, androidenv }:

with ghcAndroidPkgs;

let
  Hipmunk = mkDerivation {
      pname = "Hipmunk";
      version = "6.2.2.1";
      libraryHaskellDepends = [ base array containers transformers StateVar linear lens data-default ];
      homepage = "https://github.com/lynnard/Hipmunk";
      description = "Chipmunk haskell binding";
      license = "unknown";
      src = pkgs.fetchFromGitHub {
        owner = "lynnard";
        repo = "Hipmunk";
        rev = "c489b6f416866fb22e2aaa467ffa666b007faa27";
        sha256 = "1mva0iw45vf5qh8yxrgm0sl2rjwq0zlvs7yxpzrcgzka5mgf4kjv";
      };
    };
in [ Hipmunk ]