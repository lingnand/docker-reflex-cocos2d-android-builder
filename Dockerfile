FROM busybox

ENV \
    NIX_VERSION=1.11.2 \
    NIX_PATH=/nix/var/nix/profiles/per-user/root/channels/ \
    PATH=/root/.nix-profile/bin:/root/.nix-profile/sbin:/bin:/sbin:/usr/bin:/usr/sbin \
    SSL_CERT_FILE=/root/.nix-profile/etc/ssl/certs/ca-bundle.crt

RUN wget -O- http://nixos.org/releases/nix/nix-$NIX_VERSION/nix-$NIX_VERSION-x86_64-linux.tar.bz2 | bzcat - | tar xf - \
    && echo "nixbld:x:30000:nixbld1,nixbld2,nixbld3,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,nixbld10,nixbld11,nixbld12,nixbld13,nixbld14,nixbld15,nixbld16,nixbld17,nixbld18,nixbld19,nixbld20,nixbld21,nixbld22,nixbld23,nixbld24,nixbld25,nixbld26,nixbld27,nixbld28,nixbld29,nixbld30" >> /etc/group \
    && for i in $(seq 1 30); do echo "nixbld$i:x:$((30000 + $i)):30000:::" >> /etc/passwd; done \
    && mkdir -m 0755 /nix && USER=root sh "nix-$NIX_VERSION-x86_64-linux/install" \
    && echo ". /root/.nix-profile/etc/profile.d/nix.sh" >> /etc/profile \
    && nix-collect-garbage -d \
    && rm -rf "/nix-$NIX_VERSION-x86_64-linux" /home /usr/sbin /var \
    && ln -s /bin /usr/bin \
    && nix-env -u --always \
    && nix-env -iA nixpkgs.stdenv nixpkgs.bash \
    && nix-collect-garbage -d

COPY nix-build-ghc-android /nix-build-ghc-android
# add a convenience script to facilitate running of commands inside the shell
COPY nix-build-ghc-android-runner /nix-build-ghc-android-runner

ENTRYPOINT ["nix-shell", "/nix-build-ghc-android/shell.nix"]

# build all the default env dependencies
RUN /nix-build-ghc-android-runner

# setting up cocos
# cutdown version of cocos
COPY cocos2d-x-3.9 /cocos-frameworks/cocos2d-x-3.9
ENV COCOS_FRAMEWORKS=/cocos-frameworks
# used for parsing cocos config json
RUN nix-env -iA nixpkgs.pkgs.jq

# build Hipmunk
COPY Hipmunk.nix /Hipmunk.nix
RUN /nix-build-ghc-android-runner --arg extraGhcPkgs 'import /Hipmunk.nix'

# build reflex
COPY reflex.nix /reflex.nix
RUN /nix-build-ghc-android-runner --arg extraGhcPkgs 'import /reflex.nix'

# build cocos stuff
COPY cocos2d.nix /cocos2d.nix
RUN /nix-build-ghc-android-runner --arg extraGhcPkgs 'import /cocos2d.nix'
