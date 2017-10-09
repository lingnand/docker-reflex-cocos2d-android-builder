{ pkgs, ghcAndroidPkgs, androidenv }:

with ghcAndroidPkgs;

let
  # cocos2d-hs
  cocos2d-hs = mkDerivation {
    pname = "cocos2d-hs";
    version = "0.1.0.0";
    libraryHaskellDepends = [ base hoppy-runtime colour linear diagrams-lib lens ];
    homepage = "https://github.com/lynnard/cocos2d-hs";
    description = "cocos2d haskell binding";
    license = "unknown";
    src = pkgs.fetchFromGitHub {
      owner = "lynnard";
      repo = "cocos2d-hs";
      rev = "0cb768bc3326c4a05f67ec537a052e6c96add69f";
      sha256 = "0mk905wp0xcwi0f77h7lkfz6jsarcbb9dka22xgb0asih6azsicl";
    };
    configureFlags = [
      "--extra-include-dirs=${androidenv.androidndk}/libexec/${androidenv.androidndk.name}/sources/cxx-stl/gnu-libstdc++/4.9/include"
      "--extra-include-dirs=${androidenv.androidndk}/libexec/${androidenv.androidndk.name}/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi/include"
      "--extra-lib-dirs=${androidenv.androidndk}/libexec/${androidenv.androidndk.name}/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi"
      "-ftarget-android"
    ];
  };

in [ cocos2d-hs ]
