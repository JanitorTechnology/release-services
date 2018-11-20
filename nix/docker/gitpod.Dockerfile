FROM gitpod/workspace-full:latest

USER root
# Install custom tools, runtime, etc.

# Apply user-specific settings
USER gitpod
RUN curl https://raw.githubusercontent.com/mozilla/release-services/master/nix/setup.sh | bash

# Give back control
USER root
