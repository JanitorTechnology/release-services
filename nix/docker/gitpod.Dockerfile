FROM gitpod/workspace-full:latest

USER root
# Install custom tools, runtime, etc.
RUN curl https://raw.githubusercontent.com/mozilla/release-services/master/nix/setup.sh | bash

# Apply user-specific settings
USER gitpod


# Give back control
USER root
