FROM gitpod/workspace-full:latest

USER root

# Set up Nix. Source: https://docs.mozilla-releng.net/develop/install-nix.html

USER gitpod
RUN sudo mkdir -m 0755 /nix \
 && sudo chown $USER /nix \
 && curl https://nixos.org/nix/install | sh

USER root
RUN mkdir -p /etc/nix \
 && echo 'binary-caches = https://s3.amazonaws.com/releng-cache/ https://cache.nixos.org/' > /etc/nix/nix.conf
RUN groupadd -r nixbld \
 && for n in $(seq 1 10); do useradd -c "Nix build user $n" \
      -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" \
      nixbld$n; done
RUN echo "build-users-group = nixbld" >> /etc/nix/nix.conf \
 && chown -R root:nixbld /nix \
 && chmod 1777 /nix/var/nix/profiles/per-user \
 && mkdir -m 1777 -p /nix/var/nix/gcroots/per-user

USER gitpod
RUN sudo echo "build-use-sandbox = true" >> /etc/nix/nix.conf \
 && sudo mkdir -p /nix/var/nix/profiles \
 && sudo /home/$USER/.nix-profile/bin/nix-env -iA nixpkgs.bash -p /nix/var/nix/profiles/sandbox \
 && sudo echo "build-sandbox-paths = /bin/sh=`realpath /nix/var/nix/profiles/sandbox/bin/bash` `nix-store -qR \`realpath /nix/var/nix/profiles/sandbox/bin/bash\` | tr '\n' ' '`" >> /etc/nix/nix.conf

# Give back control
USER root
