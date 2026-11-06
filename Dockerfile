# Pioneer Healthcare engine configuration image.
#
# Starts from the publisher's official, unmodified configuration image and
# lays our branding files over it at the same paths. Nothing else changes:
# the entrypoint, start script and every other file come from the base image.
#
# Build from the repository root:
#   docker build -t healthcare-core/config .
#   docker build --build-arg CONFIG_BASE_TAG=1.0.0 -t healthcare-core/config .
ARG CONFIG_BASE_IMAGE=bahmni/standard-config
ARG CONFIG_BASE_TAG=1.0.0
FROM ${CONFIG_BASE_IMAGE}:${CONFIG_BASE_TAG}

# Our own artwork (proprietary, see LICENSE).
COPY pioneer/openmrs/ /etc/bahmni_config/openmrs/

# Upstream file we changed (AGPL v3, see agpl-modified/NOTICE.md).
COPY agpl-modified/openmrs/ /etc/bahmni_config/openmrs/

# Same owner and permissions as the rest of the base image (root, files 644,
# folders 755), whatever user and umask the build host checked the repo out with.
RUN cd /etc/bahmni_config/openmrs/apps/home \
 && chown root:root . .. icons logo.png pioneer-healthcare-logo.png whiteLabel.json icons/*.svg \
 && chmod 755 . .. icons \
 && chmod 644 logo.png pioneer-healthcare-logo.png whiteLabel.json icons/*.svg

LABEL org.opencontainers.image.title="pioneer-healthcare-engine-data" \
      org.opencontainers.image.vendor="Pioneer AI Tech" \
      org.opencontainers.image.description="Engine configuration with Pioneer Healthcare branding"
